-- DecorConcept POS - Supabase PostgreSQL schema
-- Timezone policy: all timestamps are timestamptz; reporting/display uses Asia/Baku.
create extension if not exists pgcrypto;

create table if not exists public.users (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  role text not null check (role in ('admin','staff')),
  pin_hash text not null,
  active boolean not null default true,
  created_at timestamptz not null default now()
);

create table if not exists public.products (
  id uuid primary key default gen_random_uuid(),
  code text not null unique,
  barcode text unique,
  name text not null,
  category text,
  unit text not null default 'ədəd',
  purchase_price numeric(14,2) not null default 0 check (purchase_price >= 0),
  sale_price numeric(14,2) not null default 0 check (sale_price >= 0),
  stock numeric(14,3) not null default 0 check (stock >= 0),
  min_stock numeric(14,3) not null default 0 check (min_stock >= 0),
  active boolean not null default true,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.customers (
  id uuid primary key default gen_random_uuid(),
  code text not null unique,
  name text not null,
  phone text,
  address text,
  balance numeric(14,2) not null default 0,
  total_purchase numeric(14,2) not null default 0,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.sales (
  id uuid primary key default gen_random_uuid(),
  invoice_no text not null unique,
  customer_id uuid references public.customers(id),
  user_id uuid not null references public.users(id),
  subtotal numeric(14,2) not null check (subtotal >= 0),
  discount numeric(14,2) not null default 0 check (discount >= 0),
  total numeric(14,2) not null check (total >= 0),
  payment_type text not null check (payment_type in ('cash','card','transfer','debt')),
  status text not null default 'completed' check (status in ('completed','cancelled','returned','edited')),
  created_at timestamptz not null default now()
);

create table if not exists public.sale_items (
  id uuid primary key default gen_random_uuid(),
  sale_id uuid not null references public.sales(id) on delete cascade,
  product_id uuid not null references public.products(id),
  qty numeric(14,3) not null check (qty > 0),
  unit_price numeric(14,2) not null check (unit_price >= 0),
  purchase_cost numeric(14,2) not null default 0 check (purchase_cost >= 0),
  line_total numeric(14,2) generated always as (qty * unit_price) stored,
  profit numeric(14,2) generated always as (qty * (unit_price - purchase_cost)) stored
);

create table if not exists public.payments (
  id uuid primary key default gen_random_uuid(),
  sale_id uuid references public.sales(id),
  customer_id uuid references public.customers(id),
  amount numeric(14,2) not null check (amount >= 0),
  payment_type text not null check (payment_type in ('cash','card','transfer')),
  created_at timestamptz not null default now()
);

create table if not exists public.stock_movements (
  id uuid primary key default gen_random_uuid(),
  product_id uuid not null references public.products(id),
  user_id uuid not null references public.users(id),
  movement_type text not null check (movement_type in ('purchase','sale','return','adjustment')),
  qty numeric(14,3) not null check (qty > 0),
  unit_cost numeric(14,2) not null default 0,
  reference_id uuid,
  created_at timestamptz not null default now()
);

create table if not exists public.expenses (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references public.users(id),
  description text not null,
  amount numeric(14,2) not null check (amount > 0),
  payment_type text not null check (payment_type in ('cash','card','transfer')),
  created_at timestamptz not null default now()
);

create table if not exists public.returns (
  id uuid primary key default gen_random_uuid(),
  sale_id uuid references public.sales(id),
  product_id uuid not null references public.products(id),
  user_id uuid not null references public.users(id),
  qty numeric(14,3) not null check (qty > 0),
  amount numeric(14,2) not null check (amount >= 0),
  reason text,
  created_at timestamptz not null default now()
);

create table if not exists public.user_sessions (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references public.users(id) on delete cascade,
  token_hash text not null unique,
  expires_at timestamptz not null,
  created_at timestamptz not null default now()
);

create index if not exists idx_products_name on public.products(lower(name));
create index if not exists idx_products_barcode on public.products(barcode);
create index if not exists idx_sales_created_at on public.sales(created_at desc);
create index if not exists idx_sale_items_sale on public.sale_items(sale_id);
create index if not exists idx_stock_movements_product on public.stock_movements(product_id, created_at desc);
create index if not exists idx_sessions_hash on public.user_sessions(token_hash);

alter table public.users enable row level security;
alter table public.products enable row level security;
alter table public.customers enable row level security;
alter table public.sales enable row level security;
alter table public.sale_items enable row level security;
alter table public.payments enable row level security;
alter table public.stock_movements enable row level security;
alter table public.expenses enable row level security;
alter table public.returns enable row level security;
alter table public.user_sessions enable row level security;

-- No direct browser policies: all business operations go through the Edge Function.
-- service_role is used only inside the Edge Function.

insert into public.users(name, role, pin_hash)
select 'Bəhram','admin',crypt('3285', gen_salt('bf'))
where not exists (select 1 from public.users where name='Bəhram');

insert into public.users(name, role, pin_hash)
select 'Sadiq','staff',crypt('2255', gen_salt('bf'))
where not exists (select 1 from public.users where name='Sadiq');

create or replace function public.server_time_baku()
returns text language sql stable as $$
  select to_char(timezone('Asia/Baku', now()), 'DD.MM.YYYY HH24:MI:SS');
$$;

-- Atomic sale transaction. The Edge Function calls this RPC with validated UUIDs.
create or replace function public.create_sale_atomic(
  p_user_id uuid,
  p_customer_id uuid,
  p_payment_type text,
  p_discount numeric,
  p_items jsonb
) returns jsonb
language plpgsql security definer set search_path=public
as $$
declare
  v_sale_id uuid;
  v_invoice text;
  v_sub numeric := 0;
  v_total numeric := 0;
  x jsonb;
  v_product products%rowtype;
  v_qty numeric;
  v_price numeric;
  v_cost numeric;
begin
  if p_payment_type not in ('cash','card','transfer','debt') then raise exception 'Ödəniş növü yanlışdır'; end if;
  if p_discount < 0 then raise exception 'Endirim yanlışdır'; end if;
  if jsonb_array_length(p_items)=0 then raise exception 'Səbət boşdur'; end if;

  v_invoice := 'DC-' || to_char(timezone('Asia/Baku',now()),'YYYYMMDD-HH24MISS') || '-' || upper(substr(replace(gen_random_uuid()::text,'-',''),1,5));

  for x in select * from jsonb_array_elements(p_items) loop
    select * into v_product from products where id=(x->>'product_id')::uuid and active=true for update;
    if not found then raise exception 'Məhsul tapılmadı'; end if;
    v_qty := (x->>'qty')::numeric;
    v_price := (x->>'unit_price')::numeric;
    if v_qty <= 0 or v_price < 0 then raise exception 'Miqdar/qiymət yanlışdır'; end if;
    if v_product.stock < v_qty then raise exception 'Stok kifayət deyil: %', v_product.name; end if;
    v_sub := v_sub + v_qty*v_price;
  end loop;

  v_total := greatest(0, v_sub-p_discount);

  insert into sales(invoice_no,customer_id,user_id,subtotal,discount,total,payment_type)
  values(v_invoice,p_customer_id,p_user_id,v_sub,p_discount,v_total,p_payment_type)
  returning id into v_sale_id;

  for x in select * from jsonb_array_elements(p_items) loop
    select * into v_product from products where id=(x->>'product_id')::uuid for update;
    v_qty := (x->>'qty')::numeric;
    v_price := (x->>'unit_price')::numeric;
    v_cost := v_product.purchase_price;
    insert into sale_items(sale_id,product_id,qty,unit_price,purchase_cost) values(v_sale_id,v_product.id,v_qty,v_price,v_cost);
    update products set stock=stock-v_qty,updated_at=now() where id=v_product.id;
    insert into stock_movements(product_id,user_id,movement_type,qty,unit_cost,reference_id)
    values(v_product.id,p_user_id,'sale',v_qty,v_cost,v_sale_id);
  end loop;

  if p_customer_id is not null then
    update customers set total_purchase=total_purchase+v_total,
      balance=case when p_payment_type='debt' then balance+v_total else balance end,
      updated_at=now() where id=p_customer_id;
  end if;

  if p_payment_type in ('cash','card','transfer') then
    insert into payments(sale_id,customer_id,amount,payment_type) values(v_sale_id,p_customer_id,v_total,p_payment_type);
  end if;

  return jsonb_build_object('sale_id',v_sale_id,'invoice_no',v_invoice,'subtotal',v_sub,'discount',p_discount,'total',v_total);
end $$;

revoke all on function public.create_sale_atomic(uuid,uuid,text,numeric,jsonb) from public, anon, authenticated;


create or replace function public.verify_pin(p_hash text, p_pin text)
returns boolean language sql stable security definer set search_path=public as $$
  select crypt(p_pin,p_hash)=p_hash;
$$;
revoke all on function public.verify_pin(text,text) from public, anon, authenticated;

create or replace function public.stock_in_atomic(p_user_id uuid,p_product_id uuid,p_qty numeric,p_cost numeric)
returns boolean language plpgsql security definer set search_path=public as $$
begin
  if p_qty<=0 or p_cost<0 then raise exception 'Məlumat yanlışdır'; end if;
  update products set stock=stock+p_qty,purchase_price=p_cost,updated_at=now() where id=p_product_id and active=true;
  if not found then raise exception 'Məhsul tapılmadı'; end if;
  insert into stock_movements(product_id,user_id,movement_type,qty,unit_cost) values(p_product_id,p_user_id,'purchase',p_qty,p_cost);
  return true;
end $$;
revoke all on function public.stock_in_atomic(uuid,uuid,numeric,numeric) from public, anon, authenticated;

create or replace function public.dashboard_today()
returns jsonb language plpgsql security definer set search_path=public as $$
declare d date := timezone('Asia/Baku',now())::date; s numeric:=0;p numeric:=0;r numeric:=0;e numeric:=0;l integer:=0;
begin
 select coalesce(sum(total),0) into s from sales where (created_at at time zone 'Asia/Baku')::date=d and status='completed';
 select coalesce(sum(si.profit),0) into p from sale_items si join sales sa on sa.id=si.sale_id where (sa.created_at at time zone 'Asia/Baku')::date=d and sa.status='completed';
 select coalesce(sum(amount),0) into r from returns where (created_at at time zone 'Asia/Baku')::date=d;
 select coalesce(sum(amount),0) into e from expenses where (created_at at time zone 'Asia/Baku')::date=d;
 select count(*) into l from products where active=true and stock<=min_stock;
 return jsonb_build_object(
 'server_time',to_char(timezone('Asia/Baku',now()),'DD.MM.YYYY HH24:MI:SS'),
 'sales',s,'profit',p,'returns',r,'expenses',e,'low_stock',l,
 'recent',coalesce((select jsonb_agg(z) from (select sa.invoice_no, to_char(timezone('Asia/Baku',sa.created_at),'DD.MM.YYYY HH24:MI') created_at,coalesce(c.name,'Nağd Müştəri') customer_name,sa.total from sales sa left join customers c on c.id=sa.customer_id order by sa.created_at desc limit 12) z),'[]'::jsonb));
end $$;
revoke all on function public.dashboard_today() from public, anon, authenticated;
