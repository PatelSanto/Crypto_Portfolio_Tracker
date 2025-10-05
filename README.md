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

## Libraries Used

* `get: ^4.7.2` → State management & navigation
* `http: ^1.5.0` → API calls
* `shared_preferences: ^2.5.3` → Local persistence
* `intl: ^0.20.2` → Number & currency formatting
* `flutter_slidable: ^4.0.3` → Swipe actions

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
[Watch Demo]([https://your-video-link.com](https://drive.google.com/file/d/1gIODdOR9dvRrPZzTRxYuxRnANMSrWzWy/view?usp=sharing))

## APK Download
[Download APK]([https://your-apk-link.com](https://drive.google.com/file/d/168LMBW6RrlfqXF9wOlRZUf4I-dFNZv0l/view?usp=sharing))

