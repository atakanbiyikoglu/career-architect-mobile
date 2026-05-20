<!--
DAILY LOG KURALLARI VE SABLONU (LLM'ler ve Gelistiriciler Icin)

SIRALAMA: Daima ters kronolojik (En yeni tarih en ustte).

DIL VE TON: Profesyonel, net ve deklaratif. Yapildi, Eklendi, Tanimlandi gibi edilgen veya nominal ifade kullanilmalidir. Birinci tekil sahis kullanilmaz.

YAPI: Her gun icin YYYY-MM-DD basligi atilmali. Altinda su kategoriler kullanilmali: Ozellikler (Features), Hata Duzeltmeleri (Fixes), Mimari ve Altyapi (Chores).

DETAY SEVIYESI: Yapilan islemler ve sistemdeki etkileri teknik detaylariyla birlikte, kapsamli ve profesyonel maddeler halinde yazilmalidir.
-->

# Daily Log

## 2026-05-19

### Ozellikler (Features)

- Geçmiş analizler ekranı kullanıcı adıyla zenginleştirildi; kayıtlar detay görünümüne açılabilir hale getirildi.
- Analiz detay ekranına PDF dışa aktarma akışı eklendi; rapor artık paylaşılabilir belge olarak üretilebiliyor.
- Hakkında ekranına ana proje, GitHub ve LinkedIn bağlantıları yerleştirildi.
- Chat ekranında mobil ve geniş ekran hizası yumuşatıldı; drawer erişimi her görünümde tutarlı hale getirildi.

### Hata Duzeltmeleri (Fixes)

- PDF oluşturma servisinde derleme hataları giderildi; yazı tipi kullanımı sadeleştirildi ve const uyumsuzlukları kaldırıldı.

### Mimari ve Altyapi (Chores)

- Mobil istemci için backend-API-first yapı dokümante edildi; doğrudan LLM çağrısı yerine ana proje API'si esas alınır hale getirildi.
- README ve proje bağlam dokümanları, tarihçe/detay/PDF ve dış bağlantı akışlarıyla uyumlu olacak şekilde güncellendi.

## 2026-05-17

### Ozellikler (Features)

- Native Flutter sohbet arayuzu iskeleti olusturuldu; AppBar, mesaj listesi, input ve gonder butonu tamamlandi.
- AI ve kullanıcı mesajlarını ayıran modern baloncuk tasarımı uygulandı; AI tarafı logo avatar ile desteklendi.
- Drawer için marka alanları ve temel navigasyon başlıkları (Yeni Analiz, Geçmiş Analizler, Hakkında) tanımlandı.
- Onboarding durum makinesi 4 adım olarak kurgulandı; isim, okul, bölüm ve hedef toplama akışına göre AI mesajları senkronlandı.
- Test akışı için RIASEC ve OCEAN soru setleri eklenerek 28 soruluk ilerleyiş ve evet/hayır seçenekleri tasarlandı.
- Test bitiminde analiz raporu ve memnuniyet puanlama akışı kurgulandı; Markdown rapor gösterimi desteklendi.
- Başlangıç mesajları 0.8sn gecikmeli olarak gösterilecek şekilde zamanlandı; onboarding giriş hissi netleştirildi.
- Option butonları ve yıldızlı puanlama butonları soru/geri bildirim mesajlarının altına konumlandı.
- Chat ekranına 600px breakpoint ile responsive yerleşim eklendi; geniş ekranda 250px sabit sidebar, dar ekranda drawer davranışı tanımlandı.
- Supabase doğrudan entegrasyonuna geçildi; onboarding sonunda `participants` kaydı ve test bitiminde `test_results` satırları yazılacak şekilde akış güncellendi.
- A/B deney akisi mobilde uygulandi; Grup A icin kural tabanli rapor ve istege bagli AI kilidi, Grup B icin dogrudan AI raporu eklendi.
- AI raporu `recommendations` tablosuna, memnuniyet puani `feedback` tablosuna yazilacak sekilde veri modeli tamamlandi.

### Hata Duzeltmeleri (Fixes)

- Stabilizasyon kapsaminda hata kaydi acilmadi.
- `chat_bubble.dart` kaynakli analyzer hatalari temizlendi; Markdown ve aksiyon butonlari duzgun calisir hale getirildi.

### Mimari ve Altyapi (Chores)

- Riverpod state mimarisi kuruldu; Message modeli ve notifier katmani olusturuldu.
- LLM servis katmani Groq uyumlu endpoint ile dogrudan HTTP cagrisi yapacak sekilde tanimlandi.
- Tema altyapisi Material 3, #1A1A2E seedColor ve Poppins tipografi ile standardize edildi.
- API servis katmani `startExperiment`, `submitTestResults`, `submitFeedback` akislari icin izole edildi.
- `flutter_markdown` bagimliligi eklenerek rapor metni icin Markdown render altyapisi kuruldu.
- Windows build icin toolchain eksigi tespit edildi; `flutter doctor` ile Visual Studio gereksinimi dogrulandi.
- Supabase Flutter SDK bagimliligi eklenerek mobil istemciden dogrudan veri yazma stratejisi standart hale getirildi.

## 2026-05-17 (Dev - Mobile)

### Ozellikler (Features)

- Mobil istemci artık doğrudan LLM anahtarlarıyla konuşmuyor; `lib/services/ai_service.dart` sunucu uç noktalarına (`/api/submit-test`, `/api/unlock-ai-report`) istek atacak şekilde güncellendi. Bu sayede API anahtarları sunucu tarafında korunuyor.
- A/B akışı mobilde doğrulandı: Grup A için kural tabanlı rapor gösterimi + isteğe bağlı AI kilidi; Grup B için sunucu tarafından üretilen AI raporu doğrudan getiriliyor.
- `tools/api_integration_test.js` eklendi; backend uç noktalarını otomatik olarak test eden küçük bir Node script'i ile `start-experiment`, `submit-test`, `unlock-ai-report` akışları doğrulandı.

### Hata Duzeltmeleri (Fixes)

- `lib/widgets/custom_drawer.dart` içindeki layout ve route hataları giderilerek Drawer taşma/overflow sorunları çözüldü; named-route bağımlılığı kaldırıldı ve `MaterialPageRoute` ile güvenli navigasyon sağlandı.
- `lib/providers/chat_provider.dart` içinde kural tabanlı rapor üretiminde boş/eksik veri durumları için koruma eklendi — null/empty guard'ları sayesinde runtime istisnaları engellendi.

### Mimari ve Altyapi (Chores)

- `flutter run -d chrome` ile yerel tarayıcıda uygulama başlatıldı; DevTools bağlantısı sağlandı ve uygulama akışı elle test edildi.
- Yapılan değişiklikler repo'ya commitlendi ve remote'a pushlandı (mobil branch). Detaylar: AI yönlendirme, drawer/UI düzeltmeleri, history/about görsel iyileştirmeleri, entegrasyon test script'i.

