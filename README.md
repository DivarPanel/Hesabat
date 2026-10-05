# DecorConcept POS — Real Database Edition

Bu paket Google Sheets-dən asılı deyil. Arxitektura:

GitHub Pages → Supabase Edge Function → PostgreSQL

## Paket
- `frontend/index.html` — POS interfeysi
- `frontend/app.js` — frontend məntiqi
- `frontend/config.js` — yalnız public Supabase URL/key
- `supabase/schema.sql` — database, RLS, atomic əməliyyatlar
- `supabase/functions/api/index.ts` — server API

## Quraşdırma

1. Supabase-də yeni project yaradın.
2. SQL Editor → `supabase/schema.sql` faylının hamısını bir dəfə işlədin.
3. Supabase CLI ilə Edge Function deploy edin:
   `supabase functions deploy api`
4. Edge Function üçün `SUPABASE_SERVICE_ROLE_KEY` secret təyin edin. Bu açarı GitHub frontend-ə qoymayın.
5. `frontend/config.js` içində:
   - `SUPABASE_URL`
   - public/anon key
   dəyərlərini yazın.
6. `frontend` qovluğunun məzmununu GitHub repository-yə yerləşdirin.
7. GitHub Pages-i həmin repository üçün aktiv edin.

## İlk PIN-lər
- Bəhram / admin: 3285
- Sadiq / staff: 2255

İlk girişdən sonra PIN-ləri dəyişdirmək üçün ayrıca admin ekranı əlavə etmək tövsiyə olunur.

## Tarix və saat
Əməliyyatların timestamp-i PostgreSQL `timestamptz` ilə saxlanılır. Hesabat və server vaxtı `Asia/Baku` timezone-u ilə hesablanır. Browser `new Date()` satış tarixi üçün istifadə edilmir.

## Vacib
Bu paket deploy-ready skelet və işlək əsas POS axınıdır. Production-a keçməzdən əvvəl:
- PIN dəyişmə ekranı
- rol üzrə daha detallı icazələr
- qaytarma və qaimə redaktəsi
- xərc ekranı
- müştəri borc ödənişi
- audit log
- backup siyasəti
əlavə edilməlidir.
