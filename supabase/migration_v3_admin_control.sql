-- DecorConcept POS V3 - Admin panel, audit, expenses, stock history, day closing
create extension if not exists pgcrypto;

alter table public.user_sessions add column if not exists login_at timestamptz not null default now();
alter table public.user_sessions add column if not exists logout_at timestamptz;
alter table public.users add column if not exists phone text;
alter table public.users add column if not exists updated_at timestamptz not null default now();

create table if not exists public.day_closings (
  id uuid primary key default gen_random_uuid(),
  business_date date not null unique,
  closed_by uuid not null references public.users(id),
  closed_at timestamptz not null default now(),
  note text
);

create index if not exists idx_day_closings_date on public.day_closings(business_date desc);
create index if not exists idx_user_sessions_login on public.user_sessions(login_at desc);
create index if not exists idx_stock_movements_created on public.stock_movements(created_at desc);
create index if not exists idx_returns_created on public.returns(created_at desc);
create index if not exists idx_expenses_created on public.expenses(created_at desc);

create or replace function public.is_day_closed(p_date date default timezone('Asia/Baku',now())::date)
returns boolean language sql stable security definer set search_path=public as $$
  select exists(select 1 from public.day_closings where business_date=p_date);
$$;

create or replace function public.require_open_day(p_user_id uuid)
returns void language plpgsql security definer set search_path=public as $$
begin
  if exists(select 1 from users where id=p_user_id and role='admin' and active=true) then return; end if;
  if public.is_day_closed() then raise exception 'Bu günün hesabı bağlanıb. Əməliyyat dəyişmək mümkün deyil.'; end if;
end $$;

-- Existing atomic operations are replaced with a day-close guard.
create or replace function public.stock_in_atomic(p_user_id uuid,p_product_id uuid,p_qty numeric,p_cost numeric,p_warehouse_id uuid)
returns boolean language plpgsql security definer set search_path=public,extensions as $$
begin
  perform public.require_open_day(p_user_id);
  if p_qty<=0 or p_cost<0 then raise exception 'Məlumat yanlışdır'; end if;
  if not exists(select 1 from products where id=p_product_id and active=true) then raise exception 'Məhsul tapılmadı'; end if;
  if not exists(select 1 from warehouses where id=p_warehouse_id and active=true) then raise exception 'Anbar tapılmadı'; end if;
  insert into warehouse_stock(warehouse_id,product_id,stock) values(p_warehouse_id,p_product_id,p_qty)
  on conflict(warehouse_id,product_id) do update set stock=warehouse_stock.stock+p_qty,updated_at=now();
  update products set stock=(select coalesce(sum(stock),0) from warehouse_stock where product_id=p_product_id),purchase_price=p_cost,updated_at=now() where id=p_product_id;
  insert into stock_movements(product_id,user_id,warehouse_id,movement_type,qty,unit_cost) values(p_product_id,p_user_id,p_warehouse_id,'purchase',p_qty,p_cost);
  return true;
end $$;

-- Day close: only admin, one close per business day.
create or replace function public.close_business_day(p_user_id uuid,p_note text default null)
returns jsonb language plpgsql security definer set search_path=public,extensions as $$
declare d date:=timezone('Asia/Baku',now())::date; x jsonb;
begin
  if not exists(select 1 from users where id=p_user_id and role='admin' and active=true) then raise exception 'Yalnız admin gün sonunu bağlaya bilər'; end if;
  insert into day_closings(business_date,closed_by,note) values(d,p_user_id,p_note) on conflict(business_date) do nothing;
  if not exists(select 1 from day_closings where business_date=d) then raise exception 'Gün sonu bağlana bilmədi'; end if;
  select jsonb_build_object('business_date',d,'closed_at',closed_at,'closed_by',u.name) into x from day_closings dc join users u on u.id=dc.closed_by where dc.business_date=d;
  return x;
end $$;

