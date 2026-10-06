-- DecorConcept POS — eyni adlı məhsulların birləşdirilməsi
-- Məsələn: S-24 və S-141 eyni məhsuldursa, biri saxlanılır.
-- Stok ikiqat artırılmır. Eyni anbarda təkrar stok varsa ən böyük dəyər saxlanılır.

BEGIN;

CREATE TEMP TABLE _product_merge AS
WITH ranked AS (
  SELECT
    p.id,
    p.name,
    first_value(p.id) OVER (
      PARTITION BY lower(trim(p.name))
      ORDER BY
        CASE WHEN p.code ~ '^S-[0-9]+$' THEN (regexp_replace(p.code,'[^0-9]','','g'))::bigint ELSE 9223372036854775807 END,
        p.created_at,
        p.id
    ) AS keep_id,
    row_number() OVER (
      PARTITION BY lower(trim(p.name))
      ORDER BY
        CASE WHEN p.code ~ '^S-[0-9]+$' THEN (regexp_replace(p.code,'[^0-9]','','g'))::bigint ELSE 9223372036854775807 END,
        p.created_at,
        p.id
    ) AS rn
  FROM public.products p
  WHERE p.active = true
)
SELECT id AS duplicate_id, keep_id
FROM ranked
WHERE rn > 1;

-- Tarixçələri əsas məhsula keçiririk.
UPDATE public.sale_items si
SET product_id=m.keep_id
FROM _product_merge m
WHERE si.product_id=m.duplicate_id;

UPDATE public.stock_movements sm
SET product_id=m.keep_id
FROM _product_merge m
WHERE sm.product_id=m.duplicate_id;

UPDATE public.returns r
SET product_id=m.keep_id
FROM _product_merge m
WHERE r.product_id=m.duplicate_id;

-- Eyni anbarda təkrar qeydləri birləşdiririk.
-- Dublikat importdan yaranan 6 + 6 = 12 problemi olmasın deyə MAX saxlanılır.
CREATE TEMP TABLE _warehouse_merge AS
SELECT
  ws.warehouse_id,
  m.keep_id AS product_id,
  max(ws.stock) AS stock,
  max(ws.updated_at) AS updated_at
FROM public.warehouse_stock ws
JOIN _product_merge m ON m.duplicate_id=ws.product_id
GROUP BY ws.warehouse_id,m.keep_id;

DELETE FROM public.warehouse_stock ws
USING _product_merge m
WHERE ws.product_id=m.duplicate_id;

INSERT INTO public.warehouse_stock(warehouse_id,product_id,stock,updated_at)
SELECT warehouse_id,product_id,stock,coalesce(updated_at,now())
FROM _warehouse_merge
ON CONFLICT (warehouse_id,product_id)
DO UPDATE SET stock=GREATEST(public.warehouse_stock.stock,excluded.stock),updated_at=now();

-- Dublikat məhsullar silinir.
DELETE FROM public.products p
USING _product_merge m
WHERE p.id=m.duplicate_id;

-- Məhsulun ümumi stoku anbardakı stokların cəmindən yenidən hesablanır.
UPDATE public.products p
SET stock=coalesce((SELECT sum(ws.stock) FROM public.warehouse_stock ws WHERE ws.product_id=p.id),0),
    updated_at=now();

-- Bundan sonra eyni adlı məhsul ikinci dəfə yaradıla bilməz.
CREATE UNIQUE INDEX IF NOT EXISTS uq_products_name_normalized
ON public.products (lower(trim(name)));

COMMIT;

-- Yoxlama:
-- SELECT code,name,stock FROM public.products WHERE lower(trim(name))='bambuk a19 -sarımtıl kətan';
