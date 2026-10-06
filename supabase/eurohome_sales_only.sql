-- Eurohome yeganə satış anbarıdır; digər anbarlar mal qəbulu üçündür.
DO $$ BEGIN
 IF (SELECT count(*) FROM public.warehouses WHERE lower(trim(name))='eurohome' AND active=true) <> 1 THEN
   RAISE EXCEPTION 'Bir ədəd aktiv Eurohome anbarı yaradın və SQL-i yenidən başladın';
 END IF;
END $$;
CREATE OR REPLACE FUNCTION public.enforce_eurohome_sale()
RETURNS trigger LANGUAGE plpgsql AS $$
BEGIN
 IF NOT EXISTS(SELECT 1 FROM public.warehouses w
               WHERE w.id=NEW.warehouse_id AND lower(trim(w.name))='eurohome' AND w.active=true) THEN
   RAISE EXCEPTION 'Satış yalnız Eurohome anbarından mümkündür';
 END IF;
 RETURN NEW;
END $$;
DROP TRIGGER IF EXISTS sales_eurohome_only ON public.sales;
CREATE TRIGGER sales_eurohome_only BEFORE INSERT OR UPDATE OF warehouse_id ON public.sales
FOR EACH ROW EXECUTE FUNCTION public.enforce_eurohome_sale();
-- Təchizatçı anbarındakı mallar Eurohome-a avtomatik köçürülmür.
