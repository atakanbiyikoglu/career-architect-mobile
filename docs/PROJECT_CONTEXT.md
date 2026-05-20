# PROJE BAĞLAMI: Career Architect Mobile (Native Flutter)

## 1. Proje Kimliği ve Amacı

**Tür:** Mobil istemci uygulaması (Native Flutter, WebView yok).
**Amaç:** Career Architect AI web platformunun analiz zekasını ve görsel kimliğini %100 native Flutter bileşenleri ile mobil ortama tasimak.
**Yaklasim:** Riverpod tabanli state yonetimi, katmanli mimari ve ana proje uzerinden backend-API-first entegrasyon.

## 2. Mimari Vizyon ve UX

**Stratejik Hedef:** Mobil deneyim, webdeki mesajlasma odakli akisi korurken
Material 3 ve native mobil pratiklerle modern, hizli ve yalın bir deneyim sunar.

**Temel UX Prensipleri:**

- Chat odakli, sade ve hizli deneyim.
- AI ve kullanıcı mesajları görünür, modern baloncuk yapısında sunulur.
- Drawer üzerinden temel navigasyon (Yeni Analiz, Geçmiş Analizler, Hakkında).
- Geçmiş ekranindan detay gorunumu, PDF cikti alma ve dis baglanti akisleri desteklenir.
- Tutarlı tema: ana renk #1A1A2E, beyaz arka plan, Poppins tipografi.

## 3. Teknoloji Stack (Kesin Kurallar)

- **UI:** Flutter (Material 3).
- **State Management:** Riverpod (StateNotifier + StateProvider).
- **Network:** Supabase Flutter SDK + http (ana proje API'si icin).
- **Konfigurasyon:** flutter_dotenv ile .env dosyasindan API anahtari.
- **Font:** google_fonts (Poppins varsayilan font).

**Kural:** WebView kesinlikle kullanilmayacak. Tum ekranlar native Flutter widgetlariyla gelistirilecek.

## 4. Proje Yapisı (Flutter)

- **lib/**
  - **models/**: Temel veri modelleri (or. Message).
  - **providers/**: Riverpod state ve notifier katmani.
  - **services/**: API/LLM servisleri.
  - **screens/**: Ekranlar (or. ChatScreen).
  - **widgets/**: Tekrar kullanilabilir UI bilesenleri (or. ChatBubble, CustomDrawer).
- **assets/**
  - `logo.png`: AI avatar ve Drawer markalama.
- **docs/**
  - Proje baglami, gorevler ve gunluk loglar.

## 5. Entegrasyon Notlari

- Supabase dogrudan kullanilir; `participants`, `test_results`,
  `recommendations`, `feedback` tablolarina yazim yapilir.
- A/B deneyi uygulanir: Grup A kural tabanli rapor gorur ve istege bagli AI
  rapor acilir; Grup B dogrudan AI rapor alir.
- LLM yonlendirmesi mobil istemcide yapilmaz; AI cagrilari `https://kariyermimari.tech` uzerindeki backend API'ye birakilir. Bu gateway mimarisi, istemcide herhangi bir LLM anahtarının tutulmamasını sağlar ve güvenlik ile kullanım kotası yönetimini backend'e taşır.
- PDF ve export akışları: Chat bitişinde ve Geçmiş Detay ekranında PDF indirme/paylaşma ve "Promptu Göster" işlevleri uygulandı. Mobilde web için conditional download helper ve native platformlar için `printing` paylaşımı kullanılır.
- Geçmiş listesinde istemci tarafında duplicate (çoğaltılmış) kayıt görünmesini engellemek üzere `history` yükleme işlemi dedupe edilmektedir (ID bazlı).
- API anahtarlari `.env` dosyasindan okunur, kod icinde sabitlenmez.
- Uygulama ProviderScope ile sarilir ve tema Material 3 olarak tanimlanir.

## 6. Gelistirme Tarzi

- SOLID prensiplerine uygun katmanli yapi.
- Gerekli oldukca sade hata yonetimi (try/catch).
- UI tarafinda sade, modern ve okunakli duzen.
- About ekraninda ana proje, GitHub ve LinkedIn baglantilari bulunur.
