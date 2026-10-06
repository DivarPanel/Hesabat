-- DecorConcept POS — CƏLD SATIŞ STOK DÜZƏLİŞİ
-- Satış yalnız seçilmiş anbarın warehouse_stock stokundan çıxılır.
-- Sonra products.stock bütün anbarların cəmi kimi yenilənir.

CREATE OR REPLACE FUNCTION public.create_sale_atomic(
  p_user_id uuid,
  p_customer_id uuid,
  p_payment_type text,
  p_discount numeric,
  p_items jsonb,
  p_warehouse_id uuid
) RETURNS jsonb
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path=public,extensions
AS $$
DECLARE
  v_sale_id uuid;
  v_invoice text;
  v_sub numeric := 0;
  v_total numeric := 0;
  x jsonb;
  v_product products%rowtype;
  v_qty numeric;
  v_price numeric;
  v_cost numeric;
  v_whstock numeric;
BEGIN
  IF p_payment_type NOT IN ('cash','card','transfer','debt') THEN
    RAISE EXCEPTION 'Ödəniş növü yanlışdır';
  END IF;
  IF p_discount < 0 OR jsonb_array_length(p_items)=0 THEN
    RAISE EXCEPTION 'Satış məlumatı yanlışdır';
  END IF;
  IF NOT EXISTS (SELECT 1 FROM warehouses WHERE id=p_warehouse_id AND active=true) THEN
    RAISE EXCEPTION 'Anbar tapılmadı';
  END IF;

  -- Əvvəlcə bütün məhsulların seçilmiş anbarda kifayət etdiyini yoxla.
  FOR x IN SELECT * FROM jsonb_array_elements(p_items) LOOP
    SELECT * INTO v_product
    FROM products
    WHERE id=(x->>'product_id')::uuid AND active=true
    FOR UPDATE;

    IF NOT FOUND THEN RAISE EXCEPTION 'Məhsul tapılmadı'; END IF;

    v_qty := (x->>'qty')::numeric;
    v_price := (x->>'unit_price')::numeric;
    IF v_qty <= 0 OR v_price < 0 THEN RAISE EXCEPTION 'Miqdar/qiymət yanlışdır'; END IF;

    SELECT stock INTO v_whstock
    FROM warehouse_stock
    WHERE warehouse_id=p_warehouse_id AND product_id=v_product.id
    FOR UPDATE;

    IF COALESCE(v_whstock,0) < v_qty THEN
      RAISE EXCEPTION 'Stok kifayət deyil: % (mövcud: %, tələb: %)', v_product.name, COALESCE(v_whstock,0), v_qty;
    END IF;

    v_sub := v_sub + v_qty*v_price;
  END LOOP;

  v_total := GREATEST(0,v_sub-p_discount);
  v_invoice := 'DC-' || to_char(timezone('Asia/Baku',now()),'YYYYMMDD-HH24MISS') || '-' || upper(substr(replace(gen_random_uuid()::text,'-',''),1,5));

  INSERT INTO sales(invoice_no,customer_id,user_id,warehouse_id,subtotal,discount,total,payment_type,status)
  VALUES(v_invoice,p_customer_id,p_user_id,p_warehouse_id,v_sub,p_discount,v_total,p_payment_type,'completed')
  RETURNING id INTO v_sale_id;

  -- ƏSAS HİSSƏ: hər satılan miqdar seçilmiş anbardan çıxılır.
  FOR x IN SELECT * FROM jsonb_array_elements(p_items) LOOP
    SELECT * INTO v_product FROM products WHERE id=(x->>'product_id')::uuid FOR UPDATE;
    v_qty := (x->>'qty')::numeric;
    v_price := (x->>'unit_price')::numeric;
    v_cost := v_product.purchase_price;

    INSERT INTO sale_items(sale_id,product_id,qty,unit_price,purchase_cost)
    VALUES(v_sale_id,v_product.id,v_qty,v_price,v_cost);

    UPDATE warehouse_stock
    SET stock = stock - v_qty, updated_at=now()
    WHERE warehouse_id=p_warehouse_id AND product_id=v_product.id;

    IF NOT FOUND THEN
      RAISE EXCEPTION 'Anbar stoku tapılmadı: %', v_product.name;
    END IF;

    UPDATE products
    SET stock=(SELECT COALESCE(SUM(stock),0) FROM warehouse_stock WHERE product_id=v_product.id),
        updated_at=now()
    WHERE id=v_product.id;

    INSERT INTO stock_movements(product_id,user_id,warehouse_id,movement_type,qty,unit_cost,reference_id)
    VALUES(v_product.id,p_user_id,p_warehouse_id,'sale',v_qty,v_cost,v_sale_id);
  END LOOP;

  IF p_customer_id IS NOT NULL THEN
    UPDATE customers
    SET total_purchase=total_purchase+v_total,
        balance=CASE WHEN p_payment_type='debt' THEN balance+v_total ELSE balance END,
        updated_at=now()
    WHERE id=p_customer_id;
  END IF;

  IF p_payment_type IN ('cash','card','transfer') THEN
    INSERT INTO payments(sale_id,customer_id,amount,payment_type)
    VALUES(v_sale_id,p_customer_id,v_total,p_payment_type);
  END IF;

  RETURN jsonb_build_object('sale_id',v_sale_id,'invoice_no',v_invoice,'subtotal',v_sub,'discount',p_discount,'total',v_total);
END;
$$;

GRANT EXECUTE ON FUNCTION public.create_sale_atomic(uuid,uuid,text,numeric,jsonb,uuid) TO authenticated;
GRANT EXECUTE ON FUNCTION public.create_sale_atomic(uuid,uuid,text,numeric,jsonb,uuid) TO service_role;
