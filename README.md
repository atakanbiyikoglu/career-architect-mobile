# 🚀 Kariyer Mimarı Mobile (Flutter)

![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)
![Gemini AI](https://img.shields.io/badge/Gemini_AI-8E75B2?style=for-the-badge&logo=googlebard&logoColor=white)

**Kariyer Mimarı Mobile**, kariyermimari.tech web platformunun premium akisini **%100 native Flutter** ile yeniden ureten mobil/masaustu istemcidir. WebView kullanılmaz; UI ve is mantigi tamamen Flutter widgetlari ve Riverpod state machine ile kurgulanir. AI yonlendirmesi ana proje uzerindeki backend API ile yapilir.

Not: Bu repo artık **backend-first** tasarımını takip etmektedir — istemci tarafında LLM anahtarları veya doğrudan LLM çağrıları yoktur. Tüm AI istekleri `API_BASE_URL` (varsayılan: `https://kariyermimari.tech`) üzerinden backend'e iletilir. Ayrıca `.env` dosyası gizli bilgiler içerir ve VCS'de depolanmamalıdır (repo'dan çıkarıldı, `.gitignore`'a eklendi).

## 📌 Proje Amaci

- Webdeki onboarding ve psikometrik test akisini Flutter tarafinda birebir yeniden uretmek.
- RIASEC + OCEAN verilerini toplayip LLM (Gemini) ile analiz raporu olusturmak.
- Responsive masaustu/dar ekran deneyimini korumak.

## ✨ Ozellikler

- **Sohbet Odakli Akis:** Onboarding ve test adimlari chat tabanli ilerler.
- **RIASEC + OCEAN Test Motoru:** Sorular yerel model dosyalarinda tutulur.
- **LLM Raporlama:** Mobil istemci backend API'ye istek atar; rapor akisi sunucu tarafinda uretilir.
- **Geçmiş ve PDF:** Analiz kayıtları detay ekraninda acilir, PDF olarak disari aktarilabilir.
- **About Linkleri:** Ana proje, GitHub ve LinkedIn baglantilari mevcuttur.
- **Responsive UI:** Geniş ve dar ekranlarda esnek yerlesim.

## 🧱 Mimari Yapi

```
lib/
├── main.dart
├── models/
│   ├── message.dart
│   └── question_model.dart
├── providers/
│   └── chat_provider.dart
├── screens/
│   └── chat_screen.dart
├── services/
│   └── ai_service.dart
└── widgets/
    ├── chat_bubble.dart
    └── custom_drawer.dart
```

## 🛠️ Kurulum

1) Bagimliliklari yukleyin:

```bash
flutter pub get
```

2) `.env` dosyasini olusturun (gizli anahtarlar harici ortamda tutulmalıdır):

```env
API_BASE_URL=https://kariyermimari.tech
SUPABASE_URL=your_supabase_url
SUPABASE_ANON_KEY=your_supabase_anon_key
```

3) Uygulamayi calistirin:

```bash
flutter run
```

## 🖥️ Windows Notu

Windows build icin Visual Studio ve **Desktop development with C++** workload gereklidir. Eksikler icin `flutter doctor` calistirin.

## ✅ Kalite Kurallari

- WebView yoktur, tum bilesenler native Flutter.
- Sorular `question_model.dart` icinde, is mantigi `chat_provider.dart` icinde tutulur.
 - Proje analizlerinden temiz çıkması hedeflenir (`flutter analyze`). Son düzenlemelerde analyzer uyarıları giderildi ve proje `flutter analyze --no-pub` ile temiz rapor vermektedir.
 - Web tarafı için platforma özel kod (`dart:html`) conditional import ile ayrılmıştır; `download_helper_web.dart` içerisine analyzer ignore direktifleri eklendi.