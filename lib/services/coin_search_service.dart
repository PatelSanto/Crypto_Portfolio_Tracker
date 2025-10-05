import 'package:crypto_portfolio_tracker/models/coin_model.dart';

class CoinSearchService {
  final Map<String, CoinModel> _coinsById = {};
  final Map<String, List<CoinModel>> _coinsBySymbol = {};
  final Map<String, List<CoinModel>> _coinsByNamePrefix = {};

  /// Initialize the search service with coins list
  void initializeCoins(List<CoinModel> coins) {
    _coinsById.clear();
    _coinsBySymbol.clear();
    _coinsByNamePrefix.clear();

    for (var coin in coins) {
      // By ID
      _coinsById[coin.id.toLowerCase()] = coin;

      // By Symbol
      final symbol = coin.symbol.toLowerCase();
      _coinsBySymbol.putIfAbsent(symbol, () => []).add(coin);

      // By Name Prefix (for autocomplete)
      final name = coin.name.toLowerCase();
      for (int i = 1; i <= name.length && i <= 10; i++) {
        final prefix = name.substring(0, i);
        _coinsByNamePrefix.putIfAbsent(prefix, () => []).add(coin);
      }
    }
  }

  /// Search coins by query (name or symbol)
  List<CoinModel> searchCoins(String query) {
    if (query.isEmpty) {
      return [];
    }

    final queryLower = query.toLowerCase().trim();
    final Set<CoinModel> results = {};

    // Exact symbol match
    if (_coinsBySymbol.containsKey(queryLower)) {
      results.addAll(_coinsBySymbol[queryLower]!);
    }

    // Exact ID match
    if (_coinsById.containsKey(queryLower)) {
      results.add(_coinsById[queryLower]!);
    }

    // Name prefix match
    if (_coinsByNamePrefix.containsKey(queryLower)) {
      results.addAll(_coinsByNamePrefix[queryLower]!);
    }

    // Fallback: Linear search for partial matches
    if (results.isEmpty) {
      for (var coin in _coinsById.values) {
        if (coin.name.toLowerCase().contains(queryLower) ||
            coin.symbol.toLowerCase().contains(queryLower)) {
          results.add(coin);
          if (results.length >= 100) break;
        }
      }
    }

    // Sort results by relevance
    final resultsList = results.toList();
    resultsList.sort((a, b) {
      // Exact matches first
      final aExact =
          a.symbol.toLowerCase() == queryLower ||
          a.name.toLowerCase() == queryLower;
      final bExact =
          b.symbol.toLowerCase() == queryLower ||
          b.name.toLowerCase() == queryLower;

      if (aExact && !bExact) return -1;
      if (!aExact && bExact) return 1;

      // Then by name
      return a.name.compareTo(b.name);
    });

    return resultsList;
  }

  /// Get coin by ID
  CoinModel? getCoinById(String id) {
    return _coinsById[id.toLowerCase()];
  }

  /// Get total number of coins
  int get totalCoins => _coinsById.length;

  /// Check if initialized
  bool get isInitialized => _coinsById.isNotEmpty;
}
