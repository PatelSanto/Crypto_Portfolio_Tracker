import 'dart:async';
import 'package:get/get.dart';
import '../models/portfolio_item_model.dart';
import '../repositories/coin_repository.dart';
import '../repositories/portfolio_repository.dart';

enum SortOption { name, value, quantity, symbol }

class PortfolioController extends GetxController {
  final PortfolioRepository _portfolioRepository = Get.find();
  final CoinRepository _coinRepository = Get.find();

  final RxList<PortfolioItem> portfolioItems = <PortfolioItem>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isRefreshing = false.obs;
  final RxString errorMessage = ''.obs;
  final RxDouble totalPortfolioValue = 0.0.obs;
  Timer? _priceUpdateTimer;
  final RxInt refreshInterval = 5.obs; // minutes
  final RxBool autoRefreshEnabled = true.obs;
  final Rx<SortOption> currentSort = SortOption.value.obs;
  final RxBool isSortAscending = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadPortfolio();
    _ensureCoinsLoaded();
    _startPeriodicPriceUpdates();
  }

  void _startPeriodicPriceUpdates() {
    if (!autoRefreshEnabled.value) return;

    _priceUpdateTimer?.cancel();
    _priceUpdateTimer = Timer.periodic(
      Duration(minutes: refreshInterval.value),
      (timer) {
        fetchPrices();
      },
    );
  }

  void stopPeriodicUpdates() {
    _priceUpdateTimer?.cancel();
    autoRefreshEnabled.value = false;
  }

  void startPeriodicUpdates() {
    autoRefreshEnabled.value = true;
    _startPeriodicPriceUpdates();
  }

  void setRefreshInterval(int minutes) {
    refreshInterval.value = minutes;
    if (autoRefreshEnabled.value) {
      _startPeriodicPriceUpdates();
    }
  }

  @override
  void onClose() {
    _priceUpdateTimer?.cancel();
    super.onClose();
  }

  void sortPortfolio(SortOption option) {
    if (currentSort.value == option) {
      // Toggle ascending/descending
      isSortAscending.value = !isSortAscending.value;
    } else {
      currentSort.value = option;
      isSortAscending.value = true;
    }

    switch (option) {
      case SortOption.name:
        portfolioItems.sort(
          (a, b) => isSortAscending.value
              ? a.coinName.compareTo(b.coinName)
              : b.coinName.compareTo(a.coinName),
        );
        break;
      case SortOption.value:
        portfolioItems.sort(
          (a, b) => isSortAscending.value
              ? b.totalValue.compareTo(a.totalValue)
              : a.totalValue.compareTo(b.totalValue),
        );
        break;
      case SortOption.quantity:
        portfolioItems.sort(
          (a, b) => isSortAscending.value
              ? b.quantity.compareTo(a.quantity)
              : a.quantity.compareTo(b.quantity),
        );
        break;
      case SortOption.symbol:
        portfolioItems.sort(
          (a, b) => isSortAscending.value
              ? a.coinSymbol.compareTo(b.coinSymbol)
              : b.coinSymbol.compareTo(a.coinSymbol),
        );
        break;
    }

    portfolioItems.refresh();
  }

  Future<void> _ensureCoinsLoaded() async {
    try {
      await _coinRepository.getCoins();
    } catch (e) {
      print('Error loading coins: $e');
    }
  }

  Future<void> loadPortfolio() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      // Load portfolio from storage
      final items = await _portfolioRepository.getPortfolio();
      portfolioItems.value = items;

      // Fetch current prices
      if (items.isNotEmpty) {
        await fetchPrices();
      } else {
        calculateTotalValue();
      }
    } catch (e) {
      errorMessage.value = 'Failed to load portfolio: ${e.toString()}';
      print('Error loading portfolio: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchPrices() async {
    try {
      if (portfolioItems.isEmpty) return;

      // Get unique coin IDs
      final coinIds = portfolioItems.map((item) => item.coinId).toList();

      // Fetch prices from API
      final prices = await _coinRepository.fetchPrices(coinIds);

      // Update portfolio items with new prices
      for (var item in portfolioItems) {
        if (prices.containsKey(item.coinId)) {
          if (item.currentPrice > 0) {
            item.previousPrice = item.currentPrice;
          }
          item.currentPrice = prices[item.coinId]!;
        }
      }

      // Recalculate total value
      calculateTotalValue();

      // Save updated portfolio
      await _portfolioRepository.savePortfolio(portfolioItems);
    } catch (e) {
      errorMessage.value = 'Failed to fetch prices: ${e.toString()}';
      print('Error fetching prices: $e');
    }
  }

  Future<void> refreshPrices() async {
    try {
      isRefreshing.value = true;
      errorMessage.value = '';
      await fetchPrices();
    } finally {
      isRefreshing.value = false;
    }
  }

  void calculateTotalValue() {
    double total = 0.0;
    for (var item in portfolioItems) {
      total += item.totalValue;
    }
    totalPortfolioValue.value = total;
  }

  Future<void> addAsset(
    String coinId,
    String coinName,
    String coinSymbol,
    double quantity,
  ) async {
    try {
      // Check if coin already exists
      final existingIndex = portfolioItems.indexWhere(
        (item) => item.coinId == coinId,
      );

      if (existingIndex != -1) {
        // Update quantity
        portfolioItems[existingIndex].quantity += quantity;
      } else {
        // Add new item
        final newItem = PortfolioItem(
          coinId: coinId,
          coinName: coinName,
          coinSymbol: coinSymbol,
          quantity: quantity,
          currentPrice: 0.0,
        );
        portfolioItems.add(newItem);
      }

      // Save and fetch prices
      await _portfolioRepository.savePortfolio(portfolioItems);
      await fetchPrices();

      Get.snackbar(
        'Success',
        'Asset added to portfolio',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
    } catch (e) {
      print('Error adding asset: $e');
      Get.snackbar(
        'Error',
        'Failed to add asset: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> removeAsset(int index) async {
    try {
      final item = portfolioItems[index];
      portfolioItems.removeAt(index);

      await _portfolioRepository.savePortfolio(portfolioItems);
      calculateTotalValue();

      Get.snackbar(
        'Removed',
        '${item.coinName} removed from portfolio',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to remove asset: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> updateAssetQuantity(int index, double newQuantity) async {
    try {
      portfolioItems[index].quantity = newQuantity;
      await _portfolioRepository.savePortfolio(portfolioItems);
      calculateTotalValue();
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to update quantity: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}
