# GhostTraffic Lab

> **Android Automation & Traffic Generation Lab** — Educational Security Research Tool

[![Flutter](https://img.shields.io/badge/Flutter-3.41.1-02569B?logo=flutter)](https://flutter.dev)
[![Kotlin](https://img.shields.io/badge/Kotlin-Android-7F52FF?logo=kotlin)](https://kotlinlang.org)
[![Min API](https://img.shields.io/badge/API-24%2B-34A853)](https://developer.android.com)
[![License](https://img.shields.io/badge/License-Educational-FF6F00)](#license)

---

## 📋 Overview

GhostTraffic Lab is a white-hat security research tool that demonstrates how
Android system-level permissions — Accessibility Services, Foreground Services,
and Exact Alarms — can be combined to automate device interactions and generate
traffic patterns without direct user input.

The project serves as an educational reference for:

- **Security researchers** studying Android attack surfaces
- **Developers** learning native Android service architecture
- **Students** exploring accessibility and automation APIs

> **⚠️ DISCLAIMER:** This tool is strictly for educational and authorized
> testing purposes. Unauthorized use against systems you don't own or have
> permission to test is illegal.

---

## 🏗️ Tech Stack

| Layer | Technology | Version |
|-------|-----------|---------|
| **UI Framework** | Flutter | 3.41.1 |
| **Language (UI)** | Dart | 3.11 |
| **Language (Native)** | Kotlin | 1.9+ |
| **State Management** | Riverpod + Freezed | 2.6.x |
| **Navigation** | auto_route | 9.3.x |
| **Local Storage** | Hive | 2.2.x |
| **Code Quality** | very_good_analysis | 7.x |
| **Min Android API** | 24 (Android 7.0 Nougat) | — |
| **Target API** | 34 (Android 14) | — |
| **Compile SDK** | 36 | — |

---

## 📐 Architecture

The project follows a **Feature-First Clean Architecture** with two distinct
layers: a Flutter UI layer and a Kotlin native services layer.

### Flutter Layer (Feature-First)

```
lib/
├── main.dart                              # App entry + ProviderScope
├── core/
│   ├── constants/
│   │   └── channel_constants.dart         # MethodChannel/EventChannel names
│   ├── router/
│   │   ├── app_router.dart                # @AutoRouterConfig — route tree
│   │   └── shell_view.dart                # Bottom navigation shell
│   ├── services/
│   │   ├── native_bridge_service.dart      # Type-safe MethodChannel wrapper
│   │   └── log_stream_service.dart         # EventChannel → Stream<String>
│   └── theme/
│       ├── app_colors.dart                 # Dark theme color palette
│       └── app_theme.dart                  # MaterialApp theme config
├── product/
│   ├── models/
│   │   ├── payload_action.dart             # Freezed union type (12 actions)
│   │   ├── service_status.dart             # Enum: idle/armed/running/error
│   │   └── permission_state.dart           # Freezed: 4x permission booleans
│   └── widgets/
│       ├── status_badge.dart               # Colored status indicator
│       └── permission_tile.dart            # Grant/Denied permission row
└── features/
    ├── dashboard/                          # Main control center
    │   ├── domain/entities/
    │   │   └── dashboard_state.dart
    │   └── presentation/
    │       ├── dashboard_controller.dart    # ARM/DISARM logic
    │       ├── dashboard_view.dart
    │       └── dashboard_widgets.dart
    ├── permissions/presentation/           # 4-permission grant flow
    │   ├── permissions_controller.dart
    │   └── permissions_view.dart
    ├── payload_builder/presentation/       # Visual action sequence builder
    │   ├── payload_builder_controller.dart  # CRUD + JSON export
    │   ├── payload_builder_view.dart
    │   └── payload_builder_widgets.dart
    ├── scheduler/presentation/             # Alarm scheduling
    │   ├── scheduler_controller.dart
    │   ├── scheduler_view.dart
    │   └── scheduler_widgets.dart
    └── logs/presentation/                  # Real-time native log viewer
        ├── logs_controller.dart
        └── logs_view.dart
```

### Kotlin Native Layer

```
android/app/src/main/kotlin/com/ghosttraffic/ghost_traffic_lab/
├── MainActivity.kt              # Flutter↔Kotlin bridge setup
├── MethodCallDispatcher.kt      # Routes all MethodChannel calls
├── PermissionChecker.kt         # Permission check + Settings intents
├── models/
│   └── PayloadAction.kt         # Sealed class: Wait/Swipe/Click/Launch/TypeText/OpenUrl/etc. (12 total)
├── engine/
│   ├── PayloadEngine.kt         # Coroutine-based sequential action orchestrator
│   ├── ActionExecutor.kt        # Handlers for 12 distinct action types
│   └── humanlike/               # Anti-detection behavior engine
│       ├── GaussianDelay.kt     # Normal distribution random delays
│       ├── BezierGesture.kt     # Cubic bezier swipe path generator
│       ├── MicroTremor.kt       # Position jitter + pre-click delay
│       └── SessionFingerprint.kt # Unique-per-session behavior profile
├── services/
│   ├── BotService.kt            # Foreground Service (specialUse type)
│   ├── ClickerService.kt        # AccessibilityService (gestures/clicks)
│   ├── DeviceWaker.kt           # WakeLock + keyguard dismiss
│   ├── GestureExecutor.kt       # GestureDescription builder
│   ├── LogBroadcaster.kt        # Native→Flutter log bridge
│   └── NotificationHelper.kt    # Notification channel + builder
└── scheduling/
    ├── AlarmScheduler.kt         # setExactAndAllowWhileIdle
    └── AlarmReceiver.kt          # BroadcastReceiver → BotService trigger
```

---

## 🧠 Human-Like Behavior Engine

A key feature that makes interactions appear natural and avoids bot detection.

### Components

| Component | What It Does | Parameters |
|-----------|-------------|-----------|
| **GaussianDelay** | Replaces fixed delays with normally-distributed random ones | μ=3s, σ=0.8s, clamped [1s–7s] |
| **BezierGesture** | Generates cubic bezier curve paths instead of straight-line swipes | ±40px random control points, 200–600ms duration |
| **MicroTremor** | Simulates natural hand tremor before clicks | ±8px position offset, 50–150ms pre-click delay |
| **SessionFingerprint** | Creates a unique behavioral profile per session | `System.nanoTime()` seed → deterministic but unique |

### How It Works

```
Session Start → SessionFingerprint.create()
                    ├── GaussianDelay(seed)    ← unique delay distribution
                    ├── BezierGesture(seed+1)  ← unique swipe curves
                    └── MicroTremor(seed+2)    ← unique tremor pattern

Action Execution:
  Click → MicroTremor.preClickDelay → service.clickByText()
  Swipe → BezierGesture.createSwipePath() → dispatchGesture()
  Wait  → GaussianDelay.nextDelay()
```

---

## 🔐 Required Permissions

| Permission | Purpose | How |
|-----------|---------|-----|
| **Accessibility Service** | Read UI elements, perform clicks/swipes | System Settings → Accessibility |
| **Draw Over Other Apps** | Start activities from background | `ACTION_MANAGE_OVERLAY_PERMISSION` |
| **Ignore Battery Opt.** | Keep service alive in Doze mode | `REQUEST_IGNORE_BATTERY_OPTIMIZATIONS` |
| **Exact Alarm** | Schedule precise wake-up triggers | `ACTION_REQUEST_SCHEDULE_EXACT_ALARM` |

---

## 🔄 Communication Flow

```
┌──────────────────┐    MethodChannel     ┌───────────────────┐
│  Flutter UI       │ ←──────────────────→ │  MethodCallDispatcher │
│  (Riverpod)       │  "lab/control"       │  (Kotlin)              │
└──────────────────┘                      └───────────────────┘
        │                                          │
        │ EventChannel                             ├─→ PermissionChecker
        │ "lab/logs"                               ├─→ BotService
        ▼                                          ├─→ AlarmScheduler
┌──────────────────┐                               │
│  LogsView         │ ← LogBroadcaster ← ─────────┘
│  (real-time)      │
└──────────────────┘
```

---

## 🚀 Getting Started

### Prerequisites

- [FVM](https://fvm.app) (Flutter Version Management)
- Android SDK 36+
- Physical Android device (API 24+) for testing

### Install & Build

```bash
# Clone
git clone https://github.com/your-repo/ghost-traffic-lab.git
cd ghost-traffic-lab

# Flutter setup
fvm install
fvm flutter pub get

# Generate code (Freezed, Riverpod, auto_route)
fvm flutter pub run build_runner build --delete-conflicting-outputs

# Build debug APK
fvm flutter build apk --debug

# Install on device
fvm flutter install
```

### Run Tests & Automation

```bash
# Emulator Auto-Setup (Grants permissions & installs APK)
./scripts/setup_emulator.fish

# Direct Headless Engine Test (via ADB)
./scripts/test_engine.fish

# E2E UI Integration Test (Runs on Emulator)
fvm flutter test integration_test/bot_e2e_test.dart -d emulator-5554

# Unit Tests & Analysis
fvm flutter test           # 17 unit tests
fvm flutter analyze        # Static analysis (0 issues)
```

---

## 📱 App Screens

| Screen | Description |
|--------|-------------|
| **Dashboard** | System status (idle/armed/running), permission summary, ARM/DISARM button |
| **Payload Builder** | Visual drag-and-drop action sequence builder with JSON export |
| **Scheduler** | Time picker + target package selection for alarm-based triggers |
| **Logs** | Real-time monospace log viewer with auto-scroll |
| **Permissions** | 4-permission checklist with grant buttons |

---

## 🏛️ Design Principles

- **Micro-Modular Architecture** — Every file < 100 lines, every function < 20 lines
- **Feature-First** — Each feature is self-contained with its own controller/view
- **Single Responsibility** — One class, one job, one file
- **Composition over Inheritance** — Mixin/composition preferred
- **Testable by Design** — All dependencies injectable via Riverpod

---

## ⚖️ License

This project is intended **exclusively for educational and authorized security
research**. The authors are not responsible for any misuse.

**Do NOT use this tool to:**
- Automate interactions on services you don't own
- Generate fraudulent traffic or engagement
- Bypass security measures without authorization
- Violate any terms of service or applicable laws
