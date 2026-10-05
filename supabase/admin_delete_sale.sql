-- DecorConcept POS: Qaimə silmə yalnız ADMIN
create or replace function public.admin_delete_sale(p_user_id uuid,p_sale_id uuid)
returns jsonb language plpgsql security definer set search_path=public,extensions as $$
declare v_sale sales%rowtype; v_ret numeric; v_ret_amount numeric; v_net numeric; it sale_items%rowtype; r returns%rowtype;
begin
 if not exists(select 1 from users where id=p_user_id and role='admin' and active=true) then raise exception 'Yalnız admin qaimə silə bilər'; end if;
 select * into v_sale from sales where id=p_sale_id for update;
 if not found then raise exception 'Qaimə tapılmadı'; end if;
 if exists(select 1 from returns where sale_id=p_sale_id) then
   select coalesce(sum(qty),0),coalesce(sum(amount),0) into v_ret,v_ret_amount from returns where sale_id=p_sale_id;
 else v_ret:=0; v_ret_amount:=0; end if;
 -- Qaimənin satış təsirini ləğv et: satılan stok geri qayıdır, qaytarılmış stok isə ayrıca çıxılır.
 for it in select * from sale_items where sale_id=p_sale_id loop
   insert into warehouse_stock(warehouse_id,product_id,stock) values(v_sale.warehouse_id,it.product_id,it.qty)
   on conflict(warehouse_id,product_id) do update set stock=warehouse_stock.stock+it.qty,updated_at=now();
   update products set stock=(select coalesce(sum(stock),0) from warehouse_stock where product_id=it.product_id),updated_at=now() where id=it.product_id;
 end loop;
 for r in select * from returns where sale_id=p_sale_id loop
   update warehouse_stock set stock=stock-r.qty,updated_at=now() where warehouse_id=r.warehouse_id and product_id=r.product_id;
   update products set stock=(select coalesce(sum(stock),0) from warehouse_stock where product_id=r.product_id),updated_at=now() where id=r.product_id;
 end loop;
 if v_sale.customer_id is not null then
   v_net:=greatest(0,v_sale.total-v_ret_amount);
   update customers set total_purchase=greatest(0,total_purchase-v_net),balance=case when v_sale.payment_type='debt' then greatest(0,balance-v_net) else balance end,updated_at=now() where id=v_sale.customer_id;
 end if;
 delete from payments where sale_id=p_sale_id;
 delete from stock_movements where reference_id=p_sale_id;
 delete from returns where sale_id=p_sale_id;
 delete from sale_items where sale_id=p_sale_id;
 delete from sales where id=p_sale_id;
 return jsonb_build_object('ok',true,'sale_id',p_sale_id);
end $$;
revoke all on function public.admin_delete_sale(uuid,uuid) from public,anon,authenticated;
