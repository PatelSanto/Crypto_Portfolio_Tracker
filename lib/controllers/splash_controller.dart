import 'package:crypto_portfolio_tracker/repositories/coin_repository.dart';
import 'package:crypto_portfolio_tracker/routes/app_routes.dart';
import 'package:crypto_portfolio_tracker/services/storage_service.dart';
import 'package:get/get.dart';
import '../services/coin_search_service.dart';

class SplashController extends GetxController {
  final CoinRepository _coinRepository = Get.find();
  final StorageService _storageService = Get.find();
  final CoinSearchService _searchService = Get.find();

  final RxBool isLoading = true.obs;
  final RxString loadingMessage = 'Initializing...'.obs;

  @override
  void onInit() {
    super.onInit();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    try {
      await Future.delayed(const Duration(seconds: 2));
      final hasCachedCoins = await _storageService.hasCachedCoins();

      if (!hasCachedCoins) {
        loadingMessage.value = 'Loading Cryptocurrency Data...';
        await _coinRepository.fetchAndCacheCoins();
      } else {
        loadingMessage.value = 'Loading Your Coins...';
        final coins = await _storageService.loadCoins();
        if (coins.isNotEmpty) {
          _searchService.initializeCoins(coins);
        }
      }

      Get.offAllNamed(Routes.PORTFOLIO);
    } catch (e) {
      Get.offAllNamed(Routes.PORTFOLIO);
    }
  }
}