create or replace function public.reopen_business_day(p_user_id uuid,p_date date default timezone('Asia/Baku',now())::date)
returns boolean language plpgsql security definer set search_path=public,extensions as $$
begin
  if not exists(select 1 from users where id=p_user_id and role='admin' and active=true) then raise exception 'Yalnız admin günü aça bilər'; end if;
  delete from day_closings where business_date=p_date;
  return true;
end $$;

create or replace function public.create_expense(p_user_id uuid,p_description text,p_amount numeric,p_payment_type text)
returns jsonb language plpgsql security definer set search_path=public,extensions as $$
declare id uuid;
begin
  perform public.require_open_day(p_user_id);
  if trim(coalesce(p_description,''))='' or p_amount<=0 then raise exception 'Xərc məlumatı yanlışdır'; end if;
  if p_payment_type not in ('cash','card','transfer') then raise exception 'Ödəniş növü yanlışdır'; end if;
  insert into expenses(user_id,description,amount,payment_type) values(p_user_id,trim(p_description),p_amount,p_payment_type) returning expenses.id into id;
  return jsonb_build_object('id',id);
end $$;

-- Admin user management.
create or replace function public.admin_upsert_user(p_admin_id uuid,p_user_id uuid,p_name text,p_role text,p_pin text,p_phone text,p_active boolean)
returns jsonb language plpgsql security definer set search_path=public,extensions as $$
declare uid uuid; ph text;
begin
  if not exists(select 1 from users where id=p_admin_id and role='admin' and active=true) then raise exception 'Yalnız admin istifadəçi dəyişə bilər'; end if;
  if trim(coalesce(p_name,''))='' or p_role not in ('admin','staff') then raise exception 'İstifadəçi məlumatı yanlışdır'; end if;
  if p_user_id is null then
    if trim(coalesce(p_pin,''))='' then raise exception 'Yeni istifadəçi üçün PIN tələb olunur'; end if;
    ph:=crypt(p_pin,gen_salt('bf'));
    insert into users(name,role,pin_hash,phone,active) values(trim(p_name),p_role,ph,nullif(trim(coalesce(p_phone,'')),''),coalesce(p_active,true)) returning id into uid;
  else
    if p_pin is not null and trim(p_pin)<>'' then ph:=crypt(p_pin,gen_salt('bf')); end if;
    update users set name=trim(p_name),role=p_role,phone=nullif(trim(coalesce(p_phone,'')),''),active=p_active,updated_at=now(),pin_hash=coalesce(ph,pin_hash) where id=p_user_id returning id into uid;
    if uid is null then raise exception 'İstifadəçi tapılmadı'; end if;
  end if;
  return jsonb_build_object('id',uid);
end $$;

create or replace function public.admin_delete_user(p_admin_id uuid,p_user_id uuid)
returns boolean language plpgsql security definer set search_path=public,extensions as $$
begin
  if not exists(select 1 from users where id=p_admin_id and role='admin' and active=true) then raise exception 'Yalnız admin istifadəçi silə bilər'; end if;
  if p_admin_id=p_user_id then raise exception 'Öz admin hesabınızı silə bilməzsiniz'; end if;
  update users set active=false,updated_at=now() where id=p_user_id;
  return true;
end $$;

-- Protect the already existing edit/delete operations with day close.
-- Admin is intentionally exempt, so admin can correct anything after close.
-- These wrappers are easiest enforced in the Edge Function too; SQL functions below are hardened.

create or replace function public.admin_delete_sale(p_user_id uuid,p_sale_id uuid)
returns jsonb language plpgsql security definer set search_path=public,extensions as $$
declare s sales%rowtype; it sale_items%rowtype;
begin
 if not exists(select 1 from users where id=p_user_id and role='admin' and active=true) then raise exception 'Yalnız admin qaimə silə bilər'; end if;
 select * into s from sales where id=p_sale_id for update;
 if not found then raise exception 'Qaimə tapılmadı'; end if;
 for it in select * from sale_items where sale_id=p_sale_id loop
   insert into warehouse_stock(warehouse_id,product_id,stock) values(s.warehouse_id,it.product_id,it.qty)
   on conflict(warehouse_id,product_id) do update set stock=warehouse_stock.stock+it.qty,updated_at=now();
   update products set stock=(select coalesce(sum(stock),0) from warehouse_stock where product_id=it.product_id),updated_at=now() where id=it.product_id;
 end loop;
 if s.customer_id is not null then update customers set total_purchase=greatest(0,total_purchase-s.total),balance=case when s.payment_type='debt' then greatest(0,balance-s.total) else balance end,updated_at=now() where id=s.customer_id; end if;
 delete from payments where sale_id=p_sale_id;
 delete from returns where sale_id=p_sale_id;
 delete from stock_movements where reference_id=p_sale_id;
 delete from sale_items where sale_id=p_sale_id;
 delete from sales where id=p_sale_id;
 return jsonb_build_object('ok',true);
