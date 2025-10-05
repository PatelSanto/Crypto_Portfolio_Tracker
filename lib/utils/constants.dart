class AppConstants {
  // API
  static const String coinGeckoBaseUrl = 'https://api.coingecko.com/api/v3';
  static const String coinsListEndpoint = '/coins/list';
  static const String simplePriceEndpoint = '/simple/price';

  // Storage Keys
  static const String portfolioKey = 'portfolio';
  static const String coinsKey = 'coins_list';
  static const String coinsCacheTimeKey = 'coins_cache_time';

  // Cache Duration
  static const int coinsCacheDurationHours = 24;

  // UI
  static const Duration splashDuration = Duration(seconds: 3);
  static const Duration animationDuration = Duration(milliseconds: 300);

  // Limits
  static const int maxSearchResults = 50;
  static const int searchPrefixLength = 10;
}
