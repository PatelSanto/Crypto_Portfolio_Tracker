import 'package:crypto_portfolio_tracker/services/storage_service.dart';
import 'package:get/get.dart';
import '../models/portfolio_item_model.dart';

class PortfolioRepository {
  final StorageService _storage = Get.find();

  /// Get all portfolio items
  Future<List<PortfolioItem>> getPortfolio() async {
    try {
      return await _storage.loadPortfolio();
    } catch (e) {
      throw Exception('Failed to load portfolio: $e');
    }
  }

  /// Save portfolio items
  Future<void> savePortfolio(List<PortfolioItem> items) async {
    try {
      await _storage.savePortfolio(items);
    } catch (e) {
      throw Exception('Failed to save portfolio: $e');
    }
  }

  /// Add or update a portfolio item
  Future<void> addOrUpdateItem(PortfolioItem item) async {
    try {
      final portfolio = await getPortfolio();
      final existingIndex = portfolio.indexWhere(
        (i) => i.coinId == item.coinId,
      );

      if (existingIndex != -1) {
        portfolio[existingIndex] = item;
      } else {
        portfolio.add(item);
      }

      await savePortfolio(portfolio);
    } catch (e) {
      throw Exception('Failed to add/update portfolio item: $e');
    }
  }

  /// Remove a portfolio item
  Future<void> removeItem(String coinId) async {
    try {
      final portfolio = await getPortfolio();
      portfolio.removeWhere((item) => item.coinId == coinId);
      await savePortfolio(portfolio);
    } catch (e) {
      throw Exception('Failed to remove portfolio item: $e');
    }
  }

  /// Clear entire portfolio
  Future<void> clearPortfolio() async {
    try {
      await _storage.savePortfolio([]);
    } catch (e) {
      throw Exception('Failed to clear portfolio: $e');
    }
  }
}