end $$;

-- Grants: Edge Function uses service_role, direct client cannot call these safely.
revoke all on function public.close_business_day(uuid,text) from public,anon,authenticated;
revoke all on function public.reopen_business_day(uuid,date) from public,anon,authenticated;
revoke all on function public.create_expense(uuid,text,numeric,text) from public,anon,authenticated;
revoke all on function public.admin_upsert_user(uuid,uuid,text,text,text,text,boolean) from public,anon,authenticated;
revoke all on function public.admin_delete_user(uuid,uuid) from public,anon,authenticated;
revoke all on function public.admin_delete_sale(uuid,uuid) from public,anon,authenticated;

create or replace function public.create_sale_atomic(
  p_user_id uuid,p_customer_id uuid,p_payment_type text,p_discount numeric,p_items jsonb,p_warehouse_id uuid
) returns jsonb language plpgsql security definer set search_path=public,extensions as $$
declare v_sale_id uuid;v_invoice text;v_sub numeric:=0;v_total numeric:=0;x jsonb;v_product products%rowtype;v_qty numeric;v_price numeric;v_cost numeric;v_whstock numeric;
begin
  perform public.require_open_day(p_user_id);
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
  perform public.require_open_day(p_user_id);
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
  perform public.require_open_day(p_user_id);
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


create or replace function public.create_product_auto(p_user_id uuid,p_name text,p_barcode text,p_category text,p_purchase_price numeric,p_sale_price numeric,p_min_stock numeric)
returns jsonb language plpgsql security definer set search_path=public,extensions as $$
declare n integer; c text; r products%rowtype;
begin
 if not exists(select 1 from users where id=p_user_id and role='admin' and active=true) then raise exception 'Yalnız admin məhsul yarada bilər'; end if;
 if trim(coalesce(p_name,''))='' then raise exception 'Məhsul adı tələb olunur'; end if;
 select coalesce(max((substring(code from 3))::int),0)+1 into n from products where code ~ '^S-[0-9]+$'; c:='S-'||n;
 insert into products(code,name,barcode,category,purchase_price,sale_price,min_stock) values(c,trim(p_name),nullif(trim(coalesce(p_barcode,'')),''),nullif(trim(coalesce(p_category,'')),''),coalesce(p_purchase_price,0),coalesce(p_sale_price,0),coalesce(p_min_stock,0)) returning * into r;
 return jsonb_build_object('id',r.id,'code',r.code,'name',r.name);
end $$;

create or replace function public.create_customer_auto(p_user_id uuid,p_name text,p_phone text,p_address text)
returns jsonb language plpgsql security definer set search_path=public,extensions as $$
declare n integer; c text; r customers%rowtype;
begin
 perform public.require_open_day(p_user_id);
 select coalesce(max((substring(code from 3))::int),0)+1 into n from customers where code ~ '^M-[0-9]+$'; c:='M-'||n;
 insert into customers(code,name,phone,address) values(c,trim(p_name),nullif(trim(coalesce(p_phone,'')),''),nullif(trim(coalesce(p_address,'')),'')) returning * into r;
 return jsonb_build_object('id',r.id,'code',r.code,'name',r.name);
end $$;
revoke all on function public.create_product_auto(uuid,text,text,text,numeric,numeric,numeric) from public,anon,authenticated;
revoke all on function public.create_customer_auto(uuid,text,text,text) from public,anon,authenticated;
