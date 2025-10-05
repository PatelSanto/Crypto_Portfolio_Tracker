class PriceData {
  final String coinId;
  final double usd;

  PriceData({required this.coinId, required this.usd});

  factory PriceData.fromJson(String coinId, Map<String, dynamic> json) {
    return PriceData(coinId: coinId, usd: (json['usd'] as num).toDouble());
  }

  @override
  String toString() => 'PriceData(coinId: $coinId, usd: $usd)';
}
