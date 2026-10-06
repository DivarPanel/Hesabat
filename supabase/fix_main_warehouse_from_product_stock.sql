-- DecorConcept POS: Cəld satışda stokun düzgün görünməsi və azalması
-- Məhsullar bölməsində düzgün olan products.stock dəyərini əsas satış anbarına yazır.
-- Mövcud non-zero anbar stokuna toxunmur.
BEGIN;

DO $$
DECLARE
  w_id uuid;
BEGIN
  SELECT id INTO w_id
  FROM public.warehouses
  WHERE active=true
    AND (
      code='ANB-01'
      OR lower(trim(name)) IN ('abşeron','absheron','əsas anbar')
    )
  ORDER BY CASE WHEN code='ANB-01' THEN 0 ELSE 1 END
  LIMIT 1;

  IF w_id IS NULL THEN
    RAISE EXCEPTION 'Əsas/Abşeron anbar tapılmadı';
  END IF;

  -- Məhsul stoku düzgün olduğu halda anbarda 0/missing olan sətrləri bərpa et.
  INSERT INTO public.warehouse_stock(warehouse_id, product_id, stock, updated_at)
  SELECT w_id, p.id, GREATEST(COALESCE(p.stock,0),0), now()
  FROM public.products p
  WHERE p.active=true
  ON CONFLICT (warehouse_id, product_id) DO UPDATE
    SET stock = CASE
      WHEN COALESCE(public.warehouse_stock.stock,0)=0
           AND COALESCE(EXCLUDED.stock,0)>0
      THEN EXCLUDED.stock
      ELSE public.warehouse_stock.stock
    END,
    updated_at = now();

END $$;

COMMIT;

-- Yoxlama üçün:
SELECT w.name AS anbar, p.code, p.name, p.stock AS mehsul_stoku, ws.stock AS anbar_stoku
FROM public.warehouses w
JOIN public.warehouse_stock ws ON ws.warehouse_id=w.id
JOIN public.products p ON p.id=ws.product_id
WHERE w.active=true
  AND (w.code='ANB-01' OR lower(trim(w.name)) IN ('abşeron','absheron','əsas anbar'))
  AND p.active=true
ORDER BY p.name;
