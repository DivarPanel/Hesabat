-- DecorConcept POS: İlkin stokların Əsas anbara bərpası
-- Yalnız məhsulun bütün anbar stokları 0 olduqda Əsas anbarda ilkin stok qurulur.
-- Beləliklə real, artıq hərəkət edilmiş anbar stoku dəyişdirilmir.
BEGIN;

DO $$
DECLARE
  w_id uuid;
BEGIN
  SELECT id INTO w_id FROM public.warehouses WHERE code='ANB-01' LIMIT 1;
  IF w_id IS NULL THEN RAISE EXCEPTION 'ANB-01 Əsas anbar tapılmadı'; END IF;

  -- Decorconcept 350 kq
  IF NOT EXISTS (SELECT 1 FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Decorconcept 350 kq')) LIMIT 1) AND ws.warehouse_id=w_id) THEN
    INSERT INTO public.warehouse_stock(warehouse_id,product_id,stock,updated_at) SELECT w_id,p.id,201,now() FROM public.products p WHERE lower(trim(p.name))=lower(trim('Decorconcept 350 kq')) LIMIT 1;
  ELSIF (SELECT COALESCE(SUM(ws.stock),0) FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Decorconcept 350 kq')) LIMIT 1))=0 THEN
    UPDATE public.warehouse_stock ws SET stock=201,updated_at=now() WHERE ws.warehouse_id=w_id AND ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Decorconcept 350 kq')) LIMIT 1);
  END IF;

  -- Doldurucu
  IF NOT EXISTS (SELECT 1 FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Doldurucu')) LIMIT 1) AND ws.warehouse_id=w_id) THEN
    INSERT INTO public.warehouse_stock(warehouse_id,product_id,stock,updated_at) SELECT w_id,p.id,9,now() FROM public.products p WHERE lower(trim(p.name))=lower(trim('Doldurucu')) LIMIT 1;
  ELSIF (SELECT COALESCE(SUM(ws.stock),0) FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Doldurucu')) LIMIT 1))=0 THEN
    UPDATE public.warehouse_stock ws SET stock=9,updated_at=now() WHERE ws.warehouse_id=w_id AND ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Doldurucu')) LIMIT 1);
  END IF;

  -- Bambuk birləşmə kantı qara
  IF NOT EXISTS (SELECT 1 FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Bambuk birləşmə kantı qara')) LIMIT 1) AND ws.warehouse_id=w_id) THEN
    INSERT INTO public.warehouse_stock(warehouse_id,product_id,stock,updated_at) SELECT w_id,p.id,33,now() FROM public.products p WHERE lower(trim(p.name))=lower(trim('Bambuk birləşmə kantı qara')) LIMIT 1;
  ELSIF (SELECT COALESCE(SUM(ws.stock),0) FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Bambuk birləşmə kantı qara')) LIMIT 1))=0 THEN
    UPDATE public.warehouse_stock ws SET stock=33,updated_at=now() WHERE ws.warehouse_id=w_id AND ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Bambuk birləşmə kantı qara')) LIMIT 1);
  END IF;

  -- Bambuk birləşmə kantı ag
  IF NOT EXISTS (SELECT 1 FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Bambuk birləşmə kantı ag')) LIMIT 1) AND ws.warehouse_id=w_id) THEN
    INSERT INTO public.warehouse_stock(warehouse_id,product_id,stock,updated_at) SELECT w_id,p.id,42,now() FROM public.products p WHERE lower(trim(p.name))=lower(trim('Bambuk birləşmə kantı ag')) LIMIT 1;
  ELSIF (SELECT COALESCE(SUM(ws.stock),0) FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Bambuk birləşmə kantı ag')) LIMIT 1))=0 THEN
    UPDATE public.warehouse_stock ws SET stock=42,updated_at=now() WHERE ws.warehouse_id=w_id AND ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Bambuk birləşmə kantı ag')) LIMIT 1);
  END IF;

  -- Bambuk birləşmə kantı boz
  IF NOT EXISTS (SELECT 1 FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Bambuk birləşmə kantı boz')) LIMIT 1) AND ws.warehouse_id=w_id) THEN
    INSERT INTO public.warehouse_stock(warehouse_id,product_id,stock,updated_at) SELECT w_id,p.id,48,now() FROM public.products p WHERE lower(trim(p.name))=lower(trim('Bambuk birləşmə kantı boz')) LIMIT 1;
  ELSIF (SELECT COALESCE(SUM(ws.stock),0) FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Bambuk birləşmə kantı boz')) LIMIT 1))=0 THEN
    UPDATE public.warehouse_stock ws SET stock=48,updated_at=now() WHERE ws.warehouse_id=w_id AND ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Bambuk birləşmə kantı boz')) LIMIT 1);
  END IF;

  -- Bambuk Col kunc
  IF NOT EXISTS (SELECT 1 FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Bambuk Col kunc')) LIMIT 1) AND ws.warehouse_id=w_id) THEN
    INSERT INTO public.warehouse_stock(warehouse_id,product_id,stock,updated_at) SELECT w_id,p.id,12,now() FROM public.products p WHERE lower(trim(p.name))=lower(trim('Bambuk Col kunc')) LIMIT 1;
  ELSIF (SELECT COALESCE(SUM(ws.stock),0) FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Bambuk Col kunc')) LIMIT 1))=0 THEN
    UPDATE public.warehouse_stock ws SET stock=12,updated_at=now() WHERE ws.warehouse_id=w_id AND ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Bambuk Col kunc')) LIMIT 1);
  END IF;

  -- Bambuk birləşmə kantı işıqlı
  IF NOT EXISTS (SELECT 1 FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Bambuk birləşmə kantı işıqlı')) LIMIT 1) AND ws.warehouse_id=w_id) THEN
    INSERT INTO public.warehouse_stock(warehouse_id,product_id,stock,updated_at) SELECT w_id,p.id,7,now() FROM public.products p WHERE lower(trim(p.name))=lower(trim('Bambuk birləşmə kantı işıqlı')) LIMIT 1;
  ELSIF (SELECT COALESCE(SUM(ws.stock),0) FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Bambuk birləşmə kantı işıqlı')) LIMIT 1))=0 THEN
    UPDATE public.warehouse_stock ws SET stock=7,updated_at=now() WHERE ws.warehouse_id=w_id AND ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Bambuk birləşmə kantı işıqlı')) LIMIT 1);
  END IF;

  -- Mərmər birləşmə kantı 3m
  IF NOT EXISTS (SELECT 1 FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Mərmər birləşmə kantı 3m')) LIMIT 1) AND ws.warehouse_id=w_id) THEN
    INSERT INTO public.warehouse_stock(warehouse_id,product_id,stock,updated_at) SELECT w_id,p.id,14,now() FROM public.products p WHERE lower(trim(p.name))=lower(trim('Mərmər birləşmə kantı 3m')) LIMIT 1;
  ELSIF (SELECT COALESCE(SUM(ws.stock),0) FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Mərmər birləşmə kantı 3m')) LIMIT 1))=0 THEN
    UPDATE public.warehouse_stock ws SET stock=14,updated_at=now() WHERE ws.warehouse_id=w_id AND ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Mərmər birləşmə kantı 3m')) LIMIT 1);
  END IF;

  -- Plastik Oboy ketan künc3m
  IF NOT EXISTS (SELECT 1 FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Plastik Oboy ketan künc3m')) LIMIT 1) AND ws.warehouse_id=w_id) THEN
    INSERT INTO public.warehouse_stock(warehouse_id,product_id,stock,updated_at) SELECT w_id,p.id,141,now() FROM public.products p WHERE lower(trim(p.name))=lower(trim('Plastik Oboy ketan künc3m')) LIMIT 1;
  ELSIF (SELECT COALESCE(SUM(ws.stock),0) FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Plastik Oboy ketan künc3m')) LIMIT 1))=0 THEN
    UPDATE public.warehouse_stock ws SET stock=141,updated_at=now() WHERE ws.warehouse_id=w_id AND ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Plastik Oboy ketan künc3m')) LIMIT 1);
  END IF;

  -- Sonluq Kant qara
  IF NOT EXISTS (SELECT 1 FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Sonluq Kant qara')) LIMIT 1) AND ws.warehouse_id=w_id) THEN
    INSERT INTO public.warehouse_stock(warehouse_id,product_id,stock,updated_at) SELECT w_id,p.id,152,now() FROM public.products p WHERE lower(trim(p.name))=lower(trim('Sonluq Kant qara')) LIMIT 1;
  ELSIF (SELECT COALESCE(SUM(ws.stock),0) FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Sonluq Kant qara')) LIMIT 1))=0 THEN
    UPDATE public.warehouse_stock ws SET stock=152,updated_at=now() WHERE ws.warehouse_id=w_id AND ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Sonluq Kant qara')) LIMIT 1);
  END IF;

  -- Sonluq Kant Ag
  IF NOT EXISTS (SELECT 1 FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Sonluq Kant Ag')) LIMIT 1) AND ws.warehouse_id=w_id) THEN
    INSERT INTO public.warehouse_stock(warehouse_id,product_id,stock,updated_at) SELECT w_id,p.id,44,now() FROM public.products p WHERE lower(trim(p.name))=lower(trim('Sonluq Kant Ag')) LIMIT 1;
  ELSIF (SELECT COALESCE(SUM(ws.stock),0) FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Sonluq Kant Ag')) LIMIT 1))=0 THEN
    UPDATE public.warehouse_stock ws SET stock=44,updated_at=now() WHERE ws.warehouse_id=w_id AND ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Sonluq Kant Ag')) LIMIT 1);
  END IF;

  -- Sonluq Kant gumus
  IF NOT EXISTS (SELECT 1 FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Sonluq Kant gumus')) LIMIT 1) AND ws.warehouse_id=w_id) THEN
    INSERT INTO public.warehouse_stock(warehouse_id,product_id,stock,updated_at) SELECT w_id,p.id,49,now() FROM public.products p WHERE lower(trim(p.name))=lower(trim('Sonluq Kant gumus')) LIMIT 1;
  ELSIF (SELECT COALESCE(SUM(ws.stock),0) FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Sonluq Kant gumus')) LIMIT 1))=0 THEN
    UPDATE public.warehouse_stock ws SET stock=49,updated_at=now() WHERE ws.warehouse_id=w_id AND ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Sonluq Kant gumus')) LIMIT 1);
  END IF;

  -- Kose 1*3 Qara
  IF NOT EXISTS (SELECT 1 FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Kose 1*3 Qara')) LIMIT 1) AND ws.warehouse_id=w_id) THEN
    INSERT INTO public.warehouse_stock(warehouse_id,product_id,stock,updated_at) SELECT w_id,p.id,56,now() FROM public.products p WHERE lower(trim(p.name))=lower(trim('Kose 1*3 Qara')) LIMIT 1;
  ELSIF (SELECT COALESCE(SUM(ws.stock),0) FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Kose 1*3 Qara')) LIMIT 1))=0 THEN
    UPDATE public.warehouse_stock ws SET stock=56,updated_at=now() WHERE ws.warehouse_id=w_id AND ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Kose 1*3 Qara')) LIMIT 1);
  END IF;

  -- Aks - Ac 100 sm
  IF NOT EXISTS (SELECT 1 FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Aks - Ac 100 sm')) LIMIT 1) AND ws.warehouse_id=w_id) THEN
    INSERT INTO public.warehouse_stock(warehouse_id,product_id,stock,updated_at) SELECT w_id,p.id,12,now() FROM public.products p WHERE lower(trim(p.name))=lower(trim('Aks - Ac 100 sm')) LIMIT 1;
  ELSIF (SELECT COALESCE(SUM(ws.stock),0) FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Aks - Ac 100 sm')) LIMIT 1))=0 THEN
    UPDATE public.warehouse_stock ws SET stock=12,updated_at=now() WHERE ws.warehouse_id=w_id AND ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Aks - Ac 100 sm')) LIMIT 1);
  END IF;

  -- Aks - Ağ 100 sm
  IF NOT EXISTS (SELECT 1 FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Aks - Ağ 100 sm')) LIMIT 1) AND ws.warehouse_id=w_id) THEN
    INSERT INTO public.warehouse_stock(warehouse_id,product_id,stock,updated_at) SELECT w_id,p.id,23,now() FROM public.products p WHERE lower(trim(p.name))=lower(trim('Aks - Ağ 100 sm')) LIMIT 1;
  ELSIF (SELECT COALESCE(SUM(ws.stock),0) FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Aks - Ağ 100 sm')) LIMIT 1))=0 THEN
    UPDATE public.warehouse_stock ws SET stock=23,updated_at=now() WHERE ws.warehouse_id=w_id AND ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Aks - Ağ 100 sm')) LIMIT 1);
  END IF;

  -- Aks - Ağ 3 100 sm
  IF NOT EXISTS (SELECT 1 FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Aks - Ağ 3 100 sm')) LIMIT 1) AND ws.warehouse_id=w_id) THEN
    INSERT INTO public.warehouse_stock(warehouse_id,product_id,stock,updated_at) SELECT w_id,p.id,9,now() FROM public.products p WHERE lower(trim(p.name))=lower(trim('Aks - Ağ 3 100 sm')) LIMIT 1;
  ELSIF (SELECT COALESCE(SUM(ws.stock),0) FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Aks - Ağ 3 100 sm')) LIMIT 1))=0 THEN
    UPDATE public.warehouse_stock ws SET stock=9,updated_at=now() WHERE ws.warehouse_id=w_id AND ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Aks - Ağ 3 100 sm')) LIMIT 1);
  END IF;

  -- Aks - Antrasit 100 sm
  IF NOT EXISTS (SELECT 1 FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Aks - Antrasit 100 sm')) LIMIT 1) AND ws.warehouse_id=w_id) THEN
    INSERT INTO public.warehouse_stock(warehouse_id,product_id,stock,updated_at) SELECT w_id,p.id,26,now() FROM public.products p WHERE lower(trim(p.name))=lower(trim('Aks - Antrasit 100 sm')) LIMIT 1;
  ELSIF (SELECT COALESCE(SUM(ws.stock),0) FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Aks - Antrasit 100 sm')) LIMIT 1))=0 THEN
    UPDATE public.warehouse_stock ws SET stock=26,updated_at=now() WHERE ws.warehouse_id=w_id AND ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Aks - Antrasit 100 sm')) LIMIT 1);
  END IF;

  -- Aks - Krem 100 sm
  IF NOT EXISTS (SELECT 1 FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Aks - Krem 100 sm')) LIMIT 1) AND ws.warehouse_id=w_id) THEN
    INSERT INTO public.warehouse_stock(warehouse_id,product_id,stock,updated_at) SELECT w_id,p.id,9,now() FROM public.products p WHERE lower(trim(p.name))=lower(trim('Aks - Krem 100 sm')) LIMIT 1;
  ELSIF (SELECT COALESCE(SUM(ws.stock),0) FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Aks - Krem 100 sm')) LIMIT 1))=0 THEN
    UPDATE public.warehouse_stock ws SET stock=9,updated_at=now() WHERE ws.warehouse_id=w_id AND ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Aks - Krem 100 sm')) LIMIT 1);
  END IF;

  -- Aks - Krem 100 sm T
  IF NOT EXISTS (SELECT 1 FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Aks - Krem 100 sm T')) LIMIT 1) AND ws.warehouse_id=w_id) THEN
    INSERT INTO public.warehouse_stock(warehouse_id,product_id,stock,updated_at) SELECT w_id,p.id,15,now() FROM public.products p WHERE lower(trim(p.name))=lower(trim('Aks - Krem 100 sm T')) LIMIT 1;
  ELSIF (SELECT COALESCE(SUM(ws.stock),0) FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Aks - Krem 100 sm T')) LIMIT 1))=0 THEN
    UPDATE public.warehouse_stock ws SET stock=15,updated_at=now() WHERE ws.warehouse_id=w_id AND ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Aks - Krem 100 sm T')) LIMIT 1);
  END IF;

  -- Aks - Qara 100 sm
  IF NOT EXISTS (SELECT 1 FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Aks - Qara 100 sm')) LIMIT 1) AND ws.warehouse_id=w_id) THEN
    INSERT INTO public.warehouse_stock(warehouse_id,product_id,stock,updated_at) SELECT w_id,p.id,8,now() FROM public.products p WHERE lower(trim(p.name))=lower(trim('Aks - Qara 100 sm')) LIMIT 1;
  ELSIF (SELECT COALESCE(SUM(ws.stock),0) FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Aks - Qara 100 sm')) LIMIT 1))=0 THEN
    UPDATE public.warehouse_stock ws SET stock=8,updated_at=now() WHERE ws.warehouse_id=w_id AND ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Aks - Qara 100 sm')) LIMIT 1);
  END IF;

  -- Aks - Sonoma 2 100 sm
  IF NOT EXISTS (SELECT 1 FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Aks - Sonoma 2 100 sm')) LIMIT 1) AND ws.warehouse_id=w_id) THEN
    INSERT INTO public.warehouse_stock(warehouse_id,product_id,stock,updated_at) SELECT w_id,p.id,2,now() FROM public.products p WHERE lower(trim(p.name))=lower(trim('Aks - Sonoma 2 100 sm')) LIMIT 1;
  ELSIF (SELECT COALESCE(SUM(ws.stock),0) FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Aks - Sonoma 2 100 sm')) LIMIT 1))=0 THEN
    UPDATE public.warehouse_stock ws SET stock=2,updated_at=now() WHERE ws.warehouse_id=w_id AND ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Aks - Sonoma 2 100 sm')) LIMIT 1);
  END IF;

  -- Aks - Sonoma 3 50 sm
  IF NOT EXISTS (SELECT 1 FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Aks - Sonoma 3 50 sm')) LIMIT 1) AND ws.warehouse_id=w_id) THEN
    INSERT INTO public.warehouse_stock(warehouse_id,product_id,stock,updated_at) SELECT w_id,p.id,10,now() FROM public.products p WHERE lower(trim(p.name))=lower(trim('Aks - Sonoma 3 50 sm')) LIMIT 1;
  ELSIF (SELECT COALESCE(SUM(ws.stock),0) FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Aks - Sonoma 3 50 sm')) LIMIT 1))=0 THEN
    UPDATE public.warehouse_stock ws SET stock=10,updated_at=now() WHERE ws.warehouse_id=w_id AND ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Aks - Sonoma 3 50 sm')) LIMIT 1);
  END IF;

  -- Aks - Sonoma mese 100 sm
  IF NOT EXISTS (SELECT 1 FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Aks - Sonoma mese 100 sm')) LIMIT 1) AND ws.warehouse_id=w_id) THEN
    INSERT INTO public.warehouse_stock(warehouse_id,product_id,stock,updated_at) SELECT w_id,p.id,13,now() FROM public.products p WHERE lower(trim(p.name))=lower(trim('Aks - Sonoma mese 100 sm')) LIMIT 1;
  ELSIF (SELECT COALESCE(SUM(ws.stock),0) FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Aks - Sonoma mese 100 sm')) LIMIT 1))=0 THEN
    UPDATE public.warehouse_stock ws SET stock=13,updated_at=now() WHERE ws.warehouse_id=w_id AND ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Aks - Sonoma mese 100 sm')) LIMIT 1);
  END IF;

  -- Aks-Teak2 100sm
  IF NOT EXISTS (SELECT 1 FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Aks-Teak2 100sm')) LIMIT 1) AND ws.warehouse_id=w_id) THEN
    INSERT INTO public.warehouse_stock(warehouse_id,product_id,stock,updated_at) SELECT w_id,p.id,22,now() FROM public.products p WHERE lower(trim(p.name))=lower(trim('Aks-Teak2 100sm')) LIMIT 1;
  ELSIF (SELECT COALESCE(SUM(ws.stock),0) FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Aks-Teak2 100sm')) LIMIT 1))=0 THEN
    UPDATE public.warehouse_stock ws SET stock=22,updated_at=now() WHERE ws.warehouse_id=w_id AND ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Aks-Teak2 100sm')) LIMIT 1);
  END IF;

  -- Aks - Sonoma 1 50 sm
  IF NOT EXISTS (SELECT 1 FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Aks - Sonoma 1 50 sm')) LIMIT 1) AND ws.warehouse_id=w_id) THEN
    INSERT INTO public.warehouse_stock(warehouse_id,product_id,stock,updated_at) SELECT w_id,p.id,1,now() FROM public.products p WHERE lower(trim(p.name))=lower(trim('Aks - Sonoma 1 50 sm')) LIMIT 1;
  ELSIF (SELECT COALESCE(SUM(ws.stock),0) FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Aks - Sonoma 1 50 sm')) LIMIT 1))=0 THEN
    UPDATE public.warehouse_stock ws SET stock=1,updated_at=now() WHERE ws.warehouse_id=w_id AND ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Aks - Sonoma 1 50 sm')) LIMIT 1);
  END IF;

  -- Aks -Teak1 100 sm
  IF NOT EXISTS (SELECT 1 FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Aks -Teak1 100 sm')) LIMIT 1) AND ws.warehouse_id=w_id) THEN
    INSERT INTO public.warehouse_stock(warehouse_id,product_id,stock,updated_at) SELECT w_id,p.id,2,now() FROM public.products p WHERE lower(trim(p.name))=lower(trim('Aks -Teak1 100 sm')) LIMIT 1;
  ELSIF (SELECT COALESCE(SUM(ws.stock),0) FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Aks -Teak1 100 sm')) LIMIT 1))=0 THEN
    UPDATE public.warehouse_stock ws SET stock=2,updated_at=now() WHERE ws.warehouse_id=w_id AND ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Aks -Teak1 100 sm')) LIMIT 1);
  END IF;

  -- Aks - Sonoma 50 sm
  IF NOT EXISTS (SELECT 1 FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Aks - Sonoma 50 sm')) LIMIT 1) AND ws.warehouse_id=w_id) THEN
    INSERT INTO public.warehouse_stock(warehouse_id,product_id,stock,updated_at) SELECT w_id,p.id,1,now() FROM public.products p WHERE lower(trim(p.name))=lower(trim('Aks - Sonoma 50 sm')) LIMIT 1;
  ELSIF (SELECT COALESCE(SUM(ws.stock),0) FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Aks - Sonoma 50 sm')) LIMIT 1))=0 THEN
    UPDATE public.warehouse_stock ws SET stock=1,updated_at=now() WHERE ws.warehouse_id=w_id AND ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Aks - Sonoma 50 sm')) LIMIT 1);
  END IF;

  -- Aks - Sonoma3 100 sm
  IF NOT EXISTS (SELECT 1 FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Aks - Sonoma3 100 sm')) LIMIT 1) AND ws.warehouse_id=w_id) THEN
    INSERT INTO public.warehouse_stock(warehouse_id,product_id,stock,updated_at) SELECT w_id,p.id,18,now() FROM public.products p WHERE lower(trim(p.name))=lower(trim('Aks - Sonoma3 100 sm')) LIMIT 1;
  ELSIF (SELECT COALESCE(SUM(ws.stock),0) FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Aks - Sonoma3 100 sm')) LIMIT 1))=0 THEN
    UPDATE public.warehouse_stock ws SET stock=18,updated_at=now() WHERE ws.warehouse_id=w_id AND ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Aks - Sonoma3 100 sm')) LIMIT 1);
  END IF;

  -- Aks -Teak4 100 sm
  IF NOT EXISTS (SELECT 1 FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Aks -Teak4 100 sm')) LIMIT 1) AND ws.warehouse_id=w_id) THEN
    INSERT INTO public.warehouse_stock(warehouse_id,product_id,stock,updated_at) SELECT w_id,p.id,13,now() FROM public.products p WHERE lower(trim(p.name))=lower(trim('Aks -Teak4 100 sm')) LIMIT 1;
  ELSIF (SELECT COALESCE(SUM(ws.stock),0) FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Aks -Teak4 100 sm')) LIMIT 1))=0 THEN
    UPDATE public.warehouse_stock ws SET stock=13,updated_at=now() WHERE ws.warehouse_id=w_id AND ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Aks -Teak4 100 sm')) LIMIT 1);
  END IF;

  -- Aks penel 60x60 sm
  IF NOT EXISTS (SELECT 1 FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Aks penel 60x60 sm')) LIMIT 1) AND ws.warehouse_id=w_id) THEN
    INSERT INTO public.warehouse_stock(warehouse_id,product_id,stock,updated_at) SELECT w_id,p.id,88,now() FROM public.products p WHERE lower(trim(p.name))=lower(trim('Aks penel 60x60 sm')) LIMIT 1;
  ELSIF (SELECT COALESCE(SUM(ws.stock),0) FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Aks penel 60x60 sm')) LIMIT 1))=0 THEN
    UPDATE public.warehouse_stock ws SET stock=88,updated_at=now() WHERE ws.warehouse_id=w_id AND ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Aks penel 60x60 sm')) LIMIT 1);
  END IF;

  -- Aks-Teak2 50 sm
  IF NOT EXISTS (SELECT 1 FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Aks-Teak2 50 sm')) LIMIT 1) AND ws.warehouse_id=w_id) THEN
    INSERT INTO public.warehouse_stock(warehouse_id,product_id,stock,updated_at) SELECT w_id,p.id,4,now() FROM public.products p WHERE lower(trim(p.name))=lower(trim('Aks-Teak2 50 sm')) LIMIT 1;
  ELSIF (SELECT COALESCE(SUM(ws.stock),0) FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Aks-Teak2 50 sm')) LIMIT 1))=0 THEN
    UPDATE public.warehouse_stock ws SET stock=4,updated_at=now() WHERE ws.warehouse_id=w_id AND ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Aks-Teak2 50 sm')) LIMIT 1);
  END IF;

  -- Aks-Teak4 50 sm
  IF NOT EXISTS (SELECT 1 FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Aks-Teak4 50 sm')) LIMIT 1) AND ws.warehouse_id=w_id) THEN
    INSERT INTO public.warehouse_stock(warehouse_id,product_id,stock,updated_at) SELECT w_id,p.id,9,now() FROM public.products p WHERE lower(trim(p.name))=lower(trim('Aks-Teak4 50 sm')) LIMIT 1;
  ELSIF (SELECT COALESCE(SUM(ws.stock),0) FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Aks-Teak4 50 sm')) LIMIT 1))=0 THEN
    UPDATE public.warehouse_stock ws SET stock=9,updated_at=now() WHERE ws.warehouse_id=w_id AND ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Aks-Teak4 50 sm')) LIMIT 1);
  END IF;

  -- Kabancik 51x60 sm
  IF NOT EXISTS (SELECT 1 FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Kabancik 51x60 sm')) LIMIT 1) AND ws.warehouse_id=w_id) THEN
    INSERT INTO public.warehouse_stock(warehouse_id,product_id,stock,updated_at) SELECT w_id,p.id,5,now() FROM public.products p WHERE lower(trim(p.name))=lower(trim('Kabancik 51x60 sm')) LIMIT 1;
  ELSIF (SELECT COALESCE(SUM(ws.stock),0) FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Kabancik 51x60 sm')) LIMIT 1))=0 THEN
    UPDATE public.warehouse_stock ws SET stock=5,updated_at=now() WHERE ws.warehouse_id=w_id AND ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Kabancik 51x60 sm')) LIMIT 1);
  END IF;

  -- Romb 126x60 sm
  IF NOT EXISTS (SELECT 1 FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Romb 126x60 sm')) LIMIT 1) AND ws.warehouse_id=w_id) THEN
    INSERT INTO public.warehouse_stock(warehouse_id,product_id,stock,updated_at) SELECT w_id,p.id,8,now() FROM public.products p WHERE lower(trim(p.name))=lower(trim('Romb 126x60 sm')) LIMIT 1;
  ELSIF (SELECT COALESCE(SUM(ws.stock),0) FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Romb 126x60 sm')) LIMIT 1))=0 THEN
    UPDATE public.warehouse_stock ws SET stock=8,updated_at=now() WHERE ws.warehouse_id=w_id AND ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Romb 126x60 sm')) LIMIT 1);
  END IF;

  -- Aks - Ağ 3 50 sm
  IF NOT EXISTS (SELECT 1 FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Aks - Ağ 3 50 sm')) LIMIT 1) AND ws.warehouse_id=w_id) THEN
    INSERT INTO public.warehouse_stock(warehouse_id,product_id,stock,updated_at) SELECT w_id,p.id,9,now() FROM public.products p WHERE lower(trim(p.name))=lower(trim('Aks - Ağ 3 50 sm')) LIMIT 1;
  ELSIF (SELECT COALESCE(SUM(ws.stock),0) FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Aks - Ağ 3 50 sm')) LIMIT 1))=0 THEN
    UPDATE public.warehouse_stock ws SET stock=9,updated_at=now() WHERE ws.warehouse_id=w_id AND ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Aks - Ağ 3 50 sm')) LIMIT 1);
  END IF;

  -- Aks -Teak1 50sm
  IF NOT EXISTS (SELECT 1 FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Aks -Teak1 50sm')) LIMIT 1) AND ws.warehouse_id=w_id) THEN
    INSERT INTO public.warehouse_stock(warehouse_id,product_id,stock,updated_at) SELECT w_id,p.id,8,now() FROM public.products p WHERE lower(trim(p.name))=lower(trim('Aks -Teak1 50sm')) LIMIT 1;
  ELSIF (SELECT COALESCE(SUM(ws.stock),0) FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Aks -Teak1 50sm')) LIMIT 1))=0 THEN
    UPDATE public.warehouse_stock ws SET stock=8,updated_at=now() WHERE ws.warehouse_id=w_id AND ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Aks -Teak1 50sm')) LIMIT 1);
  END IF;

  -- Bambuk daraq - 8310
  IF NOT EXISTS (SELECT 1 FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Bambuk daraq - 8310')) LIMIT 1) AND ws.warehouse_id=w_id) THEN
    INSERT INTO public.warehouse_stock(warehouse_id,product_id,stock,updated_at) SELECT w_id,p.id,19,now() FROM public.products p WHERE lower(trim(p.name))=lower(trim('Bambuk daraq - 8310')) LIMIT 1;
  ELSIF (SELECT COALESCE(SUM(ws.stock),0) FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Bambuk daraq - 8310')) LIMIT 1))=0 THEN
    UPDATE public.warehouse_stock ws SET stock=19,updated_at=now() WHERE ws.warehouse_id=w_id AND ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Bambuk daraq - 8310')) LIMIT 1);
  END IF;

  -- Bambuk daraq -002
  IF NOT EXISTS (SELECT 1 FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Bambuk daraq -002')) LIMIT 1) AND ws.warehouse_id=w_id) THEN
    INSERT INTO public.warehouse_stock(warehouse_id,product_id,stock,updated_at) SELECT w_id,p.id,14,now() FROM public.products p WHERE lower(trim(p.name))=lower(trim('Bambuk daraq -002')) LIMIT 1;
  ELSIF (SELECT COALESCE(SUM(ws.stock),0) FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Bambuk daraq -002')) LIMIT 1))=0 THEN
    UPDATE public.warehouse_stock ws SET stock=14,updated_at=now() WHERE ws.warehouse_id=w_id AND ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Bambuk daraq -002')) LIMIT 1);
  END IF;

  -- Bambuk daraq -Ağ saya
  IF NOT EXISTS (SELECT 1 FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Bambuk daraq -Ağ saya')) LIMIT 1) AND ws.warehouse_id=w_id) THEN
    INSERT INTO public.warehouse_stock(warehouse_id,product_id,stock,updated_at) SELECT w_id,p.id,12,now() FROM public.products p WHERE lower(trim(p.name))=lower(trim('Bambuk daraq -Ağ saya')) LIMIT 1;
  ELSIF (SELECT COALESCE(SUM(ws.stock),0) FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Bambuk daraq -Ağ saya')) LIMIT 1))=0 THEN
    UPDATE public.warehouse_stock ws SET stock=12,updated_at=now() WHERE ws.warehouse_id=w_id AND ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Bambuk daraq -Ağ saya')) LIMIT 1);
  END IF;

  -- Bambuk daraq -D10
  IF NOT EXISTS (SELECT 1 FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Bambuk daraq -D10')) LIMIT 1) AND ws.warehouse_id=w_id) THEN
    INSERT INTO public.warehouse_stock(warehouse_id,product_id,stock,updated_at) SELECT w_id,p.id,6,now() FROM public.products p WHERE lower(trim(p.name))=lower(trim('Bambuk daraq -D10')) LIMIT 1;
  ELSIF (SELECT COALESCE(SUM(ws.stock),0) FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Bambuk daraq -D10')) LIMIT 1))=0 THEN
    UPDATE public.warehouse_stock ws SET stock=6,updated_at=now() WHERE ws.warehouse_id=w_id AND ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Bambuk daraq -D10')) LIMIT 1);
  END IF;

  -- Bambuk daraq -Düz xətt açıq
  IF NOT EXISTS (SELECT 1 FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Bambuk daraq -Düz xətt açıq')) LIMIT 1) AND ws.warehouse_id=w_id) THEN
    INSERT INTO public.warehouse_stock(warehouse_id,product_id,stock,updated_at) SELECT w_id,p.id,1,now() FROM public.products p WHERE lower(trim(p.name))=lower(trim('Bambuk daraq -Düz xətt açıq')) LIMIT 1;
  ELSIF (SELECT COALESCE(SUM(ws.stock),0) FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Bambuk daraq -Düz xətt açıq')) LIMIT 1))=0 THEN
    UPDATE public.warehouse_stock ws SET stock=1,updated_at=now() WHERE ws.warehouse_id=w_id AND ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Bambuk daraq -Düz xətt açıq')) LIMIT 1);
  END IF;

  -- Bambuk daraq -Krem saya
  IF NOT EXISTS (SELECT 1 FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Bambuk daraq -Krem saya')) LIMIT 1) AND ws.warehouse_id=w_id) THEN
    INSERT INTO public.warehouse_stock(warehouse_id,product_id,stock,updated_at) SELECT w_id,p.id,13,now() FROM public.products p WHERE lower(trim(p.name))=lower(trim('Bambuk daraq -Krem saya')) LIMIT 1;
  ELSIF (SELECT COALESCE(SUM(ws.stock),0) FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Bambuk daraq -Krem saya')) LIMIT 1))=0 THEN
    UPDATE public.warehouse_stock ws SET stock=13,updated_at=now() WHERE ws.warehouse_id=w_id AND ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Bambuk daraq -Krem saya')) LIMIT 1);
  END IF;

  -- Bambuk daraq -Venesiyanka qızılı
  IF NOT EXISTS (SELECT 1 FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Bambuk daraq -Venesiyanka qızılı')) LIMIT 1) AND ws.warehouse_id=w_id) THEN
    INSERT INTO public.warehouse_stock(warehouse_id,product_id,stock,updated_at) SELECT w_id,p.id,16,now() FROM public.products p WHERE lower(trim(p.name))=lower(trim('Bambuk daraq -Venesiyanka qızılı')) LIMIT 1;
  ELSIF (SELECT COALESCE(SUM(ws.stock),0) FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Bambuk daraq -Venesiyanka qızılı')) LIMIT 1))=0 THEN
    UPDATE public.warehouse_stock ws SET stock=16,updated_at=now() WHERE ws.warehouse_id=w_id AND ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Bambuk daraq -Venesiyanka qızılı')) LIMIT 1);
  END IF;

  -- Bambuk daraq 20 sm
  IF NOT EXISTS (SELECT 1 FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Bambuk daraq 20 sm')) LIMIT 1) AND ws.warehouse_id=w_id) THEN
    INSERT INTO public.warehouse_stock(warehouse_id,product_id,stock,updated_at) SELECT w_id,p.id,16,now() FROM public.products p WHERE lower(trim(p.name))=lower(trim('Bambuk daraq 20 sm')) LIMIT 1;
  ELSIF (SELECT COALESCE(SUM(ws.stock),0) FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Bambuk daraq 20 sm')) LIMIT 1))=0 THEN
    UPDATE public.warehouse_stock ws SET stock=16,updated_at=now() WHERE ws.warehouse_id=w_id AND ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Bambuk daraq 20 sm')) LIMIT 1);
  END IF;

  -- Bambuk daraq-Venesiyanka gümüşü
  IF NOT EXISTS (SELECT 1 FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Bambuk daraq-Venesiyanka gümüşü')) LIMIT 1) AND ws.warehouse_id=w_id) THEN
    INSERT INTO public.warehouse_stock(warehouse_id,product_id,stock,updated_at) SELECT w_id,p.id,16,now() FROM public.products p WHERE lower(trim(p.name))=lower(trim('Bambuk daraq-Venesiyanka gümüşü')) LIMIT 1;
  ELSIF (SELECT COALESCE(SUM(ws.stock),0) FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Bambuk daraq-Venesiyanka gümüşü')) LIMIT 1))=0 THEN
    UPDATE public.warehouse_stock ws SET stock=16,updated_at=now() WHERE ws.warehouse_id=w_id AND ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Bambuk daraq-Venesiyanka gümüşü')) LIMIT 1);
  END IF;

  -- Bambuk A05 -Gold güzgü
  IF NOT EXISTS (SELECT 1 FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Bambuk A05 -Gold güzgü')) LIMIT 1) AND ws.warehouse_id=w_id) THEN
    INSERT INTO public.warehouse_stock(warehouse_id,product_id,stock,updated_at) SELECT w_id,p.id,4,now() FROM public.products p WHERE lower(trim(p.name))=lower(trim('Bambuk A05 -Gold güzgü')) LIMIT 1;
  ELSIF (SELECT COALESCE(SUM(ws.stock),0) FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Bambuk A05 -Gold güzgü')) LIMIT 1))=0 THEN
    UPDATE public.warehouse_stock ws SET stock=4,updated_at=now() WHERE ws.warehouse_id=w_id AND ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Bambuk A05 -Gold güzgü')) LIMIT 1);
  END IF;

  -- Bambuk -A03 boz Yolka
  IF NOT EXISTS (SELECT 1 FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Bambuk -A03 boz Yolka')) LIMIT 1) AND ws.warehouse_id=w_id) THEN
    INSERT INTO public.warehouse_stock(warehouse_id,product_id,stock,updated_at) SELECT w_id,p.id,1,now() FROM public.products p WHERE lower(trim(p.name))=lower(trim('Bambuk -A03 boz Yolka')) LIMIT 1;
  ELSIF (SELECT COALESCE(SUM(ws.stock),0) FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Bambuk -A03 boz Yolka')) LIMIT 1))=0 THEN
    UPDATE public.warehouse_stock ws SET stock=1,updated_at=now() WHERE ws.warehouse_id=w_id AND ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Bambuk -A03 boz Yolka')) LIMIT 1);
  END IF;

  -- Bambuk A10- Yemisan
  IF NOT EXISTS (SELECT 1 FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Bambuk A10- Yemisan')) LIMIT 1) AND ws.warehouse_id=w_id) THEN
    INSERT INTO public.warehouse_stock(warehouse_id,product_id,stock,updated_at) SELECT w_id,p.id,4,now() FROM public.products p WHERE lower(trim(p.name))=lower(trim('Bambuk A10- Yemisan')) LIMIT 1;
  ELSIF (SELECT COALESCE(SUM(ws.stock),0) FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Bambuk A10- Yemisan')) LIMIT 1))=0 THEN
    UPDATE public.warehouse_stock ws SET stock=4,updated_at=now() WHERE ws.warehouse_id=w_id AND ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Bambuk A10- Yemisan')) LIMIT 1);
  END IF;

  -- Bambuk A19 -Sarımtıl Kətan
  IF NOT EXISTS (SELECT 1 FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Bambuk A19 -Sarımtıl Kətan')) LIMIT 1) AND ws.warehouse_id=w_id) THEN
    INSERT INTO public.warehouse_stock(warehouse_id,product_id,stock,updated_at) SELECT w_id,p.id,6,now() FROM public.products p WHERE lower(trim(p.name))=lower(trim('Bambuk A19 -Sarımtıl Kətan')) LIMIT 1;
  ELSIF (SELECT COALESCE(SUM(ws.stock),0) FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Bambuk A19 -Sarımtıl Kətan')) LIMIT 1))=0 THEN
    UPDATE public.warehouse_stock ws SET stock=6,updated_at=now() WHERE ws.warehouse_id=w_id AND ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Bambuk A19 -Sarımtıl Kətan')) LIMIT 1);
  END IF;

  -- Bambuk A17- Mavi Kətan
  IF NOT EXISTS (SELECT 1 FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Bambuk A17- Mavi Kətan')) LIMIT 1) AND ws.warehouse_id=w_id) THEN
    INSERT INTO public.warehouse_stock(warehouse_id,product_id,stock,updated_at) SELECT w_id,p.id,9,now() FROM public.products p WHERE lower(trim(p.name))=lower(trim('Bambuk A17- Mavi Kətan')) LIMIT 1;
  ELSIF (SELECT COALESCE(SUM(ws.stock),0) FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Bambuk A17- Mavi Kətan')) LIMIT 1))=0 THEN
    UPDATE public.warehouse_stock ws SET stock=9,updated_at=now() WHERE ws.warehouse_id=w_id AND ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Bambuk A17- Mavi Kətan')) LIMIT 1);
  END IF;

  -- Bambuk A08- Boz ağac
  IF NOT EXISTS (SELECT 1 FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Bambuk A08- Boz ağac')) LIMIT 1) AND ws.warehouse_id=w_id) THEN
    INSERT INTO public.warehouse_stock(warehouse_id,product_id,stock,updated_at) SELECT w_id,p.id,2,now() FROM public.products p WHERE lower(trim(p.name))=lower(trim('Bambuk A08- Boz ağac')) LIMIT 1;
  ELSIF (SELECT COALESCE(SUM(ws.stock),0) FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Bambuk A08- Boz ağac')) LIMIT 1))=0 THEN
    UPDATE public.warehouse_stock ws SET stock=2,updated_at=now() WHERE ws.warehouse_id=w_id AND ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Bambuk A08- Boz ağac')) LIMIT 1);
  END IF;

  -- Bambuk A18 - Mavi qızılı kətan
  IF NOT EXISTS (SELECT 1 FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Bambuk A18 - Mavi qızılı kətan')) LIMIT 1) AND ws.warehouse_id=w_id) THEN
    INSERT INTO public.warehouse_stock(warehouse_id,product_id,stock,updated_at) SELECT w_id,p.id,7,now() FROM public.products p WHERE lower(trim(p.name))=lower(trim('Bambuk A18 - Mavi qızılı kətan')) LIMIT 1;
  ELSIF (SELECT COALESCE(SUM(ws.stock),0) FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Bambuk A18 - Mavi qızılı kətan')) LIMIT 1))=0 THEN
    UPDATE public.warehouse_stock ws SET stock=7,updated_at=now() WHERE ws.warehouse_id=w_id AND ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Bambuk A18 - Mavi qızılı kətan')) LIMIT 1);
  END IF;

  -- Bambuk Panel
  IF NOT EXISTS (SELECT 1 FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Bambuk Panel')) LIMIT 1) AND ws.warehouse_id=w_id) THEN
    INSERT INTO public.warehouse_stock(warehouse_id,product_id,stock,updated_at) SELECT w_id,p.id,22,now() FROM public.products p WHERE lower(trim(p.name))=lower(trim('Bambuk Panel')) LIMIT 1;
  ELSIF (SELECT COALESCE(SUM(ws.stock),0) FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Bambuk Panel')) LIMIT 1))=0 THEN
    UPDATE public.warehouse_stock ws SET stock=22,updated_at=now() WHERE ws.warehouse_id=w_id AND ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Bambuk Panel')) LIMIT 1);
  END IF;

  -- Bambuk A21 - Ağ 3m
  IF NOT EXISTS (SELECT 1 FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Bambuk A21 - Ağ 3m')) LIMIT 1) AND ws.warehouse_id=w_id) THEN
    INSERT INTO public.warehouse_stock(warehouse_id,product_id,stock,updated_at) SELECT w_id,p.id,7,now() FROM public.products p WHERE lower(trim(p.name))=lower(trim('Bambuk A21 - Ağ 3m')) LIMIT 1;
  ELSIF (SELECT COALESCE(SUM(ws.stock),0) FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Bambuk A21 - Ağ 3m')) LIMIT 1))=0 THEN
    UPDATE public.warehouse_stock ws SET stock=7,updated_at=now() WHERE ws.warehouse_id=w_id AND ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Bambuk A21 - Ağ 3m')) LIMIT 1);
  END IF;

  -- Bambuk A06- Kətan
  IF NOT EXISTS (SELECT 1 FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Bambuk A06- Kətan')) LIMIT 1) AND ws.warehouse_id=w_id) THEN
    INSERT INTO public.warehouse_stock(warehouse_id,product_id,stock,updated_at) SELECT w_id,p.id,2,now() FROM public.products p WHERE lower(trim(p.name))=lower(trim('Bambuk A06- Kətan')) LIMIT 1;
  ELSIF (SELECT COALESCE(SUM(ws.stock),0) FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Bambuk A06- Kətan')) LIMIT 1))=0 THEN
    UPDATE public.warehouse_stock ws SET stock=2,updated_at=now() WHERE ws.warehouse_id=w_id AND ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Bambuk A06- Kətan')) LIMIT 1);
  END IF;

  -- Bambuk Vensiyanka qızılı
  IF NOT EXISTS (SELECT 1 FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Bambuk Vensiyanka qızılı')) LIMIT 1) AND ws.warehouse_id=w_id) THEN
    INSERT INTO public.warehouse_stock(warehouse_id,product_id,stock,updated_at) SELECT w_id,p.id,0,now() FROM public.products p WHERE lower(trim(p.name))=lower(trim('Bambuk Vensiyanka qızılı')) LIMIT 1;
  ELSIF (SELECT COALESCE(SUM(ws.stock),0) FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Bambuk Vensiyanka qızılı')) LIMIT 1))=0 THEN
    UPDATE public.warehouse_stock ws SET stock=0,updated_at=now() WHERE ws.warehouse_id=w_id AND ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Bambuk Vensiyanka qızılı')) LIMIT 1);
  END IF;

  -- Bambuk-D14
  IF NOT EXISTS (SELECT 1 FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Bambuk-D14')) LIMIT 1) AND ws.warehouse_id=w_id) THEN
    INSERT INTO public.warehouse_stock(warehouse_id,product_id,stock,updated_at) SELECT w_id,p.id,6,now() FROM public.products p WHERE lower(trim(p.name))=lower(trim('Bambuk-D14')) LIMIT 1;
  ELSIF (SELECT COALESCE(SUM(ws.stock),0) FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Bambuk-D14')) LIMIT 1))=0 THEN
    UPDATE public.warehouse_stock ws SET stock=6,updated_at=now() WHERE ws.warehouse_id=w_id AND ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Bambuk-D14')) LIMIT 1);
  END IF;

  -- Rose gold
  IF NOT EXISTS (SELECT 1 FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Rose gold')) LIMIT 1) AND ws.warehouse_id=w_id) THEN
    INSERT INTO public.warehouse_stock(warehouse_id,product_id,stock,updated_at) SELECT w_id,p.id,4,now() FROM public.products p WHERE lower(trim(p.name))=lower(trim('Rose gold')) LIMIT 1;
  ELSIF (SELECT COALESCE(SUM(ws.stock),0) FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Rose gold')) LIMIT 1))=0 THEN
    UPDATE public.warehouse_stock ws SET stock=4,updated_at=now() WHERE ws.warehouse_id=w_id AND ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Rose gold')) LIMIT 1);
  END IF;

  -- Bambuk -D10
  IF NOT EXISTS (SELECT 1 FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Bambuk -D10')) LIMIT 1) AND ws.warehouse_id=w_id) THEN
    INSERT INTO public.warehouse_stock(warehouse_id,product_id,stock,updated_at) SELECT w_id,p.id,9,now() FROM public.products p WHERE lower(trim(p.name))=lower(trim('Bambuk -D10')) LIMIT 1;
  ELSIF (SELECT COALESCE(SUM(ws.stock),0) FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Bambuk -D10')) LIMIT 1))=0 THEN
    UPDATE public.warehouse_stock ws SET stock=9,updated_at=now() WHERE ws.warehouse_id=w_id AND ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Bambuk -D10')) LIMIT 1);
  END IF;

  -- Bambuk D3 - Boz düz xett
  IF NOT EXISTS (SELECT 1 FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Bambuk D3 - Boz düz xett')) LIMIT 1) AND ws.warehouse_id=w_id) THEN
    INSERT INTO public.warehouse_stock(warehouse_id,product_id,stock,updated_at) SELECT w_id,p.id,0,now() FROM public.products p WHERE lower(trim(p.name))=lower(trim('Bambuk D3 - Boz düz xett')) LIMIT 1;
  ELSIF (SELECT COALESCE(SUM(ws.stock),0) FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Bambuk D3 - Boz düz xett')) LIMIT 1))=0 THEN
    UPDATE public.warehouse_stock ws SET stock=0,updated_at=now() WHERE ws.warehouse_id=w_id AND ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Bambuk D3 - Boz düz xett')) LIMIT 1);
  END IF;

  -- Bambuk -D7 Tünd qəhvəyi
  IF NOT EXISTS (SELECT 1 FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Bambuk -D7 Tünd qəhvəyi')) LIMIT 1) AND ws.warehouse_id=w_id) THEN
    INSERT INTO public.warehouse_stock(warehouse_id,product_id,stock,updated_at) SELECT w_id,p.id,10,now() FROM public.products p WHERE lower(trim(p.name))=lower(trim('Bambuk -D7 Tünd qəhvəyi')) LIMIT 1;
  ELSIF (SELECT COALESCE(SUM(ws.stock),0) FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Bambuk -D7 Tünd qəhvəyi')) LIMIT 1))=0 THEN
    UPDATE public.warehouse_stock ws SET stock=10,updated_at=now() WHERE ws.warehouse_id=w_id AND ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Bambuk -D7 Tünd qəhvəyi')) LIMIT 1);
  END IF;

  -- Bambuk-Düz xətt açıq
  IF NOT EXISTS (SELECT 1 FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Bambuk-Düz xətt açıq')) LIMIT 1) AND ws.warehouse_id=w_id) THEN
    INSERT INTO public.warehouse_stock(warehouse_id,product_id,stock,updated_at) SELECT w_id,p.id,5,now() FROM public.products p WHERE lower(trim(p.name))=lower(trim('Bambuk-Düz xətt açıq')) LIMIT 1;
  ELSIF (SELECT COALESCE(SUM(ws.stock),0) FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Bambuk-Düz xətt açıq')) LIMIT 1))=0 THEN
    UPDATE public.warehouse_stock ws SET stock=5,updated_at=now() WHERE ws.warehouse_id=w_id AND ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Bambuk-Düz xətt açıq')) LIMIT 1);
  END IF;

  -- Bambuk -Yolka açıq
  IF NOT EXISTS (SELECT 1 FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Bambuk -Yolka açıq')) LIMIT 1) AND ws.warehouse_id=w_id) THEN
    INSERT INTO public.warehouse_stock(warehouse_id,product_id,stock,updated_at) SELECT w_id,p.id,2,now() FROM public.products p WHERE lower(trim(p.name))=lower(trim('Bambuk -Yolka açıq')) LIMIT 1;
  ELSIF (SELECT COALESCE(SUM(ws.stock),0) FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Bambuk -Yolka açıq')) LIMIT 1))=0 THEN
    UPDATE public.warehouse_stock ws SET stock=2,updated_at=now() WHERE ws.warehouse_id=w_id AND ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Bambuk -Yolka açıq')) LIMIT 1);
  END IF;

  -- Bambuk D5 -Kappucino
  IF NOT EXISTS (SELECT 1 FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Bambuk D5 -Kappucino')) LIMIT 1) AND ws.warehouse_id=w_id) THEN
    INSERT INTO public.warehouse_stock(warehouse_id,product_id,stock,updated_at) SELECT w_id,p.id,3,now() FROM public.products p WHERE lower(trim(p.name))=lower(trim('Bambuk D5 -Kappucino')) LIMIT 1;
  ELSIF (SELECT COALESCE(SUM(ws.stock),0) FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Bambuk D5 -Kappucino')) LIMIT 1))=0 THEN
    UPDATE public.warehouse_stock ws SET stock=3,updated_at=now() WHERE ws.warehouse_id=w_id AND ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Bambuk D5 -Kappucino')) LIMIT 1);
  END IF;

  -- Bambuk -D13 Qızılı
  IF NOT EXISTS (SELECT 1 FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Bambuk -D13 Qızılı')) LIMIT 1) AND ws.warehouse_id=w_id) THEN
    INSERT INTO public.warehouse_stock(warehouse_id,product_id,stock,updated_at) SELECT w_id,p.id,3,now() FROM public.products p WHERE lower(trim(p.name))=lower(trim('Bambuk -D13 Qızılı')) LIMIT 1;
  ELSIF (SELECT COALESCE(SUM(ws.stock),0) FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Bambuk -D13 Qızılı')) LIMIT 1))=0 THEN
    UPDATE public.warehouse_stock ws SET stock=3,updated_at=now() WHERE ws.warehouse_id=w_id AND ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Bambuk -D13 Qızılı')) LIMIT 1);
  END IF;

  -- Bambuk -D12 Gümüşüı yarpaq
  IF NOT EXISTS (SELECT 1 FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Bambuk -D12 Gümüşüı yarpaq')) LIMIT 1) AND ws.warehouse_id=w_id) THEN
    INSERT INTO public.warehouse_stock(warehouse_id,product_id,stock,updated_at) SELECT w_id,p.id,3,now() FROM public.products p WHERE lower(trim(p.name))=lower(trim('Bambuk -D12 Gümüşüı yarpaq')) LIMIT 1;
  ELSIF (SELECT COALESCE(SUM(ws.stock),0) FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Bambuk -D12 Gümüşüı yarpaq')) LIMIT 1))=0 THEN
    UPDATE public.warehouse_stock ws SET stock=3,updated_at=now() WHERE ws.warehouse_id=w_id AND ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Bambuk -D12 Gümüşüı yarpaq')) LIMIT 1);
  END IF;

  -- Bambuk Vensiyanka Gümüşü
  IF NOT EXISTS (SELECT 1 FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Bambuk Vensiyanka Gümüşü')) LIMIT 1) AND ws.warehouse_id=w_id) THEN
    INSERT INTO public.warehouse_stock(warehouse_id,product_id,stock,updated_at) SELECT w_id,p.id,2,now() FROM public.products p WHERE lower(trim(p.name))=lower(trim('Bambuk Vensiyanka Gümüşü')) LIMIT 1;
  ELSIF (SELECT COALESCE(SUM(ws.stock),0) FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Bambuk Vensiyanka Gümüşü')) LIMIT 1))=0 THEN
    UPDATE public.warehouse_stock ws SET stock=2,updated_at=now() WHERE ws.warehouse_id=w_id AND ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Bambuk Vensiyanka Gümüşü')) LIMIT 1);
  END IF;

  -- Bambuk - Lux fosfor
  IF NOT EXISTS (SELECT 1 FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Bambuk - Lux fosfor')) LIMIT 1) AND ws.warehouse_id=w_id) THEN
    INSERT INTO public.warehouse_stock(warehouse_id,product_id,stock,updated_at) SELECT w_id,p.id,2,now() FROM public.products p WHERE lower(trim(p.name))=lower(trim('Bambuk - Lux fosfor')) LIMIT 1;
  ELSIF (SELECT COALESCE(SUM(ws.stock),0) FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Bambuk - Lux fosfor')) LIMIT 1))=0 THEN
    UPDATE public.warehouse_stock ws SET stock=2,updated_at=now() WHERE ws.warehouse_id=w_id AND ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Bambuk - Lux fosfor')) LIMIT 1);
  END IF;

  -- Bambuk A13-Yağış qızılı
  IF NOT EXISTS (SELECT 1 FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Bambuk A13-Yağış qızılı')) LIMIT 1) AND ws.warehouse_id=w_id) THEN
    INSERT INTO public.warehouse_stock(warehouse_id,product_id,stock,updated_at) SELECT w_id,p.id,6,now() FROM public.products p WHERE lower(trim(p.name))=lower(trim('Bambuk A13-Yağış qızılı')) LIMIT 1;
  ELSIF (SELECT COALESCE(SUM(ws.stock),0) FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Bambuk A13-Yağış qızılı')) LIMIT 1))=0 THEN
    UPDATE public.warehouse_stock ws SET stock=6,updated_at=now() WHERE ws.warehouse_id=w_id AND ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Bambuk A13-Yağış qızılı')) LIMIT 1);
  END IF;

  -- Bambuk A14-Sarı taxta
  IF NOT EXISTS (SELECT 1 FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Bambuk A14-Sarı taxta')) LIMIT 1) AND ws.warehouse_id=w_id) THEN
    INSERT INTO public.warehouse_stock(warehouse_id,product_id,stock,updated_at) SELECT w_id,p.id,6,now() FROM public.products p WHERE lower(trim(p.name))=lower(trim('Bambuk A14-Sarı taxta')) LIMIT 1;
  ELSIF (SELECT COALESCE(SUM(ws.stock),0) FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Bambuk A14-Sarı taxta')) LIMIT 1))=0 THEN
    UPDATE public.warehouse_stock ws SET stock=6,updated_at=now() WHERE ws.warehouse_id=w_id AND ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Bambuk A14-Sarı taxta')) LIMIT 1);
  END IF;

  -- Bambuk A11- Şfon
  IF NOT EXISTS (SELECT 1 FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Bambuk A11- Şfon')) LIMIT 1) AND ws.warehouse_id=w_id) THEN
    INSERT INTO public.warehouse_stock(warehouse_id,product_id,stock,updated_at) SELECT w_id,p.id,1,now() FROM public.products p WHERE lower(trim(p.name))=lower(trim('Bambuk A11- Şfon')) LIMIT 1;
  ELSIF (SELECT COALESCE(SUM(ws.stock),0) FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Bambuk A11- Şfon')) LIMIT 1))=0 THEN
    UPDATE public.warehouse_stock ws SET stock=1,updated_at=now() WHERE ws.warehouse_id=w_id AND ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Bambuk A11- Şfon')) LIMIT 1);
  END IF;

  -- Bambuk Yolka
  IF NOT EXISTS (SELECT 1 FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Bambuk Yolka')) LIMIT 1) AND ws.warehouse_id=w_id) THEN
    INSERT INTO public.warehouse_stock(warehouse_id,product_id,stock,updated_at) SELECT w_id,p.id,1,now() FROM public.products p WHERE lower(trim(p.name))=lower(trim('Bambuk Yolka')) LIMIT 1;
  ELSIF (SELECT COALESCE(SUM(ws.stock),0) FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Bambuk Yolka')) LIMIT 1))=0 THEN
    UPDATE public.warehouse_stock ws SET stock=1,updated_at=now() WHERE ws.warehouse_id=w_id AND ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Bambuk Yolka')) LIMIT 1);
  END IF;

  -- Yolka duz
  IF NOT EXISTS (SELECT 1 FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Yolka duz')) LIMIT 1) AND ws.warehouse_id=w_id) THEN
    INSERT INTO public.warehouse_stock(warehouse_id,product_id,stock,updated_at) SELECT w_id,p.id,1,now() FROM public.products p WHERE lower(trim(p.name))=lower(trim('Yolka duz')) LIMIT 1;
  ELSIF (SELECT COALESCE(SUM(ws.stock),0) FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Yolka duz')) LIMIT 1))=0 THEN
    UPDATE public.warehouse_stock ws SET stock=1,updated_at=now() WHERE ws.warehouse_id=w_id AND ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Yolka duz')) LIMIT 1);
  END IF;

  -- Bambuk -D11 Kətan
  IF NOT EXISTS (SELECT 1 FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Bambuk -D11 Kətan')) LIMIT 1) AND ws.warehouse_id=w_id) THEN
    INSERT INTO public.warehouse_stock(warehouse_id,product_id,stock,updated_at) SELECT w_id,p.id,3,now() FROM public.products p WHERE lower(trim(p.name))=lower(trim('Bambuk -D11 Kətan')) LIMIT 1;
  ELSIF (SELECT COALESCE(SUM(ws.stock),0) FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Bambuk -D11 Kətan')) LIMIT 1))=0 THEN
    UPDATE public.warehouse_stock ws SET stock=3,updated_at=now() WHERE ws.warehouse_id=w_id AND ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Bambuk -D11 Kətan')) LIMIT 1);
  END IF;

  -- Bambuk- P AC
  IF NOT EXISTS (SELECT 1 FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Bambuk- P AC')) LIMIT 1) AND ws.warehouse_id=w_id) THEN
    INSERT INTO public.warehouse_stock(warehouse_id,product_id,stock,updated_at) SELECT w_id,p.id,1,now() FROM public.products p WHERE lower(trim(p.name))=lower(trim('Bambuk- P AC')) LIMIT 1;
  ELSIF (SELECT COALESCE(SUM(ws.stock),0) FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Bambuk- P AC')) LIMIT 1))=0 THEN
    UPDATE public.warehouse_stock ws SET stock=1,updated_at=now() WHERE ws.warehouse_id=w_id AND ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Bambuk- P AC')) LIMIT 1);
  END IF;

  -- Bambuk A09- sarı marble
  IF NOT EXISTS (SELECT 1 FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Bambuk A09- sarı marble')) LIMIT 1) AND ws.warehouse_id=w_id) THEN
    INSERT INTO public.warehouse_stock(warehouse_id,product_id,stock,updated_at) SELECT w_id,p.id,1,now() FROM public.products p WHERE lower(trim(p.name))=lower(trim('Bambuk A09- sarı marble')) LIMIT 1;
  ELSIF (SELECT COALESCE(SUM(ws.stock),0) FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Bambuk A09- sarı marble')) LIMIT 1))=0 THEN
    UPDATE public.warehouse_stock ws SET stock=1,updated_at=now() WHERE ws.warehouse_id=w_id AND ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Bambuk A09- sarı marble')) LIMIT 1);
  END IF;

  -- Bambuk -D9 Krem saya
  IF NOT EXISTS (SELECT 1 FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Bambuk -D9 Krem saya')) LIMIT 1) AND ws.warehouse_id=w_id) THEN
    INSERT INTO public.warehouse_stock(warehouse_id,product_id,stock,updated_at) SELECT w_id,p.id,1,now() FROM public.products p WHERE lower(trim(p.name))=lower(trim('Bambuk -D9 Krem saya')) LIMIT 1;
  ELSIF (SELECT COALESCE(SUM(ws.stock),0) FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Bambuk -D9 Krem saya')) LIMIT 1))=0 THEN
    UPDATE public.warehouse_stock ws SET stock=1,updated_at=now() WHERE ws.warehouse_id=w_id AND ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Bambuk -D9 Krem saya')) LIMIT 1);
  END IF;

  -- Bambuk -Krem zərli
  IF NOT EXISTS (SELECT 1 FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Bambuk -Krem zərli')) LIMIT 1) AND ws.warehouse_id=w_id) THEN
    INSERT INTO public.warehouse_stock(warehouse_id,product_id,stock,updated_at) SELECT w_id,p.id,3,now() FROM public.products p WHERE lower(trim(p.name))=lower(trim('Bambuk -Krem zərli')) LIMIT 1;
  ELSIF (SELECT COALESCE(SUM(ws.stock),0) FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Bambuk -Krem zərli')) LIMIT 1))=0 THEN
    UPDATE public.warehouse_stock ws SET stock=3,updated_at=now() WHERE ws.warehouse_id=w_id AND ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Bambuk -Krem zərli')) LIMIT 1);
  END IF;

  -- Bambuk -D6 Tünd Yolka
  IF NOT EXISTS (SELECT 1 FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Bambuk -D6 Tünd Yolka')) LIMIT 1) AND ws.warehouse_id=w_id) THEN
    INSERT INTO public.warehouse_stock(warehouse_id,product_id,stock,updated_at) SELECT w_id,p.id,0,now() FROM public.products p WHERE lower(trim(p.name))=lower(trim('Bambuk -D6 Tünd Yolka')) LIMIT 1;
  ELSIF (SELECT COALESCE(SUM(ws.stock),0) FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Bambuk -D6 Tünd Yolka')) LIMIT 1))=0 THEN
    UPDATE public.warehouse_stock ws SET stock=0,updated_at=now() WHERE ws.warehouse_id=w_id AND ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Bambuk -D6 Tünd Yolka')) LIMIT 1);
  END IF;

  -- Bambuk A24
  IF NOT EXISTS (SELECT 1 FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Bambuk A24')) LIMIT 1) AND ws.warehouse_id=w_id) THEN
    INSERT INTO public.warehouse_stock(warehouse_id,product_id,stock,updated_at) SELECT w_id,p.id,10,now() FROM public.products p WHERE lower(trim(p.name))=lower(trim('Bambuk A24')) LIMIT 1;
  ELSIF (SELECT COALESCE(SUM(ws.stock),0) FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Bambuk A24')) LIMIT 1))=0 THEN
    UPDATE public.warehouse_stock ws SET stock=10,updated_at=now() WHERE ws.warehouse_id=w_id AND ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Bambuk A24')) LIMIT 1);
  END IF;

  -- Bambuk A25
  IF NOT EXISTS (SELECT 1 FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Bambuk A25')) LIMIT 1) AND ws.warehouse_id=w_id) THEN
    INSERT INTO public.warehouse_stock(warehouse_id,product_id,stock,updated_at) SELECT w_id,p.id,10,now() FROM public.products p WHERE lower(trim(p.name))=lower(trim('Bambuk A25')) LIMIT 1;
  ELSIF (SELECT COALESCE(SUM(ws.stock),0) FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Bambuk A25')) LIMIT 1))=0 THEN
    UPDATE public.warehouse_stock ws SET stock=10,updated_at=now() WHERE ws.warehouse_id=w_id AND ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Bambuk A25')) LIMIT 1);
  END IF;

  -- Bambuk A26
  IF NOT EXISTS (SELECT 1 FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Bambuk A26')) LIMIT 1) AND ws.warehouse_id=w_id) THEN
    INSERT INTO public.warehouse_stock(warehouse_id,product_id,stock,updated_at) SELECT w_id,p.id,10,now() FROM public.products p WHERE lower(trim(p.name))=lower(trim('Bambuk A26')) LIMIT 1;
  ELSIF (SELECT COALESCE(SUM(ws.stock),0) FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Bambuk A26')) LIMIT 1))=0 THEN
    UPDATE public.warehouse_stock ws SET stock=10,updated_at=now() WHERE ws.warehouse_id=w_id AND ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Bambuk A26')) LIMIT 1);
  END IF;

  -- Bambuk A27
  IF NOT EXISTS (SELECT 1 FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Bambuk A27')) LIMIT 1) AND ws.warehouse_id=w_id) THEN
    INSERT INTO public.warehouse_stock(warehouse_id,product_id,stock,updated_at) SELECT w_id,p.id,10,now() FROM public.products p WHERE lower(trim(p.name))=lower(trim('Bambuk A27')) LIMIT 1;
  ELSIF (SELECT COALESCE(SUM(ws.stock),0) FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Bambuk A27')) LIMIT 1))=0 THEN
    UPDATE public.warehouse_stock ws SET stock=10,updated_at=now() WHERE ws.warehouse_id=w_id AND ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Bambuk A27')) LIMIT 1);
  END IF;

  -- Bambuk A28
  IF NOT EXISTS (SELECT 1 FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Bambuk A28')) LIMIT 1) AND ws.warehouse_id=w_id) THEN
    INSERT INTO public.warehouse_stock(warehouse_id,product_id,stock,updated_at) SELECT w_id,p.id,10,now() FROM public.products p WHERE lower(trim(p.name))=lower(trim('Bambuk A28')) LIMIT 1;
  ELSIF (SELECT COALESCE(SUM(ws.stock),0) FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Bambuk A28')) LIMIT 1))=0 THEN
    UPDATE public.warehouse_stock ws SET stock=10,updated_at=now() WHERE ws.warehouse_id=w_id AND ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Bambuk A28')) LIMIT 1);
  END IF;

  -- Bambuk A29
  IF NOT EXISTS (SELECT 1 FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Bambuk A29')) LIMIT 1) AND ws.warehouse_id=w_id) THEN
    INSERT INTO public.warehouse_stock(warehouse_id,product_id,stock,updated_at) SELECT w_id,p.id,10,now() FROM public.products p WHERE lower(trim(p.name))=lower(trim('Bambuk A29')) LIMIT 1;
  ELSIF (SELECT COALESCE(SUM(ws.stock),0) FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Bambuk A29')) LIMIT 1))=0 THEN
    UPDATE public.warehouse_stock ws SET stock=10,updated_at=now() WHERE ws.warehouse_id=w_id AND ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Bambuk A29')) LIMIT 1);
  END IF;

  -- D2515-D2
  IF NOT EXISTS (SELECT 1 FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('D2515-D2')) LIMIT 1) AND ws.warehouse_id=w_id) THEN
    INSERT INTO public.warehouse_stock(warehouse_id,product_id,stock,updated_at) SELECT w_id,p.id,417,now() FROM public.products p WHERE lower(trim(p.name))=lower(trim('D2515-D2')) LIMIT 1;
  ELSIF (SELECT COALESCE(SUM(ws.stock),0) FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('D2515-D2')) LIMIT 1))=0 THEN
    UPDATE public.warehouse_stock ws SET stock=417,updated_at=now() WHERE ws.warehouse_id=w_id AND ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('D2515-D2')) LIMIT 1);
  END IF;

  -- D4010-D2
  IF NOT EXISTS (SELECT 1 FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('D4010-D2')) LIMIT 1) AND ws.warehouse_id=w_id) THEN
    INSERT INTO public.warehouse_stock(warehouse_id,product_id,stock,updated_at) SELECT w_id,p.id,23,now() FROM public.products p WHERE lower(trim(p.name))=lower(trim('D4010-D2')) LIMIT 1;
  ELSIF (SELECT COALESCE(SUM(ws.stock),0) FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('D4010-D2')) LIMIT 1))=0 THEN
    UPDATE public.warehouse_stock ws SET stock=23,updated_at=now() WHERE ws.warehouse_id=w_id AND ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('D4010-D2')) LIMIT 1);
  END IF;

  -- DD4020-D2
  IF NOT EXISTS (SELECT 1 FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('DD4020-D2')) LIMIT 1) AND ws.warehouse_id=w_id) THEN
    INSERT INTO public.warehouse_stock(warehouse_id,product_id,stock,updated_at) SELECT w_id,p.id,255,now() FROM public.products p WHERE lower(trim(p.name))=lower(trim('DD4020-D2')) LIMIT 1;
  ELSIF (SELECT COALESCE(SUM(ws.stock),0) FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('DD4020-D2')) LIMIT 1))=0 THEN
    UPDATE public.warehouse_stock ws SET stock=255,updated_at=now() WHERE ws.warehouse_id=w_id AND ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('DD4020-D2')) LIMIT 1);
  END IF;

  -- DDB4020-D2
  IF NOT EXISTS (SELECT 1 FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('DDB4020-D2')) LIMIT 1) AND ws.warehouse_id=w_id) THEN
    INSERT INTO public.warehouse_stock(warehouse_id,product_id,stock,updated_at) SELECT w_id,p.id,261,now() FROM public.products p WHERE lower(trim(p.name))=lower(trim('DDB4020-D2')) LIMIT 1;
  ELSIF (SELECT COALESCE(SUM(ws.stock),0) FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('DDB4020-D2')) LIMIT 1))=0 THEN
    UPDATE public.warehouse_stock ws SET stock=261,updated_at=now() WHERE ws.warehouse_id=w_id AND ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('DDB4020-D2')) LIMIT 1);
  END IF;

  -- Güzgü dekor 30x30
  IF NOT EXISTS (SELECT 1 FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Güzgü dekor 30x30')) LIMIT 1) AND ws.warehouse_id=w_id) THEN
    INSERT INTO public.warehouse_stock(warehouse_id,product_id,stock,updated_at) SELECT w_id,p.id,135,now() FROM public.products p WHERE lower(trim(p.name))=lower(trim('Güzgü dekor 30x30')) LIMIT 1;
  ELSIF (SELECT COALESCE(SUM(ws.stock),0) FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Güzgü dekor 30x30')) LIMIT 1))=0 THEN
    UPDATE public.warehouse_stock ws SET stock=135,updated_at=now() WHERE ws.warehouse_id=w_id AND ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Güzgü dekor 30x30')) LIMIT 1);
  END IF;

  -- Güzgü pətək 24x21
  IF NOT EXISTS (SELECT 1 FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Güzgü pətək 24x21')) LIMIT 1) AND ws.warehouse_id=w_id) THEN
    INSERT INTO public.warehouse_stock(warehouse_id,product_id,stock,updated_at) SELECT w_id,p.id,20,now() FROM public.products p WHERE lower(trim(p.name))=lower(trim('Güzgü pətək 24x21')) LIMIT 1;
  ELSIF (SELECT COALESCE(SUM(ws.stock),0) FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Güzgü pətək 24x21')) LIMIT 1))=0 THEN
    UPDATE public.warehouse_stock ws SET stock=20,updated_at=now() WHERE ws.warehouse_id=w_id AND ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Güzgü pətək 24x21')) LIMIT 1);
  END IF;

  -- Güzgü piano bürünc 30x60
  IF NOT EXISTS (SELECT 1 FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Güzgü piano bürünc 30x60')) LIMIT 1) AND ws.warehouse_id=w_id) THEN
    INSERT INTO public.warehouse_stock(warehouse_id,product_id,stock,updated_at) SELECT w_id,p.id,35,now() FROM public.products p WHERE lower(trim(p.name))=lower(trim('Güzgü piano bürünc 30x60')) LIMIT 1;
  ELSIF (SELECT COALESCE(SUM(ws.stock),0) FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Güzgü piano bürünc 30x60')) LIMIT 1))=0 THEN
    UPDATE public.warehouse_stock ws SET stock=35,updated_at=now() WHERE ws.warehouse_id=w_id AND ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Güzgü piano bürünc 30x60')) LIMIT 1);
  END IF;

  -- Güzgü piano gümüşü 30x60
  IF NOT EXISTS (SELECT 1 FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Güzgü piano gümüşü 30x60')) LIMIT 1) AND ws.warehouse_id=w_id) THEN
    INSERT INTO public.warehouse_stock(warehouse_id,product_id,stock,updated_at) SELECT w_id,p.id,29,now() FROM public.products p WHERE lower(trim(p.name))=lower(trim('Güzgü piano gümüşü 30x60')) LIMIT 1;
  ELSIF (SELECT COALESCE(SUM(ws.stock),0) FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Güzgü piano gümüşü 30x60')) LIMIT 1))=0 THEN
    UPDATE public.warehouse_stock ws SET stock=29,updated_at=now() WHERE ws.warehouse_id=w_id AND ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Güzgü piano gümüşü 30x60')) LIMIT 1);
  END IF;

  -- Güzgü piano qızılı 30x60
  IF NOT EXISTS (SELECT 1 FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Güzgü piano qızılı 30x60')) LIMIT 1) AND ws.warehouse_id=w_id) THEN
    INSERT INTO public.warehouse_stock(warehouse_id,product_id,stock,updated_at) SELECT w_id,p.id,24,now() FROM public.products p WHERE lower(trim(p.name))=lower(trim('Güzgü piano qızılı 30x60')) LIMIT 1;
  ELSIF (SELECT COALESCE(SUM(ws.stock),0) FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Güzgü piano qızılı 30x60')) LIMIT 1))=0 THEN
    UPDATE public.warehouse_stock ws SET stock=24,updated_at=now() WHERE ws.warehouse_id=w_id AND ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Güzgü piano qızılı 30x60')) LIMIT 1);
  END IF;

  -- Güzgü piano yaşıl 30x60
  IF NOT EXISTS (SELECT 1 FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Güzgü piano yaşıl 30x60')) LIMIT 1) AND ws.warehouse_id=w_id) THEN
    INSERT INTO public.warehouse_stock(warehouse_id,product_id,stock,updated_at) SELECT w_id,p.id,25,now() FROM public.products p WHERE lower(trim(p.name))=lower(trim('Güzgü piano yaşıl 30x60')) LIMIT 1;
  ELSIF (SELECT COALESCE(SUM(ws.stock),0) FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Güzgü piano yaşıl 30x60')) LIMIT 1))=0 THEN
    UPDATE public.warehouse_stock ws SET stock=25,updated_at=now() WHERE ws.warehouse_id=w_id AND ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Güzgü piano yaşıl 30x60')) LIMIT 1);
  END IF;

  -- Güzgü romb 20x30
  IF NOT EXISTS (SELECT 1 FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Güzgü romb 20x30')) LIMIT 1) AND ws.warehouse_id=w_id) THEN
    INSERT INTO public.warehouse_stock(warehouse_id,product_id,stock,updated_at) SELECT w_id,p.id,120,now() FROM public.products p WHERE lower(trim(p.name))=lower(trim('Güzgü romb 20x30')) LIMIT 1;
  ELSIF (SELECT COALESCE(SUM(ws.stock),0) FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Güzgü romb 20x30')) LIMIT 1))=0 THEN
    UPDATE public.warehouse_stock ws SET stock=120,updated_at=now() WHERE ws.warehouse_id=w_id AND ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Güzgü romb 20x30')) LIMIT 1);
  END IF;

  -- Dəmir saat
  IF NOT EXISTS (SELECT 1 FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Dəmir saat')) LIMIT 1) AND ws.warehouse_id=w_id) THEN
    INSERT INTO public.warehouse_stock(warehouse_id,product_id,stock,updated_at) SELECT w_id,p.id,1,now() FROM public.products p WHERE lower(trim(p.name))=lower(trim('Dəmir saat')) LIMIT 1;
  ELSIF (SELECT COALESCE(SUM(ws.stock),0) FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Dəmir saat')) LIMIT 1))=0 THEN
    UPDATE public.warehouse_stock ws SET stock=1,updated_at=now() WHERE ws.warehouse_id=w_id AND ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Dəmir saat')) LIMIT 1);
  END IF;

  -- Dəmir tablo qız
  IF NOT EXISTS (SELECT 1 FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Dəmir tablo qız')) LIMIT 1) AND ws.warehouse_id=w_id) THEN
    INSERT INTO public.warehouse_stock(warehouse_id,product_id,stock,updated_at) SELECT w_id,p.id,2,now() FROM public.products p WHERE lower(trim(p.name))=lower(trim('Dəmir tablo qız')) LIMIT 1;
  ELSIF (SELECT COALESCE(SUM(ws.stock),0) FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Dəmir tablo qız')) LIMIT 1))=0 THEN
    UPDATE public.warehouse_stock ws SET stock=2,updated_at=now() WHERE ws.warehouse_id=w_id AND ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Dəmir tablo qız')) LIMIT 1);
  END IF;

  -- Divar örtüyü 50x50 D171
  IF NOT EXISTS (SELECT 1 FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Divar örtüyü 50x50 D171')) LIMIT 1) AND ws.warehouse_id=w_id) THEN
    INSERT INTO public.warehouse_stock(warehouse_id,product_id,stock,updated_at) SELECT w_id,p.id,59,now() FROM public.products p WHERE lower(trim(p.name))=lower(trim('Divar örtüyü 50x50 D171')) LIMIT 1;
  ELSIF (SELECT COALESCE(SUM(ws.stock),0) FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Divar örtüyü 50x50 D171')) LIMIT 1))=0 THEN
    UPDATE public.warehouse_stock ws SET stock=59,updated_at=now() WHERE ws.warehouse_id=w_id AND ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Divar örtüyü 50x50 D171')) LIMIT 1);
  END IF;

  -- Divar örtüyü 50x50 D195
  IF NOT EXISTS (SELECT 1 FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Divar örtüyü 50x50 D195')) LIMIT 1) AND ws.warehouse_id=w_id) THEN
    INSERT INTO public.warehouse_stock(warehouse_id,product_id,stock,updated_at) SELECT w_id,p.id,38,now() FROM public.products p WHERE lower(trim(p.name))=lower(trim('Divar örtüyü 50x50 D195')) LIMIT 1;
  ELSIF (SELECT COALESCE(SUM(ws.stock),0) FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Divar örtüyü 50x50 D195')) LIMIT 1))=0 THEN
    UPDATE public.warehouse_stock ws SET stock=38,updated_at=now() WHERE ws.warehouse_id=w_id AND ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Divar örtüyü 50x50 D195')) LIMIT 1);
  END IF;

  -- Divar örtüyü 50x50 D207
  IF NOT EXISTS (SELECT 1 FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Divar örtüyü 50x50 D207')) LIMIT 1) AND ws.warehouse_id=w_id) THEN
    INSERT INTO public.warehouse_stock(warehouse_id,product_id,stock,updated_at) SELECT w_id,p.id,59,now() FROM public.products p WHERE lower(trim(p.name))=lower(trim('Divar örtüyü 50x50 D207')) LIMIT 1;
  ELSIF (SELECT COALESCE(SUM(ws.stock),0) FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Divar örtüyü 50x50 D207')) LIMIT 1))=0 THEN
    UPDATE public.warehouse_stock ws SET stock=59,updated_at=now() WHERE ws.warehouse_id=w_id AND ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Divar örtüyü 50x50 D207')) LIMIT 1);
  END IF;

  -- Divar örtüyü 50x50 TD088
  IF NOT EXISTS (SELECT 1 FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Divar örtüyü 50x50 TD088')) LIMIT 1) AND ws.warehouse_id=w_id) THEN
    INSERT INTO public.warehouse_stock(warehouse_id,product_id,stock,updated_at) SELECT w_id,p.id,59,now() FROM public.products p WHERE lower(trim(p.name))=lower(trim('Divar örtüyü 50x50 TD088')) LIMIT 1;
  ELSIF (SELECT COALESCE(SUM(ws.stock),0) FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Divar örtüyü 50x50 TD088')) LIMIT 1))=0 THEN
    UPDATE public.warehouse_stock ws SET stock=59,updated_at=now() WHERE ws.warehouse_id=w_id AND ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Divar örtüyü 50x50 TD088')) LIMIT 1);
  END IF;

  -- Divar örtüyü 50x50x TD089
  IF NOT EXISTS (SELECT 1 FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Divar örtüyü 50x50x TD089')) LIMIT 1) AND ws.warehouse_id=w_id) THEN
    INSERT INTO public.warehouse_stock(warehouse_id,product_id,stock,updated_at) SELECT w_id,p.id,59,now() FROM public.products p WHERE lower(trim(p.name))=lower(trim('Divar örtüyü 50x50x TD089')) LIMIT 1;
  ELSIF (SELECT COALESCE(SUM(ws.stock),0) FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Divar örtüyü 50x50x TD089')) LIMIT 1))=0 THEN
    UPDATE public.warehouse_stock ws SET stock=59,updated_at=now() WHERE ws.warehouse_id=w_id AND ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Divar örtüyü 50x50x TD089')) LIMIT 1);
  END IF;

  -- Divar örtüyü Kvadrat 50x50
  IF NOT EXISTS (SELECT 1 FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Divar örtüyü Kvadrat 50x50')) LIMIT 1) AND ws.warehouse_id=w_id) THEN
    INSERT INTO public.warehouse_stock(warehouse_id,product_id,stock,updated_at) SELECT w_id,p.id,92,now() FROM public.products p WHERE lower(trim(p.name))=lower(trim('Divar örtüyü Kvadrat 50x50')) LIMIT 1;
  ELSIF (SELECT COALESCE(SUM(ws.stock),0) FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Divar örtüyü Kvadrat 50x50')) LIMIT 1))=0 THEN
    UPDATE public.warehouse_stock ws SET stock=92,updated_at=now() WHERE ws.warehouse_id=w_id AND ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Divar örtüyü Kvadrat 50x50')) LIMIT 1);
  END IF;

  -- Divar örtüyü Panel güzgü
  IF NOT EXISTS (SELECT 1 FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Divar örtüyü Panel güzgü')) LIMIT 1) AND ws.warehouse_id=w_id) THEN
    INSERT INTO public.warehouse_stock(warehouse_id,product_id,stock,updated_at) SELECT w_id,p.id,349,now() FROM public.products p WHERE lower(trim(p.name))=lower(trim('Divar örtüyü Panel güzgü')) LIMIT 1;
  ELSIF (SELECT COALESCE(SUM(ws.stock),0) FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Divar örtüyü Panel güzgü')) LIMIT 1))=0 THEN
    UPDATE public.warehouse_stock ws SET stock=349,updated_at=now() WHERE ws.warehouse_id=w_id AND ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Divar örtüyü Panel güzgü')) LIMIT 1);
  END IF;

  -- Divar üzlüyü 120x60
  IF NOT EXISTS (SELECT 1 FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Divar üzlüyü 120x60')) LIMIT 1) AND ws.warehouse_id=w_id) THEN
    INSERT INTO public.warehouse_stock(warehouse_id,product_id,stock,updated_at) SELECT w_id,p.id,31,now() FROM public.products p WHERE lower(trim(p.name))=lower(trim('Divar üzlüyü 120x60')) LIMIT 1;
  ELSIF (SELECT COALESCE(SUM(ws.stock),0) FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Divar üzlüyü 120x60')) LIMIT 1))=0 THEN
    UPDATE public.warehouse_stock ws SET stock=31,updated_at=now() WHERE ws.warehouse_id=w_id AND ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Divar üzlüyü 120x60')) LIMIT 1);
  END IF;

  -- Fasad Daraq 3m
  IF NOT EXISTS (SELECT 1 FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Fasad Daraq 3m')) LIMIT 1) AND ws.warehouse_id=w_id) THEN
    INSERT INTO public.warehouse_stock(warehouse_id,product_id,stock,updated_at) SELECT w_id,p.id,2,now() FROM public.products p WHERE lower(trim(p.name))=lower(trim('Fasad Daraq 3m')) LIMIT 1;
  ELSIF (SELECT COALESCE(SUM(ws.stock),0) FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Fasad Daraq 3m')) LIMIT 1))=0 THEN
    UPDATE public.warehouse_stock ws SET stock=2,updated_at=now() WHERE ws.warehouse_id=w_id AND ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Fasad Daraq 3m')) LIMIT 1);
  END IF;

  -- Gümüşü 0,4 sm
  IF NOT EXISTS (SELECT 1 FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Gümüşü 0,4 sm')) LIMIT 1) AND ws.warehouse_id=w_id) THEN
    INSERT INTO public.warehouse_stock(warehouse_id,product_id,stock,updated_at) SELECT w_id,p.id,40,now() FROM public.products p WHERE lower(trim(p.name))=lower(trim('Gümüşü 0,4 sm')) LIMIT 1;
  ELSIF (SELECT COALESCE(SUM(ws.stock),0) FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Gümüşü 0,4 sm')) LIMIT 1))=0 THEN
    UPDATE public.warehouse_stock ws SET stock=40,updated_at=now() WHERE ws.warehouse_id=w_id AND ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Gümüşü 0,4 sm')) LIMIT 1);
  END IF;

  -- Gümüşü 1,8 sm
  IF NOT EXISTS (SELECT 1 FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Gümüşü 1,8 sm')) LIMIT 1) AND ws.warehouse_id=w_id) THEN
    INSERT INTO public.warehouse_stock(warehouse_id,product_id,stock,updated_at) SELECT w_id,p.id,65,now() FROM public.products p WHERE lower(trim(p.name))=lower(trim('Gümüşü 1,8 sm')) LIMIT 1;
  ELSIF (SELECT COALESCE(SUM(ws.stock),0) FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Gümüşü 1,8 sm')) LIMIT 1))=0 THEN
    UPDATE public.warehouse_stock ws SET stock=65,updated_at=now() WHERE ws.warehouse_id=w_id AND ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Gümüşü 1,8 sm')) LIMIT 1);
  END IF;

  -- Gümüşü 5 sm
  IF NOT EXISTS (SELECT 1 FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Gümüşü 5 sm')) LIMIT 1) AND ws.warehouse_id=w_id) THEN
    INSERT INTO public.warehouse_stock(warehouse_id,product_id,stock,updated_at) SELECT w_id,p.id,30,now() FROM public.products p WHERE lower(trim(p.name))=lower(trim('Gümüşü 5 sm')) LIMIT 1;
  ELSIF (SELECT COALESCE(SUM(ws.stock),0) FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Gümüşü 5 sm')) LIMIT 1))=0 THEN
    UPDATE public.warehouse_stock ws SET stock=30,updated_at=now() WHERE ws.warehouse_id=w_id AND ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Gümüşü 5 sm')) LIMIT 1);
  END IF;

  -- Kamin 100 sm
  IF NOT EXISTS (SELECT 1 FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Kamin 100 sm')) LIMIT 1) AND ws.warehouse_id=w_id) THEN
    INSERT INTO public.warehouse_stock(warehouse_id,product_id,stock,updated_at) SELECT w_id,p.id,2,now() FROM public.products p WHERE lower(trim(p.name))=lower(trim('Kamin 100 sm')) LIMIT 1;
  ELSIF (SELECT COALESCE(SUM(ws.stock),0) FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Kamin 100 sm')) LIMIT 1))=0 THEN
    UPDATE public.warehouse_stock ws SET stock=2,updated_at=now() WHERE ws.warehouse_id=w_id AND ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Kamin 100 sm')) LIMIT 1);
  END IF;

  -- Kamin 120 sm
  IF NOT EXISTS (SELECT 1 FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Kamin 120 sm')) LIMIT 1) AND ws.warehouse_id=w_id) THEN
    INSERT INTO public.warehouse_stock(warehouse_id,product_id,stock,updated_at) SELECT w_id,p.id,2,now() FROM public.products p WHERE lower(trim(p.name))=lower(trim('Kamin 120 sm')) LIMIT 1;
  ELSIF (SELECT COALESCE(SUM(ws.stock),0) FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Kamin 120 sm')) LIMIT 1))=0 THEN
    UPDATE public.warehouse_stock ws SET stock=2,updated_at=now() WHERE ws.warehouse_id=w_id AND ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Kamin 120 sm')) LIMIT 1);
  END IF;

  -- Kamin 160 sm
  IF NOT EXISTS (SELECT 1 FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Kamin 160 sm')) LIMIT 1) AND ws.warehouse_id=w_id) THEN
    INSERT INTO public.warehouse_stock(warehouse_id,product_id,stock,updated_at) SELECT w_id,p.id,3,now() FROM public.products p WHERE lower(trim(p.name))=lower(trim('Kamin 160 sm')) LIMIT 1;
  ELSIF (SELECT COALESCE(SUM(ws.stock),0) FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Kamin 160 sm')) LIMIT 1))=0 THEN
    UPDATE public.warehouse_stock ws SET stock=3,updated_at=now() WHERE ws.warehouse_id=w_id AND ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Kamin 160 sm')) LIMIT 1);
  END IF;

  -- Kamin 70 sm lux
  IF NOT EXISTS (SELECT 1 FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Kamin 70 sm lux')) LIMIT 1) AND ws.warehouse_id=w_id) THEN
    INSERT INTO public.warehouse_stock(warehouse_id,product_id,stock,updated_at) SELECT w_id,p.id,1,now() FROM public.products p WHERE lower(trim(p.name))=lower(trim('Kamin 70 sm lux')) LIMIT 1;
  ELSIF (SELECT COALESCE(SUM(ws.stock),0) FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Kamin 70 sm lux')) LIMIT 1))=0 THEN
    UPDATE public.warehouse_stock ws SET stock=1,updated_at=now() WHERE ws.warehouse_id=w_id AND ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Kamin 70 sm lux')) LIMIT 1);
  END IF;

  -- Kamin 80 sm
  IF NOT EXISTS (SELECT 1 FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Kamin 80 sm')) LIMIT 1) AND ws.warehouse_id=w_id) THEN
    INSERT INTO public.warehouse_stock(warehouse_id,product_id,stock,updated_at) SELECT w_id,p.id,2,now() FROM public.products p WHERE lower(trim(p.name))=lower(trim('Kamin 80 sm')) LIMIT 1;
  ELSIF (SELECT COALESCE(SUM(ws.stock),0) FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Kamin 80 sm')) LIMIT 1))=0 THEN
    UPDATE public.warehouse_stock ws SET stock=2,updated_at=now() WHERE ws.warehouse_id=w_id AND ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Kamin 80 sm')) LIMIT 1);
  END IF;

  -- Kamin 100*50
  IF NOT EXISTS (SELECT 1 FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Kamin 100*50')) LIMIT 1) AND ws.warehouse_id=w_id) THEN
    INSERT INTO public.warehouse_stock(warehouse_id,product_id,stock,updated_at) SELECT w_id,p.id,1,now() FROM public.products p WHERE lower(trim(p.name))=lower(trim('Kamin 100*50')) LIMIT 1;
  ELSIF (SELECT COALESCE(SUM(ws.stock),0) FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Kamin 100*50')) LIMIT 1))=0 THEN
    UPDATE public.warehouse_stock ws SET stock=1,updated_at=now() WHERE ws.warehouse_id=w_id AND ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Kamin 100*50')) LIMIT 1);
  END IF;

  -- Mdf 2.8 Porselen
  IF NOT EXISTS (SELECT 1 FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Mdf 2.8 Porselen')) LIMIT 1) AND ws.warehouse_id=w_id) THEN
    INSERT INTO public.warehouse_stock(warehouse_id,product_id,stock,updated_at) SELECT w_id,p.id,8,now() FROM public.products p WHERE lower(trim(p.name))=lower(trim('Mdf 2.8 Porselen')) LIMIT 1;
  ELSIF (SELECT COALESCE(SUM(ws.stock),0) FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Mdf 2.8 Porselen')) LIMIT 1))=0 THEN
    UPDATE public.warehouse_stock ws SET stock=8,updated_at=now() WHERE ws.warehouse_id=w_id AND ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Mdf 2.8 Porselen')) LIMIT 1);
  END IF;

  -- Mdf Ada yaşııl 12 sm
  IF NOT EXISTS (SELECT 1 FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Mdf Ada yaşııl 12 sm')) LIMIT 1) AND ws.warehouse_id=w_id) THEN
    INSERT INTO public.warehouse_stock(warehouse_id,product_id,stock,updated_at) SELECT w_id,p.id,18,now() FROM public.products p WHERE lower(trim(p.name))=lower(trim('Mdf Ada yaşııl 12 sm')) LIMIT 1;
  ELSIF (SELECT COALESCE(SUM(ws.stock),0) FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Mdf Ada yaşııl 12 sm')) LIMIT 1))=0 THEN
    UPDATE public.warehouse_stock ws SET stock=18,updated_at=now() WHERE ws.warehouse_id=w_id AND ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Mdf Ada yaşııl 12 sm')) LIMIT 1);
  END IF;

  -- Mdf Anadolu ceviz 2.8 sm
  IF NOT EXISTS (SELECT 1 FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Mdf Anadolu ceviz 2.8 sm')) LIMIT 1) AND ws.warehouse_id=w_id) THEN
    INSERT INTO public.warehouse_stock(warehouse_id,product_id,stock,updated_at) SELECT w_id,p.id,6,now() FROM public.products p WHERE lower(trim(p.name))=lower(trim('Mdf Anadolu ceviz 2.8 sm')) LIMIT 1;
  ELSIF (SELECT COALESCE(SUM(ws.stock),0) FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Mdf Anadolu ceviz 2.8 sm')) LIMIT 1))=0 THEN
    UPDATE public.warehouse_stock ws SET stock=6,updated_at=now() WHERE ws.warehouse_id=w_id AND ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Mdf Anadolu ceviz 2.8 sm')) LIMIT 1);
  END IF;

  -- Mdf Antik ceviz 2.8 sm
  IF NOT EXISTS (SELECT 1 FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Mdf Antik ceviz 2.8 sm')) LIMIT 1) AND ws.warehouse_id=w_id) THEN
    INSERT INTO public.warehouse_stock(warehouse_id,product_id,stock,updated_at) SELECT w_id,p.id,17,now() FROM public.products p WHERE lower(trim(p.name))=lower(trim('Mdf Antik ceviz 2.8 sm')) LIMIT 1;
  ELSIF (SELECT COALESCE(SUM(ws.stock),0) FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Mdf Antik ceviz 2.8 sm')) LIMIT 1))=0 THEN
    UPDATE public.warehouse_stock ws SET stock=17,updated_at=now() WHERE ws.warehouse_id=w_id AND ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Mdf Antik ceviz 2.8 sm')) LIMIT 1);
  END IF;

  -- Mdf Antrasit 2.8
  IF NOT EXISTS (SELECT 1 FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Mdf Antrasit 2.8')) LIMIT 1) AND ws.warehouse_id=w_id) THEN
    INSERT INTO public.warehouse_stock(warehouse_id,product_id,stock,updated_at) SELECT w_id,p.id,6,now() FROM public.products p WHERE lower(trim(p.name))=lower(trim('Mdf Antrasit 2.8')) LIMIT 1;
  ELSIF (SELECT COALESCE(SUM(ws.stock),0) FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Mdf Antrasit 2.8')) LIMIT 1))=0 THEN
    UPDATE public.warehouse_stock ws SET stock=6,updated_at=now() WHERE ws.warehouse_id=w_id AND ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Mdf Antrasit 2.8')) LIMIT 1);
  END IF;

  -- Mdf Boyanabilən 2.8 sm
  IF NOT EXISTS (SELECT 1 FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Mdf Boyanabilən 2.8 sm')) LIMIT 1) AND ws.warehouse_id=w_id) THEN
    INSERT INTO public.warehouse_stock(warehouse_id,product_id,stock,updated_at) SELECT w_id,p.id,6,now() FROM public.products p WHERE lower(trim(p.name))=lower(trim('Mdf Boyanabilən 2.8 sm')) LIMIT 1;
  ELSIF (SELECT COALESCE(SUM(ws.stock),0) FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Mdf Boyanabilən 2.8 sm')) LIMIT 1))=0 THEN
    UPDATE public.warehouse_stock ws SET stock=6,updated_at=now() WHERE ws.warehouse_id=w_id AND ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Mdf Boyanabilən 2.8 sm')) LIMIT 1);
  END IF;

  -- Mdf Doğal teak 2.8 sm
  IF NOT EXISTS (SELECT 1 FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Mdf Doğal teak 2.8 sm')) LIMIT 1) AND ws.warehouse_id=w_id) THEN
    INSERT INTO public.warehouse_stock(warehouse_id,product_id,stock,updated_at) SELECT w_id,p.id,6,now() FROM public.products p WHERE lower(trim(p.name))=lower(trim('Mdf Doğal teak 2.8 sm')) LIMIT 1;
  ELSIF (SELECT COALESCE(SUM(ws.stock),0) FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Mdf Doğal teak 2.8 sm')) LIMIT 1))=0 THEN
    UPDATE public.warehouse_stock ws SET stock=6,updated_at=now() WHERE ws.warehouse_id=w_id AND ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Mdf Doğal teak 2.8 sm')) LIMIT 1);
  END IF;

  -- Mdf Izlanda mavisi 12 sm
  IF NOT EXISTS (SELECT 1 FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Mdf Izlanda mavisi 12 sm')) LIMIT 1) AND ws.warehouse_id=w_id) THEN
    INSERT INTO public.warehouse_stock(warehouse_id,product_id,stock,updated_at) SELECT w_id,p.id,18,now() FROM public.products p WHERE lower(trim(p.name))=lower(trim('Mdf Izlanda mavisi 12 sm')) LIMIT 1;
  ELSIF (SELECT COALESCE(SUM(ws.stock),0) FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Mdf Izlanda mavisi 12 sm')) LIMIT 1))=0 THEN
    UPDATE public.warehouse_stock ws SET stock=18,updated_at=now() WHERE ws.warehouse_id=w_id AND ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Mdf Izlanda mavisi 12 sm')) LIMIT 1);
  END IF;

  -- Mdf Kiremit 12 sm
  IF NOT EXISTS (SELECT 1 FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Mdf Kiremit 12 sm')) LIMIT 1) AND ws.warehouse_id=w_id) THEN
    INSERT INTO public.warehouse_stock(warehouse_id,product_id,stock,updated_at) SELECT w_id,p.id,18,now() FROM public.products p WHERE lower(trim(p.name))=lower(trim('Mdf Kiremit 12 sm')) LIMIT 1;
  ELSIF (SELECT COALESCE(SUM(ws.stock),0) FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Mdf Kiremit 12 sm')) LIMIT 1))=0 THEN
    UPDATE public.warehouse_stock ws SET stock=18,updated_at=now() WHERE ws.warehouse_id=w_id AND ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Mdf Kiremit 12 sm')) LIMIT 1);
  END IF;

  -- Mdf Su yaşıl 12 sm
  IF NOT EXISTS (SELECT 1 FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Mdf Su yaşıl 12 sm')) LIMIT 1) AND ws.warehouse_id=w_id) THEN
    INSERT INTO public.warehouse_stock(warehouse_id,product_id,stock,updated_at) SELECT w_id,p.id,1,now() FROM public.products p WHERE lower(trim(p.name))=lower(trim('Mdf Su yaşıl 12 sm')) LIMIT 1;
  ELSIF (SELECT COALESCE(SUM(ws.stock),0) FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Mdf Su yaşıl 12 sm')) LIMIT 1))=0 THEN
    UPDATE public.warehouse_stock ws SET stock=1,updated_at=now() WHERE ws.warehouse_id=w_id AND ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Mdf Su yaşıl 12 sm')) LIMIT 1);
  END IF;

  -- Saten Cappucino 2.8 sm
  IF NOT EXISTS (SELECT 1 FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Saten Cappucino 2.8 sm')) LIMIT 1) AND ws.warehouse_id=w_id) THEN
    INSERT INTO public.warehouse_stock(warehouse_id,product_id,stock,updated_at) SELECT w_id,p.id,6,now() FROM public.products p WHERE lower(trim(p.name))=lower(trim('Saten Cappucino 2.8 sm')) LIMIT 1;
  ELSIF (SELECT COALESCE(SUM(ws.stock),0) FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Saten Cappucino 2.8 sm')) LIMIT 1))=0 THEN
    UPDATE public.warehouse_stock ws SET stock=6,updated_at=now() WHERE ws.warehouse_id=w_id AND ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Saten Cappucino 2.8 sm')) LIMIT 1);
  END IF;

  -- Saten Mocca 2.8 sm
  IF NOT EXISTS (SELECT 1 FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Saten Mocca 2.8 sm')) LIMIT 1) AND ws.warehouse_id=w_id) THEN
    INSERT INTO public.warehouse_stock(warehouse_id,product_id,stock,updated_at) SELECT w_id,p.id,6,now() FROM public.products p WHERE lower(trim(p.name))=lower(trim('Saten Mocca 2.8 sm')) LIMIT 1;
  ELSIF (SELECT COALESCE(SUM(ws.stock),0) FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Saten Mocca 2.8 sm')) LIMIT 1))=0 THEN
    UPDATE public.warehouse_stock ws SET stock=6,updated_at=now() WHERE ws.warehouse_id=w_id AND ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Saten Mocca 2.8 sm')) LIMIT 1);
  END IF;

  -- Sədəf Ağ 2.8 sm
  IF NOT EXISTS (SELECT 1 FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Sədəf Ağ 2.8 sm')) LIMIT 1) AND ws.warehouse_id=w_id) THEN
    INSERT INTO public.warehouse_stock(warehouse_id,product_id,stock,updated_at) SELECT w_id,p.id,6,now() FROM public.products p WHERE lower(trim(p.name))=lower(trim('Sədəf Ağ 2.8 sm')) LIMIT 1;
  ELSIF (SELECT COALESCE(SUM(ws.stock),0) FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Sədəf Ağ 2.8 sm')) LIMIT 1))=0 THEN
    UPDATE public.warehouse_stock ws SET stock=6,updated_at=now() WHERE ws.warehouse_id=w_id AND ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Sədəf Ağ 2.8 sm')) LIMIT 1);
  END IF;

  -- Arxası yapışqanlı panel 280*120
  IF NOT EXISTS (SELECT 1 FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Arxası yapışqanlı panel 280*120')) LIMIT 1) AND ws.warehouse_id=w_id) THEN
    INSERT INTO public.warehouse_stock(warehouse_id,product_id,stock,updated_at) SELECT w_id,p.id,54,now() FROM public.products p WHERE lower(trim(p.name))=lower(trim('Arxası yapışqanlı panel 280*120')) LIMIT 1;
  ELSIF (SELECT COALESCE(SUM(ws.stock),0) FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Arxası yapışqanlı panel 280*120')) LIMIT 1))=0 THEN
    UPDATE public.warehouse_stock ws SET stock=54,updated_at=now() WHERE ws.warehouse_id=w_id AND ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Arxası yapışqanlı panel 280*120')) LIMIT 1);
  END IF;

  -- Arxası yapışqanlı panel Qırmızı 0.7×2.8
  IF NOT EXISTS (SELECT 1 FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Arxası yapışqanlı panel Qırmızı 0.7×2.8')) LIMIT 1) AND ws.warehouse_id=w_id) THEN
    INSERT INTO public.warehouse_stock(warehouse_id,product_id,stock,updated_at) SELECT w_id,p.id,11,now() FROM public.products p WHERE lower(trim(p.name))=lower(trim('Arxası yapışqanlı panel Qırmızı 0.7×2.8')) LIMIT 1;
  ELSIF (SELECT COALESCE(SUM(ws.stock),0) FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Arxası yapışqanlı panel Qırmızı 0.7×2.8')) LIMIT 1))=0 THEN
    UPDATE public.warehouse_stock ws SET stock=11,updated_at=now() WHERE ws.warehouse_id=w_id AND ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Arxası yapışqanlı panel Qırmızı 0.7×2.8')) LIMIT 1);
  END IF;

  -- Arxası yapışqanlı panel Qəhvəyi 0.7×2.8
  IF NOT EXISTS (SELECT 1 FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Arxası yapışqanlı panel Qəhvəyi 0.7×2.8')) LIMIT 1) AND ws.warehouse_id=w_id) THEN
    INSERT INTO public.warehouse_stock(warehouse_id,product_id,stock,updated_at) SELECT w_id,p.id,0,now() FROM public.products p WHERE lower(trim(p.name))=lower(trim('Arxası yapışqanlı panel Qəhvəyi 0.7×2.8')) LIMIT 1;
  ELSIF (SELECT COALESCE(SUM(ws.stock),0) FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Arxası yapışqanlı panel Qəhvəyi 0.7×2.8')) LIMIT 1))=0 THEN
    UPDATE public.warehouse_stock ws SET stock=0,updated_at=now() WHERE ws.warehouse_id=w_id AND ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Arxası yapışqanlı panel Qəhvəyi 0.7×2.8')) LIMIT 1);
  END IF;

  -- Arxası yapışqanlı panel Yaşıl 0.7×2.8
  IF NOT EXISTS (SELECT 1 FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Arxası yapışqanlı panel Yaşıl 0.7×2.8')) LIMIT 1) AND ws.warehouse_id=w_id) THEN
    INSERT INTO public.warehouse_stock(warehouse_id,product_id,stock,updated_at) SELECT w_id,p.id,6,now() FROM public.products p WHERE lower(trim(p.name))=lower(trim('Arxası yapışqanlı panel Yaşıl 0.7×2.8')) LIMIT 1;
  ELSIF (SELECT COALESCE(SUM(ws.stock),0) FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Arxası yapışqanlı panel Yaşıl 0.7×2.8')) LIMIT 1))=0 THEN
    UPDATE public.warehouse_stock ws SET stock=6,updated_at=now() WHERE ws.warehouse_id=w_id AND ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Arxası yapışqanlı panel Yaşıl 0.7×2.8')) LIMIT 1);
  END IF;

  -- YSA - 01 LUX
  IF NOT EXISTS (SELECT 1 FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('YSA - 01 LUX')) LIMIT 1) AND ws.warehouse_id=w_id) THEN
    INSERT INTO public.warehouse_stock(warehouse_id,product_id,stock,updated_at) SELECT w_id,p.id,1,now() FROM public.products p WHERE lower(trim(p.name))=lower(trim('YSA - 01 LUX')) LIMIT 1;
  ELSIF (SELECT COALESCE(SUM(ws.stock),0) FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('YSA - 01 LUX')) LIMIT 1))=0 THEN
    UPDATE public.warehouse_stock ws SET stock=1,updated_at=now() WHERE ws.warehouse_id=w_id AND ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('YSA - 01 LUX')) LIMIT 1);
  END IF;

  -- YSB - 03 LUX
  IF NOT EXISTS (SELECT 1 FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('YSB - 03 LUX')) LIMIT 1) AND ws.warehouse_id=w_id) THEN
    INSERT INTO public.warehouse_stock(warehouse_id,product_id,stock,updated_at) SELECT w_id,p.id,1,now() FROM public.products p WHERE lower(trim(p.name))=lower(trim('YSB - 03 LUX')) LIMIT 1;
  ELSIF (SELECT COALESCE(SUM(ws.stock),0) FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('YSB - 03 LUX')) LIMIT 1))=0 THEN
    UPDATE public.warehouse_stock ws SET stock=1,updated_at=now() WHERE ws.warehouse_id=w_id AND ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('YSB - 03 LUX')) LIMIT 1);
  END IF;

  -- QS -02 LUX
  IF NOT EXISTS (SELECT 1 FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('QS -02 LUX')) LIMIT 1) AND ws.warehouse_id=w_id) THEN
    INSERT INTO public.warehouse_stock(warehouse_id,product_id,stock,updated_at) SELECT w_id,p.id,1,now() FROM public.products p WHERE lower(trim(p.name))=lower(trim('QS -02 LUX')) LIMIT 1;
  ELSIF (SELECT COALESCE(SUM(ws.stock),0) FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('QS -02 LUX')) LIMIT 1))=0 THEN
    UPDATE public.warehouse_stock ws SET stock=1,updated_at=now() WHERE ws.warehouse_id=w_id AND ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('QS -02 LUX')) LIMIT 1);
  END IF;

  -- ASB -04 LUX
  IF NOT EXISTS (SELECT 1 FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('ASB -04 LUX')) LIMIT 1) AND ws.warehouse_id=w_id) THEN
    INSERT INTO public.warehouse_stock(warehouse_id,product_id,stock,updated_at) SELECT w_id,p.id,5,now() FROM public.products p WHERE lower(trim(p.name))=lower(trim('ASB -04 LUX')) LIMIT 1;
  ELSIF (SELECT COALESCE(SUM(ws.stock),0) FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('ASB -04 LUX')) LIMIT 1))=0 THEN
    UPDATE public.warehouse_stock ws SET stock=5,updated_at=now() WHERE ws.warehouse_id=w_id AND ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('ASB -04 LUX')) LIMIT 1);
  END IF;

  -- W-01
  IF NOT EXISTS (SELECT 1 FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('W-01')) LIMIT 1) AND ws.warehouse_id=w_id) THEN
    INSERT INTO public.warehouse_stock(warehouse_id,product_id,stock,updated_at) SELECT w_id,p.id,4,now() FROM public.products p WHERE lower(trim(p.name))=lower(trim('W-01')) LIMIT 1;
  ELSIF (SELECT COALESCE(SUM(ws.stock),0) FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('W-01')) LIMIT 1))=0 THEN
    UPDATE public.warehouse_stock ws SET stock=4,updated_at=now() WHERE ws.warehouse_id=w_id AND ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('W-01')) LIMIT 1);
  END IF;

  -- Goy
  IF NOT EXISTS (SELECT 1 FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Goy')) LIMIT 1) AND ws.warehouse_id=w_id) THEN
    INSERT INTO public.warehouse_stock(warehouse_id,product_id,stock,updated_at) SELECT w_id,p.id,3,now() FROM public.products p WHERE lower(trim(p.name))=lower(trim('Goy')) LIMIT 1;
  ELSIF (SELECT COALESCE(SUM(ws.stock),0) FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Goy')) LIMIT 1))=0 THEN
    UPDATE public.warehouse_stock ws SET stock=3,updated_at=now() WHERE ws.warehouse_id=w_id AND ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Goy')) LIMIT 1);
  END IF;

  -- Boz
  IF NOT EXISTS (SELECT 1 FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Boz')) LIMIT 1) AND ws.warehouse_id=w_id) THEN
    INSERT INTO public.warehouse_stock(warehouse_id,product_id,stock,updated_at) SELECT w_id,p.id,1,now() FROM public.products p WHERE lower(trim(p.name))=lower(trim('Boz')) LIMIT 1;
  ELSIF (SELECT COALESCE(SUM(ws.stock),0) FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Boz')) LIMIT 1))=0 THEN
    UPDATE public.warehouse_stock ws SET stock=1,updated_at=now() WHERE ws.warehouse_id=w_id AND ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Boz')) LIMIT 1);
  END IF;

  -- DG -B113
  IF NOT EXISTS (SELECT 1 FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('DG -B113')) LIMIT 1) AND ws.warehouse_id=w_id) THEN
    INSERT INTO public.warehouse_stock(warehouse_id,product_id,stock,updated_at) SELECT w_id,p.id,88,now() FROM public.products p WHERE lower(trim(p.name))=lower(trim('DG -B113')) LIMIT 1;
  ELSIF (SELECT COALESCE(SUM(ws.stock),0) FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('DG -B113')) LIMIT 1))=0 THEN
    UPDATE public.warehouse_stock ws SET stock=88,updated_at=now() WHERE ws.warehouse_id=w_id AND ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('DG -B113')) LIMIT 1);
  END IF;

  -- DG-B111
  IF NOT EXISTS (SELECT 1 FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('DG-B111')) LIMIT 1) AND ws.warehouse_id=w_id) THEN
    INSERT INTO public.warehouse_stock(warehouse_id,product_id,stock,updated_at) SELECT w_id,p.id,150,now() FROM public.products p WHERE lower(trim(p.name))=lower(trim('DG-B111')) LIMIT 1;
  ELSIF (SELECT COALESCE(SUM(ws.stock),0) FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('DG-B111')) LIMIT 1))=0 THEN
    UPDATE public.warehouse_stock ws SET stock=150,updated_at=now() WHERE ws.warehouse_id=w_id AND ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('DG-B111')) LIMIT 1);
  END IF;

  -- DG-B112-Shah
  IF NOT EXISTS (SELECT 1 FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('DG-B112-Shah')) LIMIT 1) AND ws.warehouse_id=w_id) THEN
    INSERT INTO public.warehouse_stock(warehouse_id,product_id,stock,updated_at) SELECT w_id,p.id,190,now() FROM public.products p WHERE lower(trim(p.name))=lower(trim('DG-B112-Shah')) LIMIT 1;
  ELSIF (SELECT COALESCE(SUM(ws.stock),0) FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('DG-B112-Shah')) LIMIT 1))=0 THEN
    UPDATE public.warehouse_stock ws SET stock=190,updated_at=now() WHERE ws.warehouse_id=w_id AND ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('DG-B112-Shah')) LIMIT 1);
  END IF;

  -- DG-B116
  IF NOT EXISTS (SELECT 1 FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('DG-B116')) LIMIT 1) AND ws.warehouse_id=w_id) THEN
    INSERT INTO public.warehouse_stock(warehouse_id,product_id,stock,updated_at) SELECT w_id,p.id,127,now() FROM public.products p WHERE lower(trim(p.name))=lower(trim('DG-B116')) LIMIT 1;
  ELSIF (SELECT COALESCE(SUM(ws.stock),0) FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('DG-B116')) LIMIT 1))=0 THEN
    UPDATE public.warehouse_stock ws SET stock=127,updated_at=now() WHERE ws.warehouse_id=w_id AND ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('DG-B116')) LIMIT 1);
  END IF;

  -- Pətək güzgü qızılı 60x70
  IF NOT EXISTS (SELECT 1 FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Pətək güzgü qızılı 60x70')) LIMIT 1) AND ws.warehouse_id=w_id) THEN
    INSERT INTO public.warehouse_stock(warehouse_id,product_id,stock,updated_at) SELECT w_id,p.id,2,now() FROM public.products p WHERE lower(trim(p.name))=lower(trim('Pətək güzgü qızılı 60x70')) LIMIT 1;
  ELSIF (SELECT COALESCE(SUM(ws.stock),0) FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Pətək güzgü qızılı 60x70')) LIMIT 1))=0 THEN
    UPDATE public.warehouse_stock ws SET stock=2,updated_at=now() WHERE ws.warehouse_id=w_id AND ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Pətək güzgü qızılı 60x70')) LIMIT 1);
  END IF;

  -- Pətək güzgü gümüsü 60x70
  IF NOT EXISTS (SELECT 1 FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Pətək güzgü gümüsü 60x70')) LIMIT 1) AND ws.warehouse_id=w_id) THEN
    INSERT INTO public.warehouse_stock(warehouse_id,product_id,stock,updated_at) SELECT w_id,p.id,3,now() FROM public.products p WHERE lower(trim(p.name))=lower(trim('Pətək güzgü gümüsü 60x70')) LIMIT 1;
  ELSIF (SELECT COALESCE(SUM(ws.stock),0) FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Pətək güzgü gümüsü 60x70')) LIMIT 1))=0 THEN
    UPDATE public.warehouse_stock ws SET stock=3,updated_at=now() WHERE ws.warehouse_id=w_id AND ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Pətək güzgü gümüsü 60x70')) LIMIT 1);
  END IF;

  -- Pətək 60x70
  IF NOT EXISTS (SELECT 1 FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Pətək 60x70')) LIMIT 1) AND ws.warehouse_id=w_id) THEN
    INSERT INTO public.warehouse_stock(warehouse_id,product_id,stock,updated_at) SELECT w_id,p.id,1,now() FROM public.products p WHERE lower(trim(p.name))=lower(trim('Pətək 60x70')) LIMIT 1;
  ELSIF (SELECT COALESCE(SUM(ws.stock),0) FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Pətək 60x70')) LIMIT 1))=0 THEN
    UPDATE public.warehouse_stock ws SET stock=1,updated_at=now() WHERE ws.warehouse_id=w_id AND ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Pətək 60x70')) LIMIT 1);
  END IF;

  -- Pvc 16x3 sm daxili interyer
  IF NOT EXISTS (SELECT 1 FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Pvc 16x3 sm daxili interyer')) LIMIT 1) AND ws.warehouse_id=w_id) THEN
    INSERT INTO public.warehouse_stock(warehouse_id,product_id,stock,updated_at) SELECT w_id,p.id,78,now() FROM public.products p WHERE lower(trim(p.name))=lower(trim('Pvc 16x3 sm daxili interyer')) LIMIT 1;
  ELSIF (SELECT COALESCE(SUM(ws.stock),0) FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Pvc 16x3 sm daxili interyer')) LIMIT 1))=0 THEN
    UPDATE public.warehouse_stock ws SET stock=78,updated_at=now() WHERE ws.warehouse_id=w_id AND ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Pvc 16x3 sm daxili interyer')) LIMIT 1);
  END IF;

  -- Kod 06
  IF NOT EXISTS (SELECT 1 FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Kod 06')) LIMIT 1) AND ws.warehouse_id=w_id) THEN
    INSERT INTO public.warehouse_stock(warehouse_id,product_id,stock,updated_at) SELECT w_id,p.id,8,now() FROM public.products p WHERE lower(trim(p.name))=lower(trim('Kod 06')) LIMIT 1;
  ELSIF (SELECT COALESCE(SUM(ws.stock),0) FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Kod 06')) LIMIT 1))=0 THEN
    UPDATE public.warehouse_stock ws SET stock=8,updated_at=now() WHERE ws.warehouse_id=w_id AND ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Kod 06')) LIMIT 1);
  END IF;

  -- Kod 03
  IF NOT EXISTS (SELECT 1 FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Kod 03')) LIMIT 1) AND ws.warehouse_id=w_id) THEN
    INSERT INTO public.warehouse_stock(warehouse_id,product_id,stock,updated_at) SELECT w_id,p.id,1,now() FROM public.products p WHERE lower(trim(p.name))=lower(trim('Kod 03')) LIMIT 1;
  ELSIF (SELECT COALESCE(SUM(ws.stock),0) FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Kod 03')) LIMIT 1))=0 THEN
    UPDATE public.warehouse_stock ws SET stock=1,updated_at=now() WHERE ws.warehouse_id=w_id AND ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Kod 03')) LIMIT 1);
  END IF;

  -- Kod 09
  IF NOT EXISTS (SELECT 1 FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Kod 09')) LIMIT 1) AND ws.warehouse_id=w_id) THEN
    INSERT INTO public.warehouse_stock(warehouse_id,product_id,stock,updated_at) SELECT w_id,p.id,5,now() FROM public.products p WHERE lower(trim(p.name))=lower(trim('Kod 09')) LIMIT 1;
  ELSIF (SELECT COALESCE(SUM(ws.stock),0) FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Kod 09')) LIMIT 1))=0 THEN
    UPDATE public.warehouse_stock ws SET stock=5,updated_at=now() WHERE ws.warehouse_id=w_id AND ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Kod 09')) LIMIT 1);
  END IF;

  -- Kod 05
  IF NOT EXISTS (SELECT 1 FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Kod 05')) LIMIT 1) AND ws.warehouse_id=w_id) THEN
    INSERT INTO public.warehouse_stock(warehouse_id,product_id,stock,updated_at) SELECT w_id,p.id,3,now() FROM public.products p WHERE lower(trim(p.name))=lower(trim('Kod 05')) LIMIT 1;
  ELSIF (SELECT COALESCE(SUM(ws.stock),0) FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Kod 05')) LIMIT 1))=0 THEN
    UPDATE public.warehouse_stock ws SET stock=3,updated_at=now() WHERE ws.warehouse_id=w_id AND ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Kod 05')) LIMIT 1);
  END IF;

  -- Kod 21
  IF NOT EXISTS (SELECT 1 FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Kod 21')) LIMIT 1) AND ws.warehouse_id=w_id) THEN
    INSERT INTO public.warehouse_stock(warehouse_id,product_id,stock,updated_at) SELECT w_id,p.id,5,now() FROM public.products p WHERE lower(trim(p.name))=lower(trim('Kod 21')) LIMIT 1;
  ELSIF (SELECT COALESCE(SUM(ws.stock),0) FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Kod 21')) LIMIT 1))=0 THEN
    UPDATE public.warehouse_stock ws SET stock=5,updated_at=now() WHERE ws.warehouse_id=w_id AND ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Kod 21')) LIMIT 1);
  END IF;

  -- Kod 13
  IF NOT EXISTS (SELECT 1 FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Kod 13')) LIMIT 1) AND ws.warehouse_id=w_id) THEN
    INSERT INTO public.warehouse_stock(warehouse_id,product_id,stock,updated_at) SELECT w_id,p.id,5,now() FROM public.products p WHERE lower(trim(p.name))=lower(trim('Kod 13')) LIMIT 1;
  ELSIF (SELECT COALESCE(SUM(ws.stock),0) FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Kod 13')) LIMIT 1))=0 THEN
    UPDATE public.warehouse_stock ws SET stock=5,updated_at=now() WHERE ws.warehouse_id=w_id AND ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Kod 13')) LIMIT 1);
  END IF;

  -- Kod 10
  IF NOT EXISTS (SELECT 1 FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Kod 10')) LIMIT 1) AND ws.warehouse_id=w_id) THEN
    INSERT INTO public.warehouse_stock(warehouse_id,product_id,stock,updated_at) SELECT w_id,p.id,5,now() FROM public.products p WHERE lower(trim(p.name))=lower(trim('Kod 10')) LIMIT 1;
  ELSIF (SELECT COALESCE(SUM(ws.stock),0) FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Kod 10')) LIMIT 1))=0 THEN
    UPDATE public.warehouse_stock ws SET stock=5,updated_at=now() WHERE ws.warehouse_id=w_id AND ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Kod 10')) LIMIT 1);
  END IF;

  -- Kod 12
  IF NOT EXISTS (SELECT 1 FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Kod 12')) LIMIT 1) AND ws.warehouse_id=w_id) THEN
    INSERT INTO public.warehouse_stock(warehouse_id,product_id,stock,updated_at) SELECT w_id,p.id,5,now() FROM public.products p WHERE lower(trim(p.name))=lower(trim('Kod 12')) LIMIT 1;
  ELSIF (SELECT COALESCE(SUM(ws.stock),0) FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Kod 12')) LIMIT 1))=0 THEN
    UPDATE public.warehouse_stock ws SET stock=5,updated_at=now() WHERE ws.warehouse_id=w_id AND ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Kod 12')) LIMIT 1);
  END IF;

  -- Kod 17
  IF NOT EXISTS (SELECT 1 FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Kod 17')) LIMIT 1) AND ws.warehouse_id=w_id) THEN
    INSERT INTO public.warehouse_stock(warehouse_id,product_id,stock,updated_at) SELECT w_id,p.id,5,now() FROM public.products p WHERE lower(trim(p.name))=lower(trim('Kod 17')) LIMIT 1;
  ELSIF (SELECT COALESCE(SUM(ws.stock),0) FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Kod 17')) LIMIT 1))=0 THEN
    UPDATE public.warehouse_stock ws SET stock=5,updated_at=now() WHERE ws.warehouse_id=w_id AND ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Kod 17')) LIMIT 1);
  END IF;

  -- Kod 19
  IF NOT EXISTS (SELECT 1 FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Kod 19')) LIMIT 1) AND ws.warehouse_id=w_id) THEN
    INSERT INTO public.warehouse_stock(warehouse_id,product_id,stock,updated_at) SELECT w_id,p.id,5,now() FROM public.products p WHERE lower(trim(p.name))=lower(trim('Kod 19')) LIMIT 1;
  ELSIF (SELECT COALESCE(SUM(ws.stock),0) FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Kod 19')) LIMIT 1))=0 THEN
    UPDATE public.warehouse_stock ws SET stock=5,updated_at=now() WHERE ws.warehouse_id=w_id AND ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Kod 19')) LIMIT 1);
  END IF;

  -- Kod 02
  IF NOT EXISTS (SELECT 1 FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Kod 02')) LIMIT 1) AND ws.warehouse_id=w_id) THEN
    INSERT INTO public.warehouse_stock(warehouse_id,product_id,stock,updated_at) SELECT w_id,p.id,5,now() FROM public.products p WHERE lower(trim(p.name))=lower(trim('Kod 02')) LIMIT 1;
  ELSIF (SELECT COALESCE(SUM(ws.stock),0) FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Kod 02')) LIMIT 1))=0 THEN
    UPDATE public.warehouse_stock ws SET stock=5,updated_at=now() WHERE ws.warehouse_id=w_id AND ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Kod 02')) LIMIT 1);
  END IF;

  -- Kod 01
  IF NOT EXISTS (SELECT 1 FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Kod 01')) LIMIT 1) AND ws.warehouse_id=w_id) THEN
    INSERT INTO public.warehouse_stock(warehouse_id,product_id,stock,updated_at) SELECT w_id,p.id,5,now() FROM public.products p WHERE lower(trim(p.name))=lower(trim('Kod 01')) LIMIT 1;
  ELSIF (SELECT COALESCE(SUM(ws.stock),0) FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Kod 01')) LIMIT 1))=0 THEN
    UPDATE public.warehouse_stock ws SET stock=5,updated_at=now() WHERE ws.warehouse_id=w_id AND ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Kod 01')) LIMIT 1);
  END IF;

  -- Kod 04
  IF NOT EXISTS (SELECT 1 FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Kod 04')) LIMIT 1) AND ws.warehouse_id=w_id) THEN
    INSERT INTO public.warehouse_stock(warehouse_id,product_id,stock,updated_at) SELECT w_id,p.id,5,now() FROM public.products p WHERE lower(trim(p.name))=lower(trim('Kod 04')) LIMIT 1;
  ELSIF (SELECT COALESCE(SUM(ws.stock),0) FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Kod 04')) LIMIT 1))=0 THEN
    UPDATE public.warehouse_stock ws SET stock=5,updated_at=now() WHERE ws.warehouse_id=w_id AND ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Kod 04')) LIMIT 1);
  END IF;

  -- Kod Vitrinler
  IF NOT EXISTS (SELECT 1 FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Kod Vitrinler')) LIMIT 1) AND ws.warehouse_id=w_id) THEN
    INSERT INTO public.warehouse_stock(warehouse_id,product_id,stock,updated_at) SELECT w_id,p.id,16,now() FROM public.products p WHERE lower(trim(p.name))=lower(trim('Kod Vitrinler')) LIMIT 1;
  ELSIF (SELECT COALESCE(SUM(ws.stock),0) FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Kod Vitrinler')) LIMIT 1))=0 THEN
    UPDATE public.warehouse_stock ws SET stock=16,updated_at=now() WHERE ws.warehouse_id=w_id AND ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Kod Vitrinler')) LIMIT 1);
  END IF;

  -- Pvc 12 sm Iran
  IF NOT EXISTS (SELECT 1 FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Pvc 12 sm Iran')) LIMIT 1) AND ws.warehouse_id=w_id) THEN
    INSERT INTO public.warehouse_stock(warehouse_id,product_id,stock,updated_at) SELECT w_id,p.id,0,now() FROM public.products p WHERE lower(trim(p.name))=lower(trim('Pvc 12 sm Iran')) LIMIT 1;
  ELSIF (SELECT COALESCE(SUM(ws.stock),0) FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Pvc 12 sm Iran')) LIMIT 1))=0 THEN
    UPDATE public.warehouse_stock ws SET stock=0,updated_at=now() WHERE ws.warehouse_id=w_id AND ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Pvc 12 sm Iran')) LIMIT 1);
  END IF;

  -- Pvc 20 sm Iran
  IF NOT EXISTS (SELECT 1 FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Pvc 20 sm Iran')) LIMIT 1) AND ws.warehouse_id=w_id) THEN
    INSERT INTO public.warehouse_stock(warehouse_id,product_id,stock,updated_at) SELECT w_id,p.id,1,now() FROM public.products p WHERE lower(trim(p.name))=lower(trim('Pvc 20 sm Iran')) LIMIT 1;
  ELSIF (SELECT COALESCE(SUM(ws.stock),0) FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Pvc 20 sm Iran')) LIMIT 1))=0 THEN
    UPDATE public.warehouse_stock ws SET stock=1,updated_at=now() WHERE ws.warehouse_id=w_id AND ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Pvc 20 sm Iran')) LIMIT 1);
  END IF;

  -- Pvc Local Ağ 1 m
  IF NOT EXISTS (SELECT 1 FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Pvc Local Ağ 1 m')) LIMIT 1) AND ws.warehouse_id=w_id) THEN
    INSERT INTO public.warehouse_stock(warehouse_id,product_id,stock,updated_at) SELECT w_id,p.id,11,now() FROM public.products p WHERE lower(trim(p.name))=lower(trim('Pvc Local Ağ 1 m')) LIMIT 1;
  ELSIF (SELECT COALESCE(SUM(ws.stock),0) FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Pvc Local Ağ 1 m')) LIMIT 1))=0 THEN
    UPDATE public.warehouse_stock ws SET stock=11,updated_at=now() WHERE ws.warehouse_id=w_id AND ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Pvc Local Ağ 1 m')) LIMIT 1);
  END IF;

  -- Qaya 120x60 Ağ
  IF NOT EXISTS (SELECT 1 FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Qaya 120x60 Ağ')) LIMIT 1) AND ws.warehouse_id=w_id) THEN
    INSERT INTO public.warehouse_stock(warehouse_id,product_id,stock,updated_at) SELECT w_id,p.id,3,now() FROM public.products p WHERE lower(trim(p.name))=lower(trim('Qaya 120x60 Ağ')) LIMIT 1;
  ELSIF (SELECT COALESCE(SUM(ws.stock),0) FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Qaya 120x60 Ağ')) LIMIT 1))=0 THEN
    UPDATE public.warehouse_stock ws SET stock=3,updated_at=now() WHERE ws.warehouse_id=w_id AND ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Qaya 120x60 Ağ')) LIMIT 1);
  END IF;

  -- Qaya 290x60
  IF NOT EXISTS (SELECT 1 FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Qaya 290x60')) LIMIT 1) AND ws.warehouse_id=w_id) THEN
    INSERT INTO public.warehouse_stock(warehouse_id,product_id,stock,updated_at) SELECT w_id,p.id,5,now() FROM public.products p WHERE lower(trim(p.name))=lower(trim('Qaya 290x60')) LIMIT 1;
  ELSIF (SELECT COALESCE(SUM(ws.stock),0) FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Qaya 290x60')) LIMIT 1))=0 THEN
    UPDATE public.warehouse_stock ws SET stock=5,updated_at=now() WHERE ws.warehouse_id=w_id AND ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Qaya 290x60')) LIMIT 1);
  END IF;

  -- Qaya 290x60 Ağ
  IF NOT EXISTS (SELECT 1 FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Qaya 290x60 Ağ')) LIMIT 1) AND ws.warehouse_id=w_id) THEN
    INSERT INTO public.warehouse_stock(warehouse_id,product_id,stock,updated_at) SELECT w_id,p.id,8,now() FROM public.products p WHERE lower(trim(p.name))=lower(trim('Qaya 290x60 Ağ')) LIMIT 1;
  ELSIF (SELECT COALESCE(SUM(ws.stock),0) FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Qaya 290x60 Ağ')) LIMIT 1))=0 THEN
    UPDATE public.warehouse_stock ws SET stock=8,updated_at=now() WHERE ws.warehouse_id=w_id AND ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Qaya 290x60 Ağ')) LIMIT 1);
  END IF;

  -- Qaya 3000x1200
  IF NOT EXISTS (SELECT 1 FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Qaya 3000x1200')) LIMIT 1) AND ws.warehouse_id=w_id) THEN
    INSERT INTO public.warehouse_stock(warehouse_id,product_id,stock,updated_at) SELECT w_id,p.id,1,now() FROM public.products p WHERE lower(trim(p.name))=lower(trim('Qaya 3000x1200')) LIMIT 1;
  ELSIF (SELECT COALESCE(SUM(ws.stock),0) FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Qaya 3000x1200')) LIMIT 1))=0 THEN
    UPDATE public.warehouse_stock ws SET stock=1,updated_at=now() WHERE ws.warehouse_id=w_id AND ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Qaya 3000x1200')) LIMIT 1);
  END IF;

  -- Qızılı 0,4 sm
  IF NOT EXISTS (SELECT 1 FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Qızılı 0,4 sm')) LIMIT 1) AND ws.warehouse_id=w_id) THEN
    INSERT INTO public.warehouse_stock(warehouse_id,product_id,stock,updated_at) SELECT w_id,p.id,20,now() FROM public.products p WHERE lower(trim(p.name))=lower(trim('Qızılı 0,4 sm')) LIMIT 1;
  ELSIF (SELECT COALESCE(SUM(ws.stock),0) FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Qızılı 0,4 sm')) LIMIT 1))=0 THEN
    UPDATE public.warehouse_stock ws SET stock=20,updated_at=now() WHERE ws.warehouse_id=w_id AND ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Qızılı 0,4 sm')) LIMIT 1);
  END IF;

  -- Qızılı 1 sm
  IF NOT EXISTS (SELECT 1 FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Qızılı 1 sm')) LIMIT 1) AND ws.warehouse_id=w_id) THEN
    INSERT INTO public.warehouse_stock(warehouse_id,product_id,stock,updated_at) SELECT w_id,p.id,30,now() FROM public.products p WHERE lower(trim(p.name))=lower(trim('Qızılı 1 sm')) LIMIT 1;
  ELSIF (SELECT COALESCE(SUM(ws.stock),0) FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Qızılı 1 sm')) LIMIT 1))=0 THEN
    UPDATE public.warehouse_stock ws SET stock=30,updated_at=now() WHERE ws.warehouse_id=w_id AND ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Qızılı 1 sm')) LIMIT 1);
  END IF;

  -- Qızılı 1.8 sm
  IF NOT EXISTS (SELECT 1 FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Qızılı 1.8 sm')) LIMIT 1) AND ws.warehouse_id=w_id) THEN
    INSERT INTO public.warehouse_stock(warehouse_id,product_id,stock,updated_at) SELECT w_id,p.id,49,now() FROM public.products p WHERE lower(trim(p.name))=lower(trim('Qızılı 1.8 sm')) LIMIT 1;
  ELSIF (SELECT COALESCE(SUM(ws.stock),0) FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Qızılı 1.8 sm')) LIMIT 1))=0 THEN
    UPDATE public.warehouse_stock ws SET stock=49,updated_at=now() WHERE ws.warehouse_id=w_id AND ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Qızılı 1.8 sm')) LIMIT 1);
  END IF;

  -- Süni ot 50x50
  IF NOT EXISTS (SELECT 1 FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Süni ot 50x50')) LIMIT 1) AND ws.warehouse_id=w_id) THEN
    INSERT INTO public.warehouse_stock(warehouse_id,product_id,stock,updated_at) SELECT w_id,p.id,1,now() FROM public.products p WHERE lower(trim(p.name))=lower(trim('Süni ot 50x50')) LIMIT 1;
  ELSIF (SELECT COALESCE(SUM(ws.stock),0) FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Süni ot 50x50')) LIMIT 1))=0 THEN
    UPDATE public.warehouse_stock ws SET stock=1,updated_at=now() WHERE ws.warehouse_id=w_id AND ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Süni ot 50x50')) LIMIT 1);
  END IF;

  -- Süni ot 60x40
  IF NOT EXISTS (SELECT 1 FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Süni ot 60x40')) LIMIT 1) AND ws.warehouse_id=w_id) THEN
    INSERT INTO public.warehouse_stock(warehouse_id,product_id,stock,updated_at) SELECT w_id,p.id,150,now() FROM public.products p WHERE lower(trim(p.name))=lower(trim('Süni ot 60x40')) LIMIT 1;
  ELSIF (SELECT COALESCE(SUM(ws.stock),0) FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Süni ot 60x40')) LIMIT 1))=0 THEN
    UPDATE public.warehouse_stock ws SET stock=150,updated_at=now() WHERE ws.warehouse_id=w_id AND ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Süni ot 60x40')) LIMIT 1);
  END IF;

  -- Yumşaq Panel 35x93
  IF NOT EXISTS (SELECT 1 FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Yumşaq Panel 35x93')) LIMIT 1) AND ws.warehouse_id=w_id) THEN
    INSERT INTO public.warehouse_stock(warehouse_id,product_id,stock,updated_at) SELECT w_id,p.id,172,now() FROM public.products p WHERE lower(trim(p.name))=lower(trim('Yumşaq Panel 35x93')) LIMIT 1;
  ELSIF (SELECT COALESCE(SUM(ws.stock),0) FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Yumşaq Panel 35x93')) LIMIT 1))=0 THEN
    UPDATE public.warehouse_stock ws SET stock=172,updated_at=now() WHERE ws.warehouse_id=w_id AND ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Yumşaq Panel 35x93')) LIMIT 1);
  END IF;

  -- Parket 6605
  IF NOT EXISTS (SELECT 1 FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Parket 6605')) LIMIT 1) AND ws.warehouse_id=w_id) THEN
    INSERT INTO public.warehouse_stock(warehouse_id,product_id,stock,updated_at) SELECT w_id,p.id,1,now() FROM public.products p WHERE lower(trim(p.name))=lower(trim('Parket 6605')) LIMIT 1;
  ELSIF (SELECT COALESCE(SUM(ws.stock),0) FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Parket 6605')) LIMIT 1))=0 THEN
    UPDATE public.warehouse_stock ws SET stock=1,updated_at=now() WHERE ws.warehouse_id=w_id AND ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Parket 6605')) LIMIT 1);
  END IF;

  -- Parket 6610
  IF NOT EXISTS (SELECT 1 FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Parket 6610')) LIMIT 1) AND ws.warehouse_id=w_id) THEN
    INSERT INTO public.warehouse_stock(warehouse_id,product_id,stock,updated_at) SELECT w_id,p.id,1,now() FROM public.products p WHERE lower(trim(p.name))=lower(trim('Parket 6610')) LIMIT 1;
  ELSIF (SELECT COALESCE(SUM(ws.stock),0) FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Parket 6610')) LIMIT 1))=0 THEN
    UPDATE public.warehouse_stock ws SET stock=1,updated_at=now() WHERE ws.warehouse_id=w_id AND ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Parket 6610')) LIMIT 1);
  END IF;

  -- Parket 6611
  IF NOT EXISTS (SELECT 1 FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Parket 6611')) LIMIT 1) AND ws.warehouse_id=w_id) THEN
    INSERT INTO public.warehouse_stock(warehouse_id,product_id,stock,updated_at) SELECT w_id,p.id,1,now() FROM public.products p WHERE lower(trim(p.name))=lower(trim('Parket 6611')) LIMIT 1;
  ELSIF (SELECT COALESCE(SUM(ws.stock),0) FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Parket 6611')) LIMIT 1))=0 THEN
    UPDATE public.warehouse_stock ws SET stock=1,updated_at=now() WHERE ws.warehouse_id=w_id AND ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Parket 6611')) LIMIT 1);
  END IF;

  -- Parket 6615
  IF NOT EXISTS (SELECT 1 FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Parket 6615')) LIMIT 1) AND ws.warehouse_id=w_id) THEN
    INSERT INTO public.warehouse_stock(warehouse_id,product_id,stock,updated_at) SELECT w_id,p.id,1,now() FROM public.products p WHERE lower(trim(p.name))=lower(trim('Parket 6615')) LIMIT 1;
  ELSIF (SELECT COALESCE(SUM(ws.stock),0) FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Parket 6615')) LIMIT 1))=0 THEN
    UPDATE public.warehouse_stock ws SET stock=1,updated_at=now() WHERE ws.warehouse_id=w_id AND ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Parket 6615')) LIMIT 1);
  END IF;

  -- Parket 6630
  IF NOT EXISTS (SELECT 1 FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Parket 6630')) LIMIT 1) AND ws.warehouse_id=w_id) THEN
    INSERT INTO public.warehouse_stock(warehouse_id,product_id,stock,updated_at) SELECT w_id,p.id,1,now() FROM public.products p WHERE lower(trim(p.name))=lower(trim('Parket 6630')) LIMIT 1;
  ELSIF (SELECT COALESCE(SUM(ws.stock),0) FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Parket 6630')) LIMIT 1))=0 THEN
    UPDATE public.warehouse_stock ws SET stock=1,updated_at=now() WHERE ws.warehouse_id=w_id AND ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Parket 6630')) LIMIT 1);
  END IF;

  -- Parket J413
  IF NOT EXISTS (SELECT 1 FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Parket J413')) LIMIT 1) AND ws.warehouse_id=w_id) THEN
    INSERT INTO public.warehouse_stock(warehouse_id,product_id,stock,updated_at) SELECT w_id,p.id,1,now() FROM public.products p WHERE lower(trim(p.name))=lower(trim('Parket J413')) LIMIT 1;
  ELSIF (SELECT COALESCE(SUM(ws.stock),0) FROM public.warehouse_stock ws WHERE ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Parket J413')) LIMIT 1))=0 THEN
    UPDATE public.warehouse_stock ws SET stock=1,updated_at=now() WHERE ws.warehouse_id=w_id AND ws.product_id=(SELECT p.id FROM public.products p WHERE lower(trim(p.name))=lower(trim('Parket J413')) LIMIT 1);
  END IF;

END $$;

UPDATE public.products p SET stock=(SELECT COALESCE(SUM(ws.stock),0) FROM public.warehouse_stock ws WHERE ws.product_id=p.id), updated_at=now() WHERE p.active=true;

COMMIT;

-- Yoxlama:
-- SELECT p.code,p.name,p.stock,ws.stock AS esas_anbar_stoku FROM public.products p LEFT JOIN public.warehouse_stock ws ON ws.product_id=p.id AND ws.warehouse_id=(SELECT id FROM public.warehouses WHERE code='ANB-01') ORDER BY p.name;