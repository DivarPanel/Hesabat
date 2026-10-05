-- DecorConcept POS V2 migration
create extension if not exists pgcrypto;

create table if not exists public.warehouses (
  id uuid primary key default gen_random_uuid(),
  code text not null unique,
  name text not null,
  address text,
  active boolean not null default true,
  created_at timestamptz not null default now()
);

create table if not exists public.warehouse_stock (
  warehouse_id uuid not null references public.warehouses(id) on delete cascade,
  product_id uuid not null references public.products(id) on delete cascade,
  stock numeric(14,3) not null default 0 check (stock >= 0),
  updated_at timestamptz not null default now(),
  primary key (warehouse_id, product_id)
);

alter table public.stock_movements add column if not exists warehouse_id uuid references public.warehouses(id);
alter table public.sales add column if not exists warehouse_id uuid references public.warehouses(id);
alter table public.returns add column if not exists warehouse_id uuid references public.warehouses(id);
alter table public.sales add column if not exists updated_at timestamptz not null default now();
alter table public.sales add column if not exists updated_by uuid references public.users(id);
alter table public.returns add column if not exists reason text;

insert into public.warehouses(code,name,address)
select 'ANB-01','Əsas anbar',''
where not exists (select 1 from public.warehouses where code='ANB-01');

update public.stock_movements set warehouse_id=(select id from public.warehouses where code='ANB-01') where warehouse_id is null;
update public.sales set warehouse_id=(select id from public.warehouses where code='ANB-01') where warehouse_id is null;
update public.returns set warehouse_id=(select id from public.warehouses where code='ANB-01') where warehouse_id is null;

insert into public.warehouse_stock(warehouse_id,product_id,stock)
select w.id,p.id,p.stock from public.warehouses w cross join public.products p
where w.code='ANB-01'
on conflict (warehouse_id,product_id) do update set stock=excluded.stock, updated_at=now();

create or replace function public.stock_in_atomic(p_user_id uuid,p_product_id uuid,p_qty numeric,p_cost numeric,p_warehouse_id uuid)
returns boolean language plpgsql security definer set search_path=public,extensions as $$
begin
  if p_qty<=0 or p_cost<0 then raise exception 'Məlumat yanlışdır'; end if;
  if not exists(select 1 from products where id=p_product_id and active=true) then raise exception 'Məhsul tapılmadı'; end if;
  if not exists(select 1 from warehouses where id=p_warehouse_id and active=true) then raise exception 'Anbar tapılmadı'; end if;
  insert into warehouse_stock(warehouse_id,product_id,stock) values(p_warehouse_id,p_product_id,p_qty)
  on conflict(warehouse_id,product_id) do update set stock=warehouse_stock.stock+p_qty,updated_at=now();
  update products set stock=(select coalesce(sum(stock),0) from warehouse_stock where product_id=p_product_id),purchase_price=p_cost,updated_at=now() where id=p_product_id;
  insert into stock_movements(product_id,user_id,warehouse_id,movement_type,qty,unit_cost) values(p_product_id,p_user_id,p_warehouse_id,'purchase',p_qty,p_cost);
  return true;
end $$;

