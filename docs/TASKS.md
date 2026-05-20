# CAREER ARCHITECT MOBILE - MASTER TASKS & ARCHITECTURE DOCUMENT
Bu belge, `career-architect-ai` web projesinin tum fonksiyonlarini barindiran
native Flutter uygulamasi icin "Lead Developer"in izleyecegi mimari
yönergeleri icerir.

## 1. GÖRSEL KİMLİK VE TEMEL UI/UX (NATIVE MATERIAL 3)
Web projesinin marka kimligi korunacak, ancak arayuz tamamen native mobil
pratiklere gore tasarlanacaktir.
- [x] **Ana Tema (ThemeData):** Koyu renk (Primary) `#1A1A2E`. Arka plan (Background) tam beyaz `#FFFFFF`. Yazı tipi (Font) `GoogleFonts.poppins`.
- [x] **AppBar:** Arka planı beyaz, gölgesi (elevation) 0, başlık metni "Kariyer Mimarı AI" ve metin rengi `#1A1A2E`. Sol üstte hamburger menü (koyu renk).
- [x] **CustomDrawer (Yan Menü):** Arka plan KESİNLİKLE `#1A1A2E`. Metinler ve ikonlar tam beyaz (`Colors.white`). Sekmeler: "Yeni Analiz", "Geçmiş Analizler", "Hakkında".
- [x] **ChatBubble (Mesaj Balonları):** - **AI Mesajı:** Sola hizalı. Arka plan rengi `#F4F4F9` (açık gri/mor). Metin rengi `#1A1A2E`. Sol alt köşe (bottomLeft) radius 0, diğerleri 15px. Sol tarafında logo avatar kullanilir. Hafif gölge (BoxShadow).
  - **Kullanıcı Mesajı:** Sağa hizalı. Avatar YOK. Arka plan `#1A1A2E`. Metin rengi `#FFFFFF`. Sağ alt köşe (bottomRight) radius 0, diğerleri 15px.
- [x] **Bottom Input (Girdi Alanı):** Ekranın en altında, SafeArea içinde, köşeleri `25px` yuvarlatılmış (StadiumBorder), arkaplanı açık gri olan, sağ tarafında gönder butonu (icon) barındıran modern bir `TextField`. Kenarlara sıfır temas etmeyecek (padding olacak).

