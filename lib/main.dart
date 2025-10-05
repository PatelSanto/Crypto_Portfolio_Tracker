import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'providers/coin_gecko_api.dart';
import 'repositories/coin_repository.dart';
import 'repositories/portfolio_repository.dart';
import 'routes/app_pages.dart';
import 'routes/app_routes.dart';
import 'services/coin_search_service.dart';
import 'services/storage_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Set system UI overlay style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );

  // Initialize services
  await initServices();

  runApp(const MyApp());
}

/// Initialize all services and dependencies
Future<void> initServices() async {
  // Storage Service
  final storageService = StorageService();
  await storageService.init();
  Get.put(storageService);

  // Coin Search Service
  Get.put(CoinSearchService());

  // API Provider
  Get.put(CoinGeckoApi());

  // Repositories
  Get.put(CoinRepository());
  Get.put(PortfolioRepository());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Crypto Portfolio Tracker',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.purple,
        scaffoldBackgroundColor: const Color(0xFF1E1E2E),
        fontFamily: 'Roboto',
      ),
      initialRoute: Routes.SPLASH,
      getPages: AppPages.pages,
    );
  }
}
