# GO / NO-GO — V2 metni yayın kapısı

Bu dosya, `feature/v2-privacy-rewrite` dalının `main`'e alınması ve V2 metninin canlıya
çıkması için kapatılması **zorunlu** maddeleri listeler. Dört kutunun tamamı işaretlenmeden
merge yapılmaz.

- Dal: `feature/v2-privacy-rewrite` (yayın kapısı — `main`'e doğrudan commit yok)
- Kapsam: `index.html`, `privacy.html`, `support.html`
- Canlı: https://mertkayaozkann.github.io/tip-dili-site/

Satır numaraları yaklaşıktır (`~`); metin düzenlendikçe kayabilir, ilgili bölüm adı bağlayıcıdır.

---

## Kapatılacak maddeler

- [ ] **1. Gate 4 — veri bölgesi + DPA doğrulandı ve yer tutucu gerçek metinle DEĞİŞTİRİLDİ.**
  - **Sahip:** Kaya (Supabase / RevenueCat sözleşme ve hesap erişimi onda).
  - **Yer:** `privacy.html` → B5 altındaki `.note` (EN ~140-145, TR ~368-373).
  - **Neden kapı:** Bu `.note` bugün kullanıcıya açık bir **vaat** veriyor — "Bu ayrıntıları, sürüm 2
    yayımlanmadan önce bu sayfada yayımlayacağız." Vaat kapatılmadan V2 yayımlanırsa metin kendi
    taahhüdünü ihlal etmiş olur.
  - **Kapanış koşulu:** Supabase proje bölgesi ve RevenueCat veri işleme koşulları teyit edilir,
    yurt dışına aktarım dayanağı belirlenir, `.note` yer tutucusu **silinip** yerine kalıcı B5 metni
    yazılır (EN + TR aynı anda).
  - **Not:** Doğrulama tamamlanmadan bu bölüme veri bölgesi / DPA / alt-işleyici iddiası yazılmaz.

- [ ] **2. "Sürüm 2 henüz yayımlanmamıştır" cümleleri KALDIRILDI (EN + TR).**
  - **Sahip:** Kaya (yayın metni).
  - **Yerler:**
    - `privacy.html` EN `.card` — ~37-38: "As of the last-updated date above, version 2 has not been released."
    - `privacy.html` TR `.card` — ~261-262: "…sürüm 2 henüz yayımlanmamıştır."
    - `support.html` EN `.note` — ~40: "As of 3 August 2026, version 2 has not been released."
    - `support.html` TR `.note` — ~208-209: "…sürüm 2 henüz yayımlanmamıştır."
  - **Kapanış koşulu:** Dört cümle de kaldırılır; `privacy.html` "Last updated / Son güncelleme" ve
    `support.html` içindeki tarih referansları yayın tarihine güncellenir. Sürüm-kapsamlı çerçeve
    ("1.0.1 için" / "Sürüm 2'den itibaren") **korunur** — kaldırılan yalnızca yayın-durumu cümleleridir.
  - **Not:** `index.html` bilinçli olarak yayın-durumu cümlesi taşımaz (sürüm-kapsamlı yazıldı);
    orada kaldırılacak bir cümle yoktur.

- [ ] **3. Merge, 16C-γ apple-only uygulamaya İNDİKTEN SONRA yapılır.**
  - **Sahip:** Kaya (merge yetkisi).
  - **Neden kapı:** Metin "tek giriş yolu Apple ile Giriş'tir" diyor (`privacy.html` B2, `support.html`
    giriş SSS'i, `index.html` sürüm notu). Uygulama bugün hâlâ e-posta OTP kullanıyor; metin bu haliyle
    canlıya çıkarsa yayında yanlış olur.
  - **Kapanış koşulu:** apple-only giriş, App Store'a gidecek V2 build'inde yer alıyor. Öncesinde
    `main`'e merge **yok**.

- [ ] **4. Merge sonrası GitHub Pages'te canlı metin doğrulandı.**
  - **Sahip:** Kaya.
  - **Kapanış koşulu:** Pages dağıtımı tamamlandıktan sonra `/`, `/privacy.html` ve `/support.html`
    tarayıcıda önbellek atlanarak açılır; 1-3'teki değişikliklerin **canlıda göründüğü** (eski
    "veri cihazdan çıkmaz" metni ve yayın-durumu cümleleri artık yok) tek tek teyit edilir.
  - **Not:** Pages dağıtımı geçmişte takıldığı için "merge edildi" ≠ "yayında". Bu madde göz doğrulaması
    ister.

---

## Kalıcı kural — analitik (analytics) açılırsa

Bu bir merge kutusu **değildir**; bugün kapatılamaz, çünkü kapatılacak bir eksik yok. Süresiz
yürürlükte kalan bağlayıcı bir kuraldır.

**Bugünkü durum (doğrulandı):** uygulamada analitik SDK'sı **yok** — `medical-voc-app/TipDili`
kaynağında (App/, Shared/, Widget/) analitik/çökme-raporlama SDK'sı geçmiyor; `project.yml`
paket bağımlılıkları yalnızca AlanDiliCore + Supabase + RevenueCat; `Support/PrivacyInfo.xcprivacy`
`NSPrivacyTracking=false` ve üç veri tipinin üçü de `Tracking=false` / amaç yalnız AppFunctionality.

**Neden kural gerekiyor:** arka uçta `public.profiles.analytics_user_id` kolonu **bugün hiçbir kod
tarafından kullanılmıyor** (yalnızca şema testlerinde geçiyor) ama yorumu bir analitik tarafını
açıkça öngörüyor — "Analytics tarafına auth kimliğini vermemek için üretilen ayrı pseudonymous
kimlik (D11/D12)". Kaynak:
`alan-dili-backend/supabase/migrations/20260715205143_wp_m2_profile_foundation.sql` (~130, ~143).

Analitik herhangi bir biçimde açılırsa, aşağıdaki **dördü AYNI ANDA** güncellenir:

1. `index.html` — "No tracking / Takip yok" maddesindeki analitik cümlesi (EN ~36, TR ~74).
2. `privacy.html` — **B1** (EN ~91, TR ~315) ve gerekiyorsa **B3** veri listesi; EN + TR birlikte.
3. `medical-voc-app/TipDili/Support/PrivacyInfo.xcprivacy` — toplanan veri tipleri ve izleme beyanı.
4. App Store Connect **App Privacy** anketi.

**Dördünden biri güncellenmeden analitik açılmaz.** Aynı sürümde gitmezlerse App Store beyanı, site
metni ve gizlilik politikası birbirini yalanlar.

**Not:** `index.html`'deki analitik cümlesi artık sürüm-kapsamlıdır ("as of version 2" /
"sürüm 2 itibarıyla") — anlık durum beyanıdır, süresiz taahhüt değildir. Reklam, reklam tanımlayıcısı
ve uygulamalar arası takip iddiaları kapsamsız kaldı; bunlar `privacy.html` B1'de sürüm 2 için de
aynen taahhüt edildiği için tutarlıdır.

