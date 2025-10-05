# Crypto Portfolio Tracker

A Flutter application to track cryptocurrency portfolios with real-time prices from CoinGecko API.

## Features
- Real-time cryptocurrency price tracking
- Add/remove assets from portfolio
- Local data persistence
- Pull-to-refresh functionality
- Efficient coin search
- Clean, modern UI with animations

## Setup Instructions

### Prerequisites
- Flutter SDK (3.0+)
- Android Studio / VS Code
- Android device or emulator

### Installation
1. Clone the repository
git clone [your-repo-url]
cd crypto_portfolio_tracker

2. Install dependencies
flutter pub get

3. Run the app
flutter run


## Architecture
- **State Management:** GetX
- **Local Storage:** SharedPreferences
- **API:** CoinGecko API (Free Tier)
- **Architecture Pattern:** Repository Pattern

## Libraries Used
- get: ^4.6.6 - State management and navigation
- http: ^1.2.0 - API calls
- shared_preferences: ^2.2.2 - Local data persistence
- intl: ^0.19.0 - Number and currency formatting
- flutter_slidable: ^3.0.1 - Swipe actions

## Project Structure
- /lib
  - /app - Routes and bindings
  - /core - Services and utilities
  - /data - Models, API providers, repositories
  - /modules - Feature modules (splash, portfolio)

## Demo
[Link to video demo]

## APK Download
[Link to APK file]

## Developer
[Your Name]