class PortfolioItem {
  final String coinId;
  final String coinName;
  final String coinSymbol;
  double quantity;
  double currentPrice;
  double? previousPrice;

  PortfolioItem({
    required this.coinId,
    required this.coinName,
    required this.coinSymbol,
    required this.quantity,
    this.currentPrice = 0.0,
    this.previousPrice,
  });

  double? get priceChange {
    if (previousPrice == null || previousPrice == 0) return null;
    return ((currentPrice - previousPrice!) / previousPrice!) * 100;
  }

  bool get isPriceUp => priceChange != null && priceChange! > 0;
  bool get isPriceDown => priceChange != null && priceChange! < 0;

  double get totalValue => quantity * currentPrice;

  factory PortfolioItem.fromJson(Map<String, dynamic> json) {
    return PortfolioItem(
      coinId: json['coinId'] as String,
      coinName: json['coinName'] as String,
      coinSymbol: json['coinSymbol'] as String,
      quantity: (json['quantity'] as num).toDouble(),
      currentPrice: (json['currentPrice'] as num?)?.toDouble() ?? 0.0,
      previousPrice: (json['previousPrice'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'coinId': coinId,
      'coinName': coinName,
      'coinSymbol': coinSymbol,
      'quantity': quantity,
      'currentPrice': currentPrice,
      'previousPrice': previousPrice,
    };
  }

  PortfolioItem copyWith({
    String? coinId,
    String? coinName,
    String? coinSymbol,
    double? quantity,
    double? currentPrice,
  }) {
    return PortfolioItem(
      coinId: coinId ?? this.coinId,
      coinName: coinName ?? this.coinName,
      coinSymbol: coinSymbol ?? this.coinSymbol,
      quantity: quantity ?? this.quantity,
      currentPrice: currentPrice ?? this.currentPrice,
    );
  }

  @override
  String toString() {
    return 'PortfolioItem(coinId: $coinId, coinName: $coinName, quantity: $quantity, currentPrice: $currentPrice)';
  }
}