create or replace function public.create_sale_atomic(
  p_user_id uuid,p_customer_id uuid,p_payment_type text,p_discount numeric,p_items jsonb,p_warehouse_id uuid
) returns jsonb language plpgsql security definer set search_path=public,extensions as $$
declare v_sale_id uuid;v_invoice text;v_sub numeric:=0;v_total numeric:=0;x jsonb;v_product products%rowtype;v_qty numeric;v_price numeric;v_cost numeric;v_whstock numeric;
begin
 if p_payment_type not in ('cash','card','transfer','debt') then raise exception 'Ödəniş növü yanlışdır'; end if;
 if p_discount<0 or jsonb_array_length(p_items)=0 then raise exception 'Satış məlumatı yanlışdır'; end if;
 if not exists(select 1 from warehouses where id=p_warehouse_id and active=true) then raise exception 'Anbar tapılmadı'; end if;
 v_invoice:='DC-'||to_char(timezone('Asia/Baku',now()),'YYYYMMDD-HH24MISS')||'-'||upper(substr(replace(gen_random_uuid()::text,'-',''),1,5));
 for x in select * from jsonb_array_elements(p_items) loop
  select * into v_product from products where id=(x->>'product_id')::uuid and active=true for update;
  if not found then raise exception 'Məhsul tapılmadı'; end if;
  v_qty:=(x->>'qty')::numeric;v_price:=(x->>'unit_price')::numeric;
  select stock into v_whstock from warehouse_stock where warehouse_id=p_warehouse_id and product_id=v_product.id for update;
  if coalesce(v_whstock,0)<v_qty then raise exception 'Stok kifayət deyil: %',v_product.name; end if;
  if v_qty<=0 or v_price<0 then raise exception 'Miqdar/qiymət yanlışdır'; end if;
  v_sub:=v_sub+v_qty*v_price;
 end loop;
 v_total:=greatest(0,v_sub-p_discount);
 insert into sales(invoice_no,customer_id,user_id,warehouse_id,subtotal,discount,total,payment_type,status) values(v_invoice,p_customer_id,p_user_id,p_warehouse_id,v_sub,p_discount,v_total,p_payment_type,'completed') returning id into v_sale_id;
 for x in select * from jsonb_array_elements(p_items) loop
  select * into v_product from products where id=(x->>'product_id')::uuid for update;
  v_qty:=(x->>'qty')::numeric;v_price:=(x->>'unit_price')::numeric;v_cost:=v_product.purchase_price;
  insert into sale_items(sale_id,product_id,qty,unit_price,purchase_cost) values(v_sale_id,v_product.id,v_qty,v_price,v_cost);
  update warehouse_stock set stock=stock-v_qty,updated_at=now() where warehouse_id=p_warehouse_id and product_id=v_product.id;
  update products set stock=(select coalesce(sum(stock),0) from warehouse_stock where product_id=v_product.id),updated_at=now() where id=v_product.id;
  insert into stock_movements(product_id,user_id,warehouse_id,movement_type,qty,unit_cost,reference_id) values(v_product.id,p_user_id,p_warehouse_id,'sale',v_qty,v_cost,v_sale_id);
 end loop;
 if p_customer_id is not null then update customers set total_purchase=total_purchase+v_total,balance=case when p_payment_type='debt' then balance+v_total else balance end,updated_at=now() where id=p_customer_id; end if;
 if p_payment_type in ('cash','card','transfer') then insert into payments(sale_id,customer_id,amount,payment_type) values(v_sale_id,p_customer_id,v_total,p_payment_type); end if;
 return jsonb_build_object('sale_id',v_sale_id,'invoice_no',v_invoice,'subtotal',v_sub,'discount',p_discount,'total',v_total);
end $$;

create or replace function public.return_sale_item(p_user_id uuid,p_sale_id uuid,p_product_id uuid,p_qty numeric,p_reason text,p_warehouse_id uuid)
returns jsonb language plpgsql security definer set search_path=public,extensions as $$
declare v_item sale_items%rowtype;v_sale sales%rowtype;v_returned numeric;v_amount numeric;
begin
 if p_qty<=0 then raise exception 'Miqdar yanlışdır'; end if;
 select * into v_sale from sales where id=p_sale_id and status='completed' for update;
 if not found then raise exception 'Qaimə tapılmadı'; end if;
 select * into v_item from sale_items where sale_id=p_sale_id and product_id=p_product_id limit 1;
 if not found then raise exception 'Məhsul bu qaimədə yoxdur'; end if;
 select coalesce(sum(qty),0) into v_returned from returns where sale_id=p_sale_id and product_id=p_product_id;
 if v_returned+p_qty>v_item.qty then raise exception 'Qaytarma miqdarı satılan miqdardan çoxdur'; end if;
 v_amount:=p_qty*v_item.unit_price;
 insert into returns(sale_id,product_id,user_id,warehouse_id,qty,amount,reason) values(p_sale_id,p_product_id,p_user_id,p_warehouse_id,p_qty,v_amount,p_reason);
 insert into warehouse_stock(warehouse_id,product_id,stock) values(p_warehouse_id,p_product_id,p_qty) on conflict(warehouse_id,product_id) do update set stock=warehouse_stock.stock+p_qty,updated_at=now();
 update products set stock=(select coalesce(sum(stock),0) from warehouse_stock where product_id=p_product_id),updated_at=now() where id=p_product_id;
 insert into stock_movements(product_id,user_id,warehouse_id,movement_type,qty,unit_cost,reference_id) values(p_product_id,p_user_id,p_warehouse_id,'return',p_qty,v_item.purchase_cost,p_sale_id);
 if v_sale.customer_id is not null then update customers set total_purchase=greatest(0,total_purchase-v_amount),balance=case when v_sale.payment_type='debt' then greatest(0,balance-v_amount) else balance end,updated_at=now() where id=v_sale.customer_id; end if;
 return jsonb_build_object('ok',true,'amount',v_amount);