## 2. STATE MANAGEMENT (RIVERPOD) - `state.js` KLONU
Web projesindeki `appState` ve `userData` objeleri Riverpod provider'larına dönüştürülecektir.
- [x] **Değişkenler:** - `flowState`: 'ONBOARDING' | 'TEST_INTRO' | 'TESTING' | 'ANALYZING' | 'AI_UNLOCK' | 'FEEDBACK' | 'FINISHED'
  - `currentStep`: int (0'dan başlar)
  - `currentTest`: 'RIASEC' | 'OCEAN'
  - `currentQuestionIndex`: int (0)
  - `studentName`, `school`, `department`, `currentGoal`: String
  - `testAnswers`: List<Map> (Soru ID'si, test türü ve verilen evet/hayır cevabını tutar)

## 3. ONBOARDING DURUM MAKİNESİ (4 ADIM) - `main.js` KLONU
Sistem açıldığında KESİNLİKLE API çağrısı yapılmayacak. Aşağıdaki sıralı durum makinesi işletilecektir.
- [x] **Başlangıç Durumu (Initialization):** Uygulama açılır açılmaz (0.8sn gecikme ile) listeye şu 2 mesaj eklenecek:
  1. "Merhaba! Ben Kariyer Mimari AI. TÜBİTAK 2209-A kapsamında geliştirilen bu platform, ilgi ve kişilik testlerini yapay zeka ile sentezleyerek sana en uygun bilişim kariyerini çizer. (Teste başlayarak akademik aydınlatma metnini onaylamış sayılırsın)."
  2. "Başlamadan önce seni tanıyalım, adın nedir?"
- [x] **Adım 0 (İsim):** Kullanıcı adını girince -> `studentName`'e kaydet. AI yanıtı: "Memnun oldum [İSİM]. Hangi okulda okuyorsun?"
- [x] **Adım 1 (Okul):** Kullanıcı okulu girince -> `school`'a kaydet. AI yanıtı: "Anladım. Peki hangi bölümde okuyorsun?"
- [x] **Adım 2 (Bölüm):** Kullanıcı bölümü girince -> `department`'a kaydet. AI yanıtı: "Süper. Son olarak, kariyer hedefin veya en büyük hayalin nedir?"
- [x] **Adım 3 (Hedef):** Kullanıcı hedefi girince -> `currentGoal`'e kaydet. AI yanıtı: "Harika! Bilgilerini kaydediyorum, lütfen bekle..." -> **BURADA Supabase `participants` tablosuna kayit acilir.**
- [x] **API Yanıtı Sonrası:** İşlem başarılıysa AI yanıtı: "Kaydını başarıyla aldım. Şimdi teste geçiyoruz." -> `startTestFlow()` fonksiyonunu tetikle.

## 4. TEST AKIŞI (RIASEC + OCEAN)
- [x] **Veri Yükleme:** Local JSON dosyalarından veya sabit listelerden RIASEC ve OCEAN soruları belleğe alınacak.
- [x] **Test Girişi:** AI Mesajı: "Kısa bir ilgi ve kişilik testi başlatıyorum. Hazırsan sorular geliyor."
- [x] **Soru Gösterimi:** - AI Mesajı formatı: "Soru [MEVCUT_SORU_NO]/[TOPLAM_SORU]: [SORU_METNİ]"
  - Soru balonunun altına (sağa sola değil, alt alta veya yanyana şık bir şekilde) 2 adet Option Button eklenecek: 
    1. "Evet, katılıyorum" (Value: true)
    2. "Hayır, katılmıyorum" (Value: false)
  - TextField (Yazı yazma alanı) test süresince KİLİTLİ (disabled) veya gizli olacak.
- [x] **Test Geçişi:** RIASEC bitince AI Mesajı: "Harika. Şimdi kişilik envanteri bölümüne geçiyoruz." -> OCEAN soruları başlar.
- [x] **Test Bitişi:** OCEAN bitince AI Mesajı: "Tüm testi tamamladın. Cevaplarını analiz ediyorum..." -> **BURADA `test_results` tablosuna RIASEC/OCEAN satirlari yazilir.**

## 5. GERİ BİLDİRİM VE SONUÇ (FEEDBACK & REPORTING)
- [x] **Memnuniyet Anketi:** Test analizi ekrana basildiktan sonra AI Mesajı: "Deneyiminizi puanlayarak profesyonel analiz raporunuzu PDF formatında hemen indirebilirsiniz! 📊 Lütfen 1'den 5'e kadar bir puan veriniz:"
- [x] **Puan Butonları:** AI mesajının altına 5 adet yıldızlı buton eklenecek: "⭐ 1", "⭐ 2", "⭐ 3", "⭐ 4", "⭐ 5".
- [x] **Bitiş:** Puan seçildiğinde -> **`feedback` tablosuna kayit acilir.** Sonrasında AI Mesajı: "Teşekkürler! [PUAN]/5 puanını kaydettim... 🎉 Deney tamamlandı. Katılımın için çok teşekkür ederiz!"

Additional notes:
- Chat sonu PDF export akışı, puanlama aşamasında etkin hale gelecek şekilde uygulandı. Kullanıcı puan verdikten sonra `PDF İndir` veya `Promptu Göster` butonları görüntülenir ve aynı export/clipboard davranışı `HistoryDetailScreen` ile eşlenmiştir.

## 9. SUNUM VE DENEYİM İYİLEŞTİRMELERİ
- [x] **Geçmiş Ekranı:** Kullanıcı adıyla birlikte analiz kaydı listelenir; satıra dokunulduğunda detay ekranı açılır.
- [x] **Detay Ekranı:** Analiz özeti, profil bilgileri ve rapor metni tek ekranda gösterilir.
- [x] **PDF Çıkışı:** Detay ekranından analiz raporu PDF olarak dışa aktarılabilir.
- [x] **Hakkında Ekranı:** Ana proje, GitHub ve LinkedIn bağlantıları eklendi.
- [x] **Responsive Poliş:** Chat ve About ekranlarında mobilde sıkışık, masaüstünde aşırı merkezli görünen yerleşimler azaltıldı.

Notes on recent fixes:
- `download_helper_web.dart` içinde web-only `dart:html` kullanımına dair analyzer uyarıları conditional import ve ignore direktifi ile temizlendi.
- `.env` dosyaları repoya eklenmekten kaçınıldı; gizli anahtarlar `.gitignore` ile korunmalıdır.

## 6. A/B DENEYI VE AI KILIDI
  - [x] **Grup A:** Kural tabanlı rapor gösterilir ve `recommendations` tablosuna
  `source_model=rule_based` ile kaydedilir. Ardından "AI analizini görmek
  ister misiniz?" seçeneği sunulur. Kullanıcı kabul ederse Gemini raporu
  üretilir ve `recommendations` tablosuna `source_model=gemini-1.5-flash`
  ile yazılır.
- [x] **Grup B:** Test bitince dogrudan Gemini raporu uretilir ve kaydedilir.

## 7. AĞ (SUPABASE) VE SERVİS KATMANI
Web projesinin Supabase semasi ile birebir uyum korunur. Flutter, Supabase
SDK ile dogrudan veri yazar.
- [x] `participants`: onboarding bitince kayit olusturulur.
- [x] `test_results`: test cevaplari `test_type` alanina gore ayrilir.
- [x] `recommendations`: rule_based ve AI raporlari kaydedilir.
- [x] `feedback`: memnuniyet puani kaydedilir.

## 8. GÜVENLİK VE MODÜLERLİK (YAPILMAMASI GEREKENLER)
- KESİNLİKLE `WebView` kullanılmayacak.
- KESİNLİKLE Spagetti kod yazılmayacak. UI bileşenleri `lib/widgets` içine, servisler `lib/services` içine, durum yönetimi `lib/providers` içine ayrılacak.
- KESİNLİKLE sisteme hardcoded API key yazılmayacak. `.env` üzerinden `flutter_dotenv` paketi ile okunacak.

**TALİMAT:** Lead Developer, bu dokümandaki adımları sırasıyla uygula. Hiçbir adımı atlama, metinleri birebir kullan. İşlemi başlat.