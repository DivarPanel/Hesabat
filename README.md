# DecorConcept POS — V2

Google Sheetssiz, Supabase PostgreSQL + Edge Function əsaslı POS.

## V2 imkanları
- Giriş ekranında hazır PIN yazısı yoxdur; kodu istifadəçi özü daxil edir.
- Cəld satış.
- Cəld mal qəbul.
- Çoxlu anbar dəstəyi: satış və mədaxildə anbar seçilir.
- Qaytarma.
- Qaiməyə baxış və çap.
- Admin üçün qaimə dəyişdirmə: müştəri, anbar, ödəniş, endirim, məhsul miqdarı və qiymət.
- Ana səhifədə ən çox satılan məhsul və ən çox alver olan gün.
- Enter ilə sürətli məhsul seçimi.
- Server vaxtı Asia/Baku.

## Quraşdırma
1. Supabase-də mövcud əsas schema artıq qurulubsa, `supabase/migration_v2.sql` faylını SQL Editor-da bir dəfə işlədin.
2. `supabase/functions/api/index.ts` kodunu `api` Edge Function-a deploy edin.
3. Edge Function secret olaraq `SUPABASE_SERVICE_ROLE_KEY` təyin edin.
4. `frontend/config.js` artıq layihənin URL və publishable key-i ilə doldurulub.
5. `frontend` qovluğunu GitHub Pages-də yayımlayın.

## Vacib
`SUPABASE_SERVICE_ROLE_KEY` heç vaxt frontend-ə yerləşdirilməməlidir.
