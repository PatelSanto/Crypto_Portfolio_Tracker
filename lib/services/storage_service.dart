import 'dart:convert';
import 'package:crypto_portfolio_tracker/models/coin_model.dart';
import 'package:crypto_portfolio_tracker/models/portfolio_item_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const String _portfolioKey = 'portfolio';
  static const String _coinsKey = 'coins_list';
  static const String _coinsCacheTimeKey = 'coins_cache_time';

  SharedPreferences? _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  SharedPreferences get prefs {
    if (_prefs == null) {
      throw Exception('StorageService not initialized. Call init() first.');
    }
    return _prefs!;
  }

  // Portfolio Management
  Future<void> savePortfolio(List<PortfolioItem> portfolio) async {
    final jsonList = portfolio.map((item) => item.toJson()).toList();
    final jsonString = json.encode(jsonList);
    await prefs.setString(_portfolioKey, jsonString);
  }

  Future<List<PortfolioItem>> loadPortfolio() async {
    final jsonString = prefs.getString(_portfolioKey);
    if (jsonString == null || jsonString.isEmpty) {
      return [];
    }

    try {
      final List<dynamic> jsonList = json.decode(jsonString);
      return jsonList.map((json) => PortfolioItem.fromJson(json)).toList();
    } catch (e) {
      print('Error loading portfolio: $e');
      return [];
    }
  }

  // Coins List Management
  Future<void> saveCoins(List<CoinModel> coins) async {
    final jsonList = coins.map((coin) => coin.toJson()).toList();
    final jsonString = json.encode(jsonList);
    await prefs.setString(_coinsKey, jsonString);
    await prefs.setInt(
      _coinsCacheTimeKey,
      DateTime.now().millisecondsSinceEpoch,
    );
  }

  Future<List<CoinModel>> loadCoins() async {
    final jsonString = prefs.getString(_coinsKey);
    if (jsonString == null || jsonString.isEmpty) {
      return [];
    }

    try {
      final List<dynamic> jsonList = json.decode(jsonString);
      return jsonList.map((json) => CoinModel.fromJson(json)).toList();
    } catch (e) {
      print('Error loading coins: $e');
      return [];
    }
  }

  Future<bool> hasCachedCoins() async {
    final jsonString = prefs.getString(_coinsKey);
    if (jsonString == null || jsonString.isEmpty) {
      return false;
    }

    // Check if cache is expired (older than 24 hours)
    final cacheTime = prefs.getInt(_coinsCacheTimeKey);
    if (cacheTime == null) {
      return false;
    }

    final cacheDate = DateTime.fromMillisecondsSinceEpoch(cacheTime);
    final now = DateTime.now();
    final difference = now.difference(cacheDate);

    return difference.inHours < 24;
  }

  // Clear all data
  Future<void> clearAll() async {
    await prefs.clear();
  }
}
