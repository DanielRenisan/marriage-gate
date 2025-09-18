# Matrimoney App

Enterprise-level matrimony mobile app built with Flutter 3.24.3, designed for scalability, maintainability, and user engagement.

## Features
- Clean architecture (presentation, domain, data layers)
- Riverpod for state management
- RESTful API integration (dio, JWT auth)
- Authentication: Email, mobile OTP, Google, Facebook (Firebase)
- Real-time chat (SignalR-ready)
- Push notifications (FCM, local)
- Localization: English & Tamil (intl, flutter_localizations)
- Light/dark/system themes (persisted)
- Profile creation/editing, verification, private photos
- Matching: swipe UI, filters, geolocation
- Monetization: in-app purchases
- Deep linking, analytics, crash reporting
- Offline support, accessibility, GDPR/CCPA compliance

## Technology Stack
- **Flutter 3.24.3** (Material 3)
- **State Management:** Riverpod
- **Networking:** dio, retrofit
- **Local Storage:** hive, flutter_secure_storage
- **Authentication:** Firebase Auth, Google, Facebook
- **Chat:** SignalR (web_socket_channel)
- **Notifications:** FCM, flutter_local_notifications
- **Localization:** intl, flutter_localizations
- **Theming:** ThemeData, Riverpod
- **Other:** cached_network_image, uni_links, in_app_purchase, geolocator, image_picker, firebase_analytics, sentry

## Project Structure
```
lib/
  core/           # Common utilities, constants, errors
  data/           # Data sources, models, repositories (API, local)
  domain/         # Entities, use cases, repository interfaces
  presentation/   # UI, screens, widgets, Riverpod providers, viewmodels
  l10n/           # Localization files (.arb)
  main.dart       # App entry point
```

## Getting Started
1. **Clone the repo:**
   ```sh
   git clone <repo-url>
   cd matrimoney_app
   ```
2. **Install dependencies:**
   ```sh
   flutter pub get
   ```
3. **Generate localization files:**
   ```sh
   flutter gen-l10n
   ```
4. **Run the app:**
   ```sh
   flutter run
   ```

## Localization
- Edit `lib/l10n/app_en.arb` and `lib/l10n/app_ta.arb` for English and Tamil translations.
- Add more ARB files for additional languages.
- Use `flutter gen-l10n` to regenerate localization code after changes.

## Testing
- **Unit, widget, and integration tests:**
  ```sh
  flutter test
  ```
- Target: 80%+ coverage

## Contributing
- Follow clean architecture and best practices
- Use Riverpod for state management
- Write tests for new features
- Submit pull requests with clear descriptions

## License
[MIT](LICENSE)
