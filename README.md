<div align="center">

# مسـار · Massar+

### AI-powered career & academic guidance for Algerian university students

[![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?logo=flutter)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.x-0175C2?logo=dart)](https://dart.dev)
[![License](https://img.shields.io/badge/license-MIT-green)](LICENSE)
[![Platform](https://img.shields.io/badge/platform-Android%20%7C%20iOS-lightgrey)](https://flutter.dev)

</div>

---

## ✨ Overview

**Massar+** (مسار — Arabic for *path/journey*) is a Flutter mobile application designed to help Algerian high school graduates and university students navigate the complex landscape of higher education and career choices.

The app collects a rich profile from each student through a guided 5-step onboarding flow, then uses that data to surface personalised:

- Career path recommendations with match scores
- Subject performance matrices
- Skills gap analysis with priority rankings
- Internship opportunities in Algeria
- Weekly personalised study plans
- An AI chat assistant for academic guidance

---

## 📱 Screenshots

> *Coming soon — run the app locally to explore the UI.*

---

## 🏗️ Architecture

```
lib/
├── data/                   # Static datasets
│   ├── domains.dart        # Interest domains & work style options
│   ├── subjects.dart       # Academic subjects (Bac streams)
│   └── wilayas.dart        # All 58 Algerian wilayas (AR + FR names) + communes
│
├── l10n/                   # Localisation (ARB files)
│   ├── app_ar.arb          # عربية — Arabic (RTL)
│   ├── app_fr.arb          # Français — French
│   └── app_en.arb          # English
│
├── models/
│   └── onboarding_state.dart   # Full student profile model (copyWith, JSON)
│
├── providers/
│   ├── onboarding_provider.dart  # Riverpod StateNotifier — profile + persistence
│   ├── locale_provider.dart      # Language selection (AR / FR / EN)
│   └── theme_provider.dart       # Dark / Light mode toggle
│
├── screens/
│   ├── onboarding/
│   │   ├── welcome_screen.dart
│   │   ├── language_screen.dart
│   │   ├── step1_personal_screen.dart   # Name, birth year, gender, wilaya
│   │   ├── step2_academic_screen.dart   # Bac stream, average, subjects
│   │   ├── step3_interests_screen.dart  # Domains, work style, goals
│   │   ├── step4_location_screen.dart   # Home wilaya, transport, relocation
│   │   ├── step5_preferences_screen.dart # Study hours, learning style
│   │   └── processing_screen.dart       # Loading / plan generation
│   │
│   └── home/
│       ├── home_screen.dart        # PageView shell with bottom nav
│       ├── chat_screen.dart        # AI assistant tab
│       ├── guide_screen.dart       # Guidance tools tab
│       ├── profile_screen.dart     # Profile tab (editable, resume CTA)
│       ├── career_path_screen.dart # Top career matches + timeline
│       ├── subject_matrix_screen.dart  # Score cards by subject
│       ├── skills_gap_screen.dart  # Ring chart + gap priority rows
│       ├── internship_screen.dart  # Internship listings by domain
│       └── study_plan_screen.dart  # Weekly personalised schedule
│
├── theme/
│   └── app_theme.dart      # Design tokens, light & dark themes
│
├── widgets/
│   └── onboarding/         # Reusable glass-morphism form widgets
│       ├── glass_dropdown.dart       # Searchable dropdown with glassmorphism
│       ├── glass_chip_selector.dart  # Multi-select chip grid
│       ├── glass_radio_cards.dart    # Single-select icon cards
│       ├── glass_slider_field.dart   # Labelled slider
│       ├── glass_text_field.dart     # Styled text input
│       ├── glass_toggle_card.dart    # Toggle switch row
│       ├── onboarding_scaffold.dart  # Animated scaffold with continue button
│       ├── progress_bar.dart         # Step progress indicator
│       └── skip_button.dart
│
├── router.dart             # GoRouter route table
└── main.dart               # App entry point
```

---

## 🌟 Features

### Onboarding Flow
- **5-step guided wizard** collecting: personal info, academic background, interests, location preferences, and study habits
- **Resume mode** — if a user leaves mid-onboarding, their profile CTA in the app takes them exactly where they stopped. Skip/back during resume returns immediately to profile without disrupting the stack
- **Persistent state** — every field is auto-saved to `SharedPreferences` so nothing is lost on restart
- **Locale-aware wilaya picker** — shows Arabic names (أدرار, الجزائر…) when the app language is Arabic, French names otherwise

### Home Tabs (seamless swipe)
| Tab | Description |
|-----|-------------|
| 🏠 Home | Dashboard with service cards, quick stats, article carousel |
| 💬 Chat | AI guidance assistant with suggested prompts |
| 🗺️ Guide | Curated tools — career path, internships, study plan |
| 👤 Profile | Editable profile, progress tracker, theme & language settings |

### Personalisation Screens
| Screen | What it shows |
|--------|--------------|
| Career Path | Top-match career with % score, 3 alternatives, career timeline steps |
| Subject Matrix | Score cards per subject, filterable by All / Strong / Weak |
| Skills Gap | Ring chart, acquired skills, gap rows with priority badges |
| Internship Finder | Domain-filtered listings with location/stipend/requirements |
| Study Plan | Week progress bar, day carousel (today highlighted), subject breakdown |

### Design
- **Dark & Light mode** — fully themed, toggle from profile
- **Glassmorphism UI** with `BackdropFilter` blur, gradient borders, glow shadows
- **RTL / LTR** — auto-switches based on locale, full Arabic support
- **Micro-animations** via `flutter_animate` throughout

---

## 🌍 Localisation

The app ships with three locales:

| Language | Code | Direction |
|----------|------|-----------|
| العربية  | `ar` | RTL ← |
| Français | `fr` | LTR → |
| English  | `en` | LTR → |

All UI strings, wilaya names, and error messages are fully translated. ARB files live in `lib/l10n/`.

---

## 🛠️ Tech Stack

| Package | Purpose |
|---------|---------|
| `flutter_riverpod` | State management |
| `go_router` | Declarative navigation with extras for resume mode |
| `shared_preferences` | Local profile persistence |
| `flutter_animate` | Micro-animations |
| `google_fonts` | Outfit font family |
| `fl_chart` | Skills gap ring chart |
| `flutter_localizations` | i18n / l10n scaffolding |
| `intl` | ARB-based string generation |
| `flutter_dotenv` | Environment variable management |

---

## 🚀 Getting Started

### Prerequisites
- Flutter SDK `≥ 3.x`  
- Dart SDK `≥ 3.x`
- Android Studio / VS Code with Flutter extension

### Run locally

```bash
# Clone
git clone https://github.com/anasbenkhelifa/Massar.git
cd Massar

# Install dependencies
flutter pub get

# Generate localisation files
flutter gen-l10n

# Run on a connected device or emulator
flutter run
```

### Build release APK

```bash
flutter build apk --release
```

---

## 📂 Environment Variables

Create a `.env` file at the project root (already in `.gitignore`):

```env
# Add any API keys here (AI backend, etc.)
API_BASE_URL=https://your-api.example.com
```

---

## 🤝 Contributing

1. Fork the repo
2. Create a feature branch: `git checkout -b feat/your-feature`
3. Commit your changes: `git commit -m 'feat: add your feature'`
4. Push to the branch: `git push origin feat/your-feature`
5. Open a Pull Request

---

## 📄 License

This project is licensed under the [MIT License](LICENSE).

---

<div align="center">

Built with ❤️ for Algerian students · صُنع بحب للطلاب الجزائريين

</div>
