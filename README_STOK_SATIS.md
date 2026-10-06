# Cəld satış stok düzəlişi

1. `supabase/fix_quick_sale_stock.sql` faylını Supabase SQL Editor-də tam şəkildə Run et.
2. Edge Function `api`-nin V8 versiyasını deploy et.
3. Saytda Ctrl+F5 et.

Satış zamanı seçilmiş anbarın `warehouse_stock` stokundan satılan miqdar çıxılır. `products.stock` bütün anbarların cəmi kimi yenilənir.
