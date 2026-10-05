-- İlkin stok importundan sonra ANB-01 anbardakı stokları products.stock ilə sinxronlaşdırır.
-- Yalnız ANB-01-də hazırda 0 olan sətrləri doldurur; artıq hərəkət edilmiş stokları dəyişmir.
INSERT INTO public.warehouse_stock(warehouse_id,product_id,stock)
SELECT w.id,p.id,p.stock
FROM public.warehouses w
CROSS JOIN public.products p
WHERE w.code='ANB-01' AND p.active=true AND p.stock>0
ON CONFLICT (warehouse_id,product_id) DO UPDATE
SET stock=CASE WHEN public.warehouse_stock.stock=0 THEN EXCLUDED.stock ELSE public.warehouse_stock.stock END,
    updated_at=now();

UPDATE public.products p
SET stock=(SELECT coalesce(sum(ws.stock),0) FROM public.warehouse_stock ws WHERE ws.product_id=p.id),
    updated_at=now();