---

## Kalıcı kural — "Apple erişimi iptal edilemese de silme tamamlanır" cümlesi

Bu da bir merge kutusu **değildir**; dört kutuluk kapı yapısı değişmedi. Süresiz yürürlükte kalan
bağlayıcı bir kuraldır ve bu turda eklenen cümleye bağlıdır.

**Dayanak:** Karar D-20260803-12 (2026-08-03) — Apple token revocation, silmenin **ön koşulu değil**,
best-effort **borcudur**. Birincil kaynak (mimar tarafından tarayıcıdan doğrulandı):
`https://developer.apple.com/documentation/technotes/tn3194-handling-account-deletions-and-revoking-tokens-for-sign-in-with-apple`

**Eklenen cümle (EN + TR, dört yer):** `privacy.html` B6 liste maddesi (EN ~163, TR ~394);
`support.html` hesap silme SSS'i (EN ~152, TR ~325). Cümlenin verdiği söz **hesabın silinmesidir**;
"Apple erişimin kaldırıldı" sözü **verilmez**.

Yayın öncesi **iki** doğrulama zorunludur:

**1. Uygulama içi silme akışı metniyle (16C-γ) tutarlılık.**
Bugünkü durum (doğrulandı, 2026-08-04): `medical-voc-app` HEAD `35ff244`,
`TipDili/App/AccountView.swift` silme akışında Apple erişimi/revocation iddiası **yok** (onay metni
yalnız aboneliğin kendiliğinden iptal olmadığını söylüyor); uygulama kaynağındaki tek "revocation"
`StoreKitSubscriptionService.swift` ~24'teki `transaction.revocationDate`'tir (iade kontrolü, ilgisiz).
16C-γ apple-only akışı uygulamaya indiğinde bu doğrulama **yeniden** yapılır — kutu 3 merge'ü zaten
16C-γ'ya bağlıyor. Uygulama "Apple erişimin kaldırıldı" benzeri bir şey söylüyorsa **ikisi birden**
düzeltilir; biri düzeltilip diğeri bırakılmaz.

**2. Arka uç gerçekten böyle davranıyor mu? — bugün HAYIR.**
Bugünkü durum (doğrulandı, 2026-08-04): `alan-dili-backend` HEAD `40999d8`'de
`finalize_account_deletion`, `apple_revocation_status` ∈ (`not_required`,`done`) değilse
`'apple_revocation_pending'` döndürür ve **silmez**
(`supabase/migrations/20260803011904_goal16b_backend_hardening.sql` ~615-617); süpürücü de
`pending|failed` satırlara dokunmaz, yalnız kimliksiz sayar
(`20260803231500_goal16c_deletion_chain_sweeper.sql` ~189, ~224). Yani revocation `failed`te kalırsa
silme **bugün tamamlanmaz** ve site cümlesi arka ucun tutmadığı bir vaat olur. Bu cümle canlıya
çıkmadan önce D-20260803-12'nin arka uç şeridi inmeli: revocation `failed`/`pending` iken de finalize
tamamlanmalı, revocation borcu ayrıca izlenmeli. **İnmezse iki seçenek vardır: ya arka uç düzeltilir,
ya cümle yayından önce geri alınır. Üçüncüsü yoktur.**

**Bu iki doğrulama yapılmadan V2 metni yayımlanmaz.**

---

## Kural

Bu dal yayın kapısıdır. `main`'e doğrudan commit atılmaz ve merge yalnızca yukarıdaki dört kutunun
tamamı işaretliyken yapılır. Push ve merge işlemlerini Kaya yürütür.
