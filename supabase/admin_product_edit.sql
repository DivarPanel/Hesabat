-- DecorConcept POS — Admin məhsul tam idarəetməsi
-- Admin məhsulun bütün məlumatlarını dəyişə bilər: ad, barkod, kateqoriya,
-- vahid, maya, satış qiyməti, minimum stok, aktivlik və seçilmiş anbardakı stok.
-- Kod (S-1...) dəyişdirilmir.

create or replace function public.admin_update_product(
  p_admin_id uuid,
  p_product_id uuid,
  p_name text,
  p_barcode text,
  p_category text,
  p_unit text,
  p_purchase_price numeric,
  p_sale_price numeric,
  p_min_stock numeric,
  p_active boolean,
  p_warehouse_id uuid,
  p_warehouse_stock numeric
)
returns jsonb language plpgsql security definer set search_path=public,extensions as $$
declare
  v_product products%rowtype;
  v_old_stock numeric:=0;
  v_delta numeric:=0;
  v_new_stock numeric;
begin
  if not exists(select 1 from users where id=p_admin_id and role='admin' and active=true) then
    raise exception 'Yalnız admin məhsul məlumatlarını dəyişə bilər';
  end if;
  if p_name is null or trim(p_name)='' then raise exception 'Məhsul adı tələb olunur'; end if;
  if coalesce(p_purchase_price,0)<0 or coalesce(p_sale_price,0)<0 or coalesce(p_min_stock,0)<0 then
    raise exception 'Qiymət və stok mənfi ola bilməz';
  end if;

  select * into v_product from products where id=p_product_id for update;
  if not found then raise exception 'Məhsul tapılmadı'; end if;

  update products set
    name=trim(p_name),
    barcode=nullif(trim(coalesce(p_barcode,'')),''),
    category=nullif(trim(coalesce(p_category,'')),''),
    unit=coalesce(nullif(trim(coalesce(p_unit,'')),''),'ədəd'),
    purchase_price=coalesce(p_purchase_price,0),
    sale_price=coalesce(p_sale_price,0),
    min_stock=coalesce(p_min_stock,0),
    active=coalesce(p_active,true),
    updated_at=now()
  where id=p_product_id;

  if p_warehouse_id is not null and p_warehouse_stock is not null then
    if p_warehouse_stock<0 then raise exception 'Stok mənfi ola bilməz'; end if;
    select coalesce(stock,0) into v_old_stock
    from warehouse_stock
    where warehouse_id=p_warehouse_id and product_id=p_product_id
    for update;

    v_new_stock:=p_warehouse_stock;
    v_delta:=v_new_stock-coalesce(v_old_stock,0);

    insert into warehouse_stock(warehouse_id,product_id,stock)
    values(p_warehouse_id,p_product_id,v_new_stock)
    on conflict(warehouse_id,product_id) do update
      set stock=excluded.stock,updated_at=now();

    if v_delta<>0 then
      insert into stock_movements(product_id,user_id,warehouse_id,movement_type,qty,unit_cost,reference_id)
      values(p_product_id,p_admin_id,p_warehouse_id,'adjustment',v_delta,coalesce(p_purchase_price,0),p_product_id);
    end if;

    update products set stock=(select coalesce(sum(stock),0) from warehouse_stock where product_id=p_product_id),updated_at=now()
    where id=p_product_id;
  end if;

  select * into v_product from products where id=p_product_id;
  return jsonb_build_object('ok',true,'product',row_to_json(v_product));
end $$;

revoke all on function public.admin_update_product(uuid,uuid,text,text,text,text,numeric,numeric,numeric,boolean,uuid,numeric) from public,anon,authenticated;
