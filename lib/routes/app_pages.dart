import 'package:crypto_portfolio_tracker/screens/portfolio_screen.dart';
import 'package:crypto_portfolio_tracker/screens/splash_screen.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';
import '../bindings/portfolio_binding.dart';
import '../bindings/splash_binding.dart';
import 'app_routes.dart';

class AppPages {
  static final pages = [
    GetPage(
      name: Routes.SPLASH,
      page: () => const SplashScreen(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: Routes.PORTFOLIO,
      page: () => const PortfolioScreen(),
      binding: PortfolioBinding(),
    ),
  ];
}
