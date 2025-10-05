# Crypto Portfolio Tracker

A Flutter application to track cryptocurrency portfolios with real-time prices from **CoinGecko API**.

## Features
* Real-time cryptocurrency price tracking
* Add/remove assets from portfolio
* Local data persistence
* Pull-to-refresh functionality
* Efficient coin search
* Clean, modern UI with animations

## Setup Instructions

### Prerequisites
* Flutter SDK (3.0+)
* Android Studio / VS Code
* Android device or emulator

### Installation

# Clone the repository
git clone [your-repo-url]
cd crypto_portfolio_tracker

# Install dependencies
flutter pub get

# Run the app
flutter run

## Architecture

* **State Management:** GetX
* **Local Storage:** SharedPreferences
* **API:** CoinGecko API (Free Tier)
* **Pattern:** Repository Pattern

## 📚 Libraries Used

* `get: ^4.6.6` → State management & navigation
* `http: ^1.2.0` → API calls
* `shared_preferences: ^2.2.2` → Local persistence
* `intl: ^0.19.0` → Number & currency formatting
* `flutter_slidable: ^3.0.1` → Swipe actions

## Project Structure
```
lib/
 ├─ bindings/        # Dependency injections
 ├─ controllers/     # GetX controllers
 ├─ models/          # Data models
 ├─ providers/       # API providers
 ├─ repositories/    # Repository layer
 ├─ routes/          # App routes
 ├─ screens/         # UI screens
 ├─ services/        # Core services
 ├─ themes/          # App themes & styles
 ├─ utils/           # Utilities & helpers
 ├─ widgets/         # Reusable widgets
 └─ main.dart        # Entry point
```

## Demo Video

Upload your demo video to **YouTube / Google Drive** and paste the link here:
[Watch Demo](https://your-video-link.com)

## 📱 APK Download

Upload the APK to **Google Drive / GitHub Releases** and add the link:
[Download APK](https://your-apk-link.com)

