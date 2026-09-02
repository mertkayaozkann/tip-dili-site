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

- [x] **1. Gate 4 — veri bölgesi + DPA doğrulandı ve yer tutucu gerçek metinle DEĞİŞTİRİLDİ.** *(KAPANDI 2026-09-02, Fable 5.1 tam yetkiyle: Supabase projesi `eu-central-1` (Frankfurt) — proje ayarlarından ölçüldü; Supabase DPA + RevenueCat DPA birincil kaynaktan okundu (ikisi de koşullara dahil, SCC); RevenueCat AWS+Snowflake ABD. Metin yalnız olgu; hukuki nitelendirme yazılmadı.)*
  - **Sahip:** Kaya (Supabase / RevenueCat sözleşme ve hesap erişimi onda).
  - **Yer:** `privacy.html` → B5 altındaki `.note` (EN ~140-145, TR ~368-373).
  - **Neden kapı:** Bu `.note` bugün kullanıcıya açık bir **vaat** veriyor — "Bu ayrıntıları, sürüm 2
    yayımlanmadan önce bu sayfada yayımlayacağız." Vaat kapatılmadan V2 yayımlanırsa metin kendi
    taahhüdünü ihlal etmiş olur.
  - **Kapanış koşulu:** Supabase proje bölgesi ve RevenueCat veri işleme koşulları teyit edilir,
    yurt dışına aktarım dayanağı belirlenir, `.note` yer tutucusu **silinip** yerine kalıcı B5 metni
    yazılır (EN + TR aynı anda).
  - **Not:** Doğrulama tamamlanmadan bu bölüme veri bölgesi / DPA / alt-işleyici iddiası yazılmaz.

- [ ] **2. "Sürüm 2 henüz yayımlanmamıştır" cümleleri KALDIRILDI (EN + TR).** *(YAYIN GÜNÜ: `bash yayin-gunu.sh YYYY-MM-DD` — dört cümleyi kaldırır, tarihleri çeker; kopya üzerinde prova edildi 2026-09-02. Sürüm mağazada görünene kadar cümleler DOĞRUDUR ve kalır.)*
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

- [x] **3. Merge, 16C-γ apple-only uygulamaya İNDİKTEN SONRA yapılır.** *(KAPANDI: 2.0.0 (100) kodunda tek giriş yolu Apple ile Giriş — sert kapı kurucu kararı 2026-08-31; OTP yok. V2 metni zaten `main`'de.)*
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

**2. Arka uç gerçekten böyle davranıyor mu? — YEREL DALDA evet, HOSTED'DA hayır.**
Bu madde bilerek commit hash'i anmaz; hash'ler bayatlar ve "hangi hash" sorusu yanlış sorudur.
Bağlayıcı olan **davranış** ve o davranışın **hangi ortamda geçerli olduğudur**.

**Yerel dal (`alan-dili-backend`, henüz push edilmemiş çalışma dalı) — davranış İNDİ.**
`finalize_account_deletion`'ın revocation kapısı artık `apple_revocation_status` ∈
(`not_required`, `done`, `unavailable`) kabul ediyor. `unavailable` "Apple erişimi iptal edildi"
**demez**; "revocation borcu zaman aşımına uğradı, silme yine de yerine getirildi" der (TN3194).
Buna eşlik eden saatlik eskalasyon işi, `provider_done` + (`pending`|`failed`) satırları
`requested_at` üzerinden **24 saatlik sert taban** dolduktan sonra `unavailable`'a geçirip finalize'ı
tetikliyor. Yani revocation `failed`te kalsa bile hesap siliniyor; azami gecikme eşik + kadans ≈
25 saat. Kaynak (dosya adı — hash değil):
`supabase/migrations/20260804134000_goal16c_revocation_debt_escalation.sql`.

**Hosted (canlı Supabase projesi) — davranış İNMEDİ.**
Hosted'ın uyguladığı son migration hâlâ `20260803011904` (2026-08-04'te salt-okunur
`list_migrations` ile doğrulandı). Ne süpürücü (`20260803231500`) ne de borç zaman aşımı
(`20260804134000`) hosted'da var. Kullanıcının gerçekten konuştuğu ortamda finalize,
(`not_required`, `done`) dışındaki her durumu `'apple_revocation_pending'` ile reddediyor ve
**silmiyor**. Site cümlesi bugün yayına çıkarsa, arka ucun **canlı** tarafının tutmadığı bir vaat olur.

**Kapanış koşulu — ortama bakar, hash'e değil.** ✅ **HOSTED'DA DOĞRULANDI (2026-09-02, MCP salt-okunur):** (a) `20260804134000` hosted tarihçesinde var, (b) `wpm5a-revocation-debt-escalation` cron'u `37 * * * *` aktif, (c) `ops_flags.wpm5a_deletion_escalation_enabled=true`. Üçü birden ölçüldü; cümle canlıda tutulabilir.

*(Eski metin:)* Arka uçta 24 saatlik borç zaman aşımı **yerel dalda
mevcuttur; hosted'a uygulandığı doğrulanana kadar bu doğrulama KAPANMAZ.** Doğrulanması gerekenler:
(a) borç zaman aşımı migration'ı hosted'da uygulanmış, (b) saatlik eskalasyon cron kaydı hosted'da
canlı, (c) `ops_flags.wpm5a_deletion_escalation_enabled` hosted'da `true` (fail-closed kill-switch).
Üçü birden doğrulanmadan cümle yayımlanmaz. **İki seçenek vardır: ya hosted'a uygulanır, ya cümle
yayından önce geri alınır. Üçüncüsü yoktur.**

**Bu iki doğrulama yapılmadan V2 metni yayımlanmaz.**

---

## Kural

Bu dal yayın kapısıdır. `main`'e doğrudan commit atılmaz ve merge yalnızca yukarıdaki dört kutunun
tamamı işaretliyken yapılır. Push ve merge işlemlerini Kaya yürütür.
