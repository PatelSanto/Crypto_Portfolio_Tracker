import 'package:crypto_portfolio_tracker/services/coin_search_service.dart';
import 'package:crypto_portfolio_tracker/services/storage_service.dart';
import 'package:get/get.dart';
import '../models/coin_model.dart';
import '../providers/coin_gecko_api.dart';

class CoinRepository {
  final CoinGeckoApi _api = Get.find();
  final StorageService _storage = Get.find();
  final CoinSearchService _searchService = Get.find();

  List<CoinModel>? _cachedCoins;

  /// Fetch coins list from API and cache it
  Future<void> fetchAndCacheCoins() async {
    try {
      final coins = await _api.fetchCoinsList();
      _cachedCoins = coins;

      // Save to storage
      await _storage.saveCoins(coins);

      // Initialize search service
      _searchService.initializeCoins(coins);
    } catch (e) {
      throw Exception('Failed to fetch and cache coins: $e');
    }
  }

  /// Load coins from cache or storage
  Future<List<CoinModel>> getCoins() async {
    if (_cachedCoins != null && _cachedCoins!.isNotEmpty) {
      if (!_searchService.isInitialized) {
        _searchService.initializeCoins(_cachedCoins!);
      }
      return _cachedCoins!;
    }

    // Try to load from storage
    final storedCoins = await _storage.loadCoins();
    if (storedCoins.isNotEmpty) {
      _cachedCoins = storedCoins;
      _searchService.initializeCoins(storedCoins);
      return storedCoins;
    }

    // If not in storage, fetch from API
    await fetchAndCacheCoins();
    return _cachedCoins ?? [];
  }

  /// Fetch current prices for given coin IDs
  Future<Map<String, double>> fetchPrices(List<String> coinIds) async {
    try {
      return await _api.fetchPrices(coinIds);
    } catch (e) {
      throw Exception('Failed to fetch prices: $e');
    }
  }

  /// Search coins by query
  List<CoinModel> searchCoins(String query) {
    if (!_searchService.isInitialized) {
      getCoins();
      return [];
    }
    return _searchService.searchCoins(query);
  }
}
