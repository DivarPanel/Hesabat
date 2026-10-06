# DecorConcept POS — V5 Admin & Gün Sonu

Bu versiyada əlavə edildi:
- Admin panelində bütün istifadəçilər və statusları
- İstifadəçilərin PIN/rol/telefon/status dəyişdirilməsi
- Kim nə vaxt daxil olub / çıxıb tarixçəsi
- Bütün satışların admin görünüşü
- Qaytarmaların istifadəçi, anbar və tarixlə görünüşü
- Mədaxil/məxaric tarixçəsi: məhsul + əməliyyat + miqdar + anbar + istifadəçi + tarix
- Mədaxil/məxaric üçün məhsul və tarix aralığı filtri
- Xərclərin təsviri və tarixçəsi, xərc əlavə etmə
- Yeni anbar yaratmaq
- Mal qəbulunda anbar seçimi artıq tarixçədə görünür
- Gün sonunun yalnız admin tərəfindən bağlanması
- Gün bağlandıqdan sonra adi istifadəçi satış, qaytarma, mal qəbulu və xərc kimi məlumat dəyişən əməliyyatları edə bilmir
- Admin gün bağlandıqdan sonra da bütün əməliyyatları edə bilir
- Admin günü yenidən aça bilir
- Qaimə silmə yalnız admin
- Məhsul və müştəri kodları istifadəçidən alınmır; avtomatik yaradılır

## Quraşdırma
1. `supabase/migration_v3_admin_control.sql` faylını Supabase SQL Editor-də Run edin.
2. `supabase/functions/api/index.ts` Edge Function `api` üçün deploy edin.
3. `frontend/config.js`-də mövcud Supabase URL və publishable key-i saxlayın.
4. `frontend` qovluğunu GitHub Pages layihənizə yerləşdirin.

## Vacib
Migration V2 əvvəl işlədilmiş olmalıdır. V3 onun üzərinə işləyir.

### Dublikat məhsul düzəlişi
Əgər məhsul siyahısında eyni ad iki dəfə görünürsə (məsələn S-24 və S-141), `supabase/fix_duplicate_products.sql` faylını Supabase SQL Editor-də bir dəfə Run edin. Bu skript eyni adlı məhsulları birləşdirir, stokun ikiqat yazılmasının qarşısını alır və gələcəkdə eyni adlı məhsulun yenidən yaradılmasına mane olur.
