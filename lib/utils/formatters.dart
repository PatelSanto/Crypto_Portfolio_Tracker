import 'package:intl/intl.dart';

class AppFormatters {
  /// Format currency with symbol
  static String formatCurrency(
    double value, {
    String symbol = '\$',
    int decimals = 2,
  }) {
    final formatter = NumberFormat.currency(
      symbol: symbol,
      decimalDigits: decimals,
    );
    return formatter.format(value);
  }

  /// Format number with abbreviations (K, M, B)
  static String formatNumberCompact(double value) {
    if (value >= 1000000000) {
      return '\$${(value / 1000000000).toStringAsFixed(2)}B';
    } else if (value >= 1000000) {
      return '\$${(value / 1000000).toStringAsFixed(2)}M';
    } else if (value >= 1000) {
      return '\$${(value / 1000).toStringAsFixed(2)}K';
    } else {
      return formatCurrency(value);
    }
  }

  /// Format quantity (remove trailing zeros)
  static String formatQuantity(double quantity) {
    final formatter = NumberFormat('#,##0.########');
    return formatter.format(quantity);
  }

  /// Format percentage
  static String formatPercentage(double value, {int decimals = 2}) {
    final formatter = NumberFormat.decimalPercentPattern(
      decimalDigits: decimals,
    );
    return formatter.format(value / 100);
  }

  /// Format price with appropriate decimals
  static String formatPrice(double price) {
    if (price >= 1000) {
      return formatCurrency(price, decimals: 2);
    } else if (price >= 1) {
      return formatCurrency(price, decimals: 4);
    } else {
      return formatCurrency(price, decimals: 6);
    }
  }
}
