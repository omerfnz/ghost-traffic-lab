# GhostTraffic Lab

> **Android Otomasyon & Trafik Üretim Laboratuvarı** — Eğitim Amaçlı Güvenlik Araştırma Aracı

[![Flutter](https://img.shields.io/badge/Flutter-3.41.1-02569B?logo=flutter)](https://flutter.dev)
[![Kotlin](https://img.shields.io/badge/Kotlin-Android-7F52FF?logo=kotlin)](https://kotlinlang.org)
[![Min API](https://img.shields.io/badge/API-24%2B-34A853)](https://developer.android.com)
[![Lisans](https://img.shields.io/badge/Lisans-Eğitim_Amaçlı-FF6F00)](#lisans)

---

## 📋 Genel Bakış

GhostTraffic Lab, Android sistem seviyesindeki izinlerin — Erişilebilirlik
Hizmetleri, Ön Plan Servisler ve Kesin Alarmlar — nasıl bir araya getirilerek
cihaz etkileşimlerini otomatikleştirebildiğini ve kullanıcı müdahalesi
olmadan trafik patternleri üretebildiğini gösteren bir white-hat güvenlik
araştırma aracıdır.

Proje şu kişiler için eğitim referansı niteliğindedir:

- **Güvenlik araştırmacıları** — Android atak yüzeylerini inceleme
- **Geliştiriciler** — Native Android servis mimarisi öğrenme
- **Öğrenciler** — Erişilebilirlik ve otomasyon API'larını keşfetme

> **⚠️ SORUMLULUK REDDİ:** Bu araç kesinlikle eğitim ve yetkilendirilmiş
> test amaçlıdır. Sahip olmadığınız veya test izniniz olmayan sistemlerde
> yetkisiz kullanım yasadışıdır.

---

## 🏗️ Teknoloji Yığını

| Katman | Teknoloji | Versiyon |
|--------|-----------|----------|
| **UI Framework** | Flutter | 3.41.1 |
| **Dil (UI)** | Dart | 3.11 |
| **Dil (Native)** | Kotlin | 1.9+ |
| **State Yönetimi** | Riverpod + Freezed | 2.6.x |
| **Navigasyon** | auto_route | 9.3.x |
| **Yerel Depolama** | Hive | 2.2.x |
| **Kod Kalitesi** | very_good_analysis | 7.x |
| **Min Android API** | 24 (Android 7.0 Nougat) | — |
| **Hedef API** | 34 (Android 14) | — |
| **Derleme SDK** | 36 | — |

---

## 📐 Mimari

Proje, iki ayrı katmandan oluşan **Feature-First Clean Architecture** izler:
Flutter UI katmanı ve Kotlin native servis katmanı.

### Flutter Katmanı (Feature-First)

```
lib/
├── main.dart                              # Uygulama girişi + ProviderScope
├── core/
│   ├── constants/
│   │   └── channel_constants.dart         # MethodChannel/EventChannel isimleri
│   ├── router/
│   │   ├── app_router.dart                # @AutoRouterConfig — rota ağacı
│   │   └── shell_view.dart                # Alt navigasyon kabuğu
│   ├── services/
│   │   ├── native_bridge_service.dart      # Tip-güvenli MethodChannel sarmalayıcı
│   │   └── log_stream_service.dart         # EventChannel → Stream<String>
│   └── theme/
│       ├── app_colors.dart                 # Karanlık tema renk paleti
│       └── app_theme.dart                  # MaterialApp tema yapılandırması
├── product/
│   ├── models/
│   │   ├── payload_action.dart             # Freezed union tipi (12 aksiyon)
│   │   ├── service_status.dart             # Enum: idle/armed/running/error
│   │   └── permission_state.dart           # Freezed: 4x izin boolean'ı
│   └── widgets/
│       ├── status_badge.dart               # Renkli durum göstergesi
│       └── permission_tile.dart            # İzin verildi/reddedildi satırı
└── features/
    ├── dashboard/                          # Ana kontrol merkezi
    ├── permissions/                        # 4 izinlik onay akışı
    ├── payload_builder/                    # Görsel aksiyon dizisi oluşturucu
    ├── scheduler/                          # Alarm zamanlama
    └── logs/                               # Gerçek zamanlı native log görüntüleyici
```

### Kotlin Native Katmanı

```
android/app/src/main/kotlin/com/ghosttraffic/ghost_traffic_lab/
├── MainActivity.kt              # Flutter↔Kotlin köprü kurulumu
├── MethodCallDispatcher.kt      # Tüm MethodChannel çağrılarını yönlendirir
├── PermissionChecker.kt         # İzin kontrolü + Ayarlar intent'leri
├── models/
│   └── PayloadAction.kt         # Sealed class: Wait/Swipe/Click/Launch/TypeText/OpenUrl vb. (Top. 12)
├── engine/
│   ├── PayloadEngine.kt         # Coroutine tabanlı sıralı aksiyon orkestratörü
│   ├── ActionExecutor.kt        # 12 farklı aksiyon tipi için işleyici
│   └── humanlike/               # Bot algılama karşıtı davranış motoru
│       ├── GaussianDelay.kt     # Normal dağılımlı rastgele gecikmeler
│       ├── BezierGesture.kt     # Kübik bezier kaydırma yolu üreteci
│       ├── MicroTremor.kt       # Pozisyon titreşimi + tıklama öncesi gecikme
│       └── SessionFingerprint.kt # Oturum-bazlı benzersiz davranış profili
├── services/
│   ├── BotService.kt            # Ön Plan Servisi (specialUse tipi)
│   ├── ClickerService.kt        # Erişilebilirlik Servisi (jest/tıklama)
│   ├── DeviceWaker.kt           # WakeLock + kilit ekranı devre dışı
│   ├── GestureExecutor.kt       # GestureDescription oluşturucu
│   ├── LogBroadcaster.kt        # Native→Flutter log köprüsü
│   └── NotificationHelper.kt    # Bildirim kanalı + oluşturucu
└── scheduling/
    ├── AlarmScheduler.kt         # setExactAndAllowWhileIdle
    └── AlarmReceiver.kt          # BroadcastReceiver → BotService tetikleyici
```

---

## 🧠 İnsan Benzeri Davranış Motoru

Etkileşimlerin doğal görünmesini sağlayan ve bot algılamasını engelleyen
temel özellik.

### Bileşenler

| Bileşen | Ne Yapar | Parametreler |
|---------|----------|-------------|
| **GaussianDelay** | Sabit gecikmeleri normal dağılımlı rastgele gecikmelerle değiştirir | μ=3s, σ=0.8s, [1s–7s] aralığına sıkıştırılmış |
| **BezierGesture** | Düz çizgi yerine kübik bezier eğrisi yolları üretir | ±40px rastgele kontrol noktaları, 200–600ms süre |
| **MicroTremor** | Tıklamadan önce doğal el titremesini simüle eder | ±8px pozisyon kayması, 50–150ms tıklama öncesi gecikme |
| **SessionFingerprint** | Her oturum için benzersiz davranış profili oluşturur | `System.nanoTime()` tohum → deterministik ama benzersiz |

### Çalışma Prensibi

```
Oturum Başlangıcı → SessionFingerprint.create()
                        ├── GaussianDelay(seed)    ← benzersiz gecikme dağılımı
                        ├── BezierGesture(seed+1)  ← benzersiz kaydırma eğrileri
                        └── MicroTremor(seed+2)    ← benzersiz titreşim paterni

Aksiyon Yürütme:
  Tıklama → MicroTremor.preClickDelay → service.clickByText()
  Kaydırma → BezierGesture.createSwipePath() → dispatchGesture()
  Bekleme  → GaussianDelay.nextDelay()
```

---

## 🔐 Gerekli İzinler

| İzin | Amaç | Nasıl |
|------|------|-------|
| **Erişilebilirlik Servisi** | UI elemanlarını okuma, tıklama/kaydırma yapma | Sistem Ayarları → Erişilebilirlik |
| **Diğer Uygulamaların Üzerinde Göster** | Arka plandan aktivite başlatma | `ACTION_MANAGE_OVERLAY_PERMISSION` |
| **Pil Optimizasyonunu Yoksay** | Doze modunda servisi canlı tutma | `REQUEST_IGNORE_BATTERY_OPTIMIZATIONS` |
| **Kesin Alarm** | Hassas uyanma tetikleyicileri zamanlama | `ACTION_REQUEST_SCHEDULE_EXACT_ALARM` |

---

## 🔄 İletişim Akışı

```
┌──────────────────┐    MethodChannel     ┌───────────────────────┐
│  Flutter UI       │ ←──────────────────→ │  MethodCallDispatcher  │
│  (Riverpod)       │  "lab/control"       │  (Kotlin)              │
└──────────────────┘                      └───────────────────────┘
        │                                          │
        │ EventChannel                             ├─→ PermissionChecker
        │ "lab/logs"                               ├─→ BotService
        ▼                                          ├─→ AlarmScheduler
┌──────────────────┐                               │
│  LogsView         │ ← LogBroadcaster ← ─────────┘
│  (gerçek zamanlı) │
└──────────────────┘
```

---

## 🚀 Başlangıç

### Ön Koşullar

- [FVM](https://fvm.app) (Flutter Versiyon Yönetimi)
- Android SDK 36+
- Fiziksel Android cihaz (API 24+) — test için

### Kurulum & Derleme

```bash
# Klonla
git clone https://github.com/your-repo/ghost-traffic-lab.git
cd ghost-traffic-lab

# Flutter kurulumu
fvm install
fvm flutter pub get

# Kod üretimi (Freezed, Riverpod, auto_route)
fvm flutter pub run build_runner build --delete-conflicting-outputs

# Debug APK derle
fvm flutter build apk --debug

# Cihaza yükle
fvm flutter install
```

### Testleri & Otomasyonu Çalıştır

```bash
# Emulator Oto-Kurulumu (İzinleri verir ve APK'yı kurar)
./scripts/setup_emulator.fish

# Doğrudan Arka Plan Motoru Testi (ADB üzerinden)
./scripts/test_engine.fish

# Uçtan Uca (E2E) UI Entegrasyon Testi (Emülatörde çalışır)
fvm flutter test integration_test/bot_e2e_test.dart -d emulator-5554

# Unit Testler ve Statik Analiz
fvm flutter test           # 17 birim test
fvm flutter analyze        # Statik analiz (0 sorun)
```

---

## 📱 Uygulama Ekranları

| Ekran | Açıklama |
|-------|----------|
| **Dashboard** | Sistem durumu (idle/armed/running), izin özeti, ARM/DISARM butonu |
| **Payload Builder** | Sürükle-bırak aksiyon dizisi oluşturucu + JSON dışa aktarım |
| **Scheduler** | Saat seçici + hedef paket seçimi ile alarm bazlı tetikleme |
| **Logs** | Otomatik kaydırmalı gerçek zamanlı monospace log görüntüleyici |
| **Permissions** | 4 izinli kontrol listesi + izin ver butonları |

---

## 🏛️ Tasarım İlkeleri

- **Mikro-Modüler Mimari** — Her dosya < 100 satır, her fonksiyon < 20 satır
- **Feature-First** — Her özellik kendi controller/view'ı ile bağımsız
- **Tek Sorumluluk** — Bir sınıf, bir iş, bir dosya
- **Kalıtım Yerine Bileşim** — Mixin/composition tercih edilir
- **Tasarımda Test Edilebilirlik** — Tüm bağımlılıklar Riverpod ile enjekte edilebilir

---

## 📊 Proje İstatistikleri

| Metrik | Değer |
|--------|-------|
| Kotlin dosyaları | 17 dosya |
| Dart dosyaları (non-generated) | 27 dosya |
| Test dosyaları | 3 dosya, 17 test |
| En uzun dosya | 98 satır (PayloadEngine.kt) |
| Toplam Kotlin satırı | ~1.000 |
| Toplam Dart satırı | ~1.280 |
| `flutter analyze` | 0 sorun |
| `flutter test` | %100 başarı |

---

## ⚖️ Lisans

Bu proje **yalnızca eğitim ve yetkilendirilmiş güvenlik araştırması** için
tasarlanmıştır. Yazarlar herhangi bir kötüye kullanımdan sorumlu değildir.

**Bu aracı şunlar için KULLANMAYIN:**
- Sahip olmadığınız servislerde etkileşim otomatikleştirme
- Sahte trafik veya etkileşim üretme
- Yetki olmadan güvenlik önlemlerini atlatma
- Herhangi bir hizmet şartını veya geçerli yasayı ihlal etme