end $$;

create or replace function public.admin_edit_sale(p_user_id uuid,p_sale_id uuid,p_customer_id uuid,p_payment_type text,p_discount numeric,p_items jsonb,p_warehouse_id uuid)
returns jsonb language plpgsql security definer set search_path=public,extensions as $$
declare oldsales sales%rowtype;x jsonb;it sale_items%rowtype;v_product products%rowtype;v_qty numeric;v_price numeric;v_sub numeric:=0;v_total numeric;v_old_stock numeric;
begin
 if not exists(select 1 from users where id=p_user_id and role='admin' and active=true) then raise exception 'Yalnız admin qaiməni dəyişə bilər'; end if;
 select * into oldsales from sales where id=p_sale_id and status='completed' for update; if not found then raise exception 'Qaimə tapılmadı'; end if;
 for it in select * from sale_items where sale_id=p_sale_id loop
  insert into warehouse_stock(warehouse_id,product_id,stock) values(oldsales.warehouse_id,it.product_id,it.qty) on conflict(warehouse_id,product_id) do update set stock=warehouse_stock.stock+it.qty,updated_at=now();
  update products set stock=(select coalesce(sum(stock),0) from warehouse_stock where product_id=it.product_id),updated_at=now() where id=it.product_id;
 end loop;
 if oldsales.customer_id is not null then update customers set total_purchase=greatest(0,total_purchase-oldsales.total),balance=case when oldsales.payment_type='debt' then greatest(0,balance-oldsales.total) else balance end,updated_at=now() where id=oldsales.customer_id; end if;
 if exists(select 1 from returns where sale_id=p_sale_id) then raise exception 'Bu qaimədə qaytarma var; əvvəl qaytarmanı nəzərə alın'; end if;
 delete from payments where sale_id=p_sale_id; delete from stock_movements where reference_id=p_sale_id; delete from sale_items where sale_id=p_sale_id;
 for x in select * from jsonb_array_elements(p_items) loop
  select * into v_product from products where id=(x->>'product_id')::uuid and active=true for update; if not found then raise exception 'Məhsul tapılmadı'; end if;
  v_qty:=(x->>'qty')::numeric;v_price:=(x->>'unit_price')::numeric;
  select stock into v_old_stock from warehouse_stock where warehouse_id=p_warehouse_id and product_id=v_product.id for update;
  if coalesce(v_old_stock,0)<v_qty then raise exception 'Stok kifayət deyil: %',v_product.name; end if;
  v_sub:=v_sub+v_qty*v_price;
 end loop;
 v_total:=greatest(0,v_sub-p_discount);
 update sales set customer_id=p_customer_id,user_id=oldsales.user_id,warehouse_id=p_warehouse_id,subtotal=v_sub,discount=p_discount,total=v_total,payment_type=p_payment_type,status='edited',updated_at=now(),updated_by=p_user_id where id=p_sale_id;
 for x in select * from jsonb_array_elements(p_items) loop
  select * into v_product from products where id=(x->>'product_id')::uuid for update;v_qty:=(x->>'qty')::numeric;v_price:=(x->>'unit_price')::numeric;
  insert into sale_items(sale_id,product_id,qty,unit_price,purchase_cost) values(p_sale_id,v_product.id,v_qty,v_price,v_product.purchase_price);
  update warehouse_stock set stock=stock-v_qty,updated_at=now() where warehouse_id=p_warehouse_id and product_id=v_product.id;
  update products set stock=(select coalesce(sum(stock),0) from warehouse_stock where product_id=v_product.id),updated_at=now() where id=v_product.id;
  insert into stock_movements(product_id,user_id,warehouse_id,movement_type,qty,unit_cost,reference_id) values(v_product.id,p_user_id,p_warehouse_id,'sale',v_qty,v_product.purchase_price,p_sale_id);
 end loop;
 if p_customer_id is not null then update customers set total_purchase=total_purchase+v_total,balance=case when p_payment_type='debt' then balance+v_total else balance end,updated_at=now() where id=p_customer_id; end if;
 if p_payment_type in ('cash','card','transfer') then insert into payments(sale_id,customer_id,amount,payment_type) values(p_sale_id,p_customer_id,v_total,p_payment_type); end if;
 return jsonb_build_object('ok',true,'sale_id',p_sale_id,'invoice_no',oldsales.invoice_no,'total',v_total);
end $$;

create or replace function public.dashboard_today()
returns jsonb language plpgsql security definer set search_path=public,extensions as $$
declare d date:=timezone('Asia/Baku',now())::date;s numeric:=0;p numeric:=0;r numeric:=0;e numeric:=0;l integer:=0;top_name text;top_qty numeric:=0;busy_day text;busy_total numeric:=0;
begin
 select coalesce(sum(total),0) into s from sales where (created_at at time zone 'Asia/Baku')::date=d and status in('completed','edited');
 select coalesce(sum(si.profit),0) into p from sale_items si join sales sa on sa.id=si.sale_id where (sa.created_at at time zone 'Asia/Baku')::date=d and sa.status in('completed','edited');
 select coalesce(sum(amount),0) into r from returns where (created_at at time zone 'Asia/Baku')::date=d;
 select coalesce(sum(amount),0) into e from expenses where (created_at at time zone 'Asia/Baku')::date=d;
 select count(*) into l from products where active=true and stock<=min_stock;
 select p.name,coalesce(sum(si.qty),0) into top_name,top_qty from sale_items si join sales sa on sa.id=si.sale_id join products p on p.id=si.product_id where sa.status in('completed','edited') group by p.id,p.name order by sum(si.qty) desc limit 1;
 select to_char((sa.created_at at time zone 'Asia/Baku')::date,'DD.MM.YYYY'),sum(sa.total) into busy_day,busy_total from sales sa where sa.status in('completed','edited') group by (sa.created_at at time zone 'Asia/Baku')::date order by sum(sa.total) desc limit 1;
 return jsonb_build_object('server_time',to_char(timezone('Asia/Baku',now()),'DD.MM.YYYY HH24:MI:SS'),'sales',s,'profit',p,'returns',r,'expenses',e,'low_stock',l,'top_product',coalesce(top_name,'-'),'top_product_qty',top_qty,'busy_day',coalesce(busy_day,'-'),'busy_day_total',busy_total,'recent',coalesce((select jsonb_agg(z) from (select sa.id,sa.invoice_no,to_char(timezone('Asia/Baku',sa.created_at),'DD.MM.YYYY HH24:MI') created_at,coalesce(c.name,'Nağd Müştəri') customer_name,sa.total from sales sa left join customers c on c.id=sa.customer_id order by sa.created_at desc limit 12) z),'[]'::jsonb));
end $$;

insert into public.warehouse_stock(warehouse_id,product_id,stock)
select (select id from warehouses where code='ANB-01'),id,stock from products
on conflict (warehouse_id,product_id) do nothing;

alter table public.warehouses enable row level security;
alter table public.warehouse_stock enable row level security;

revoke all on function public.stock_in_atomic(uuid,uuid,numeric,numeric,uuid) from public,anon,authenticated;
revoke all on function public.create_sale_atomic(uuid,uuid,text,numeric,jsonb,uuid) from public,anon,authenticated;
revoke all on function public.return_sale_item(uuid,uuid,uuid,numeric,text,uuid) from public,anon,authenticated;
revoke all on function public.admin_edit_sale(uuid,uuid,uuid,text,numeric,jsonb,uuid) from public,anon,authenticated;
revoke all on function public.dashboard_today() from public,anon,authenticated;
