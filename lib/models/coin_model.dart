class CoinModel {
  final String id;
  final String symbol;
  final String name;

  CoinModel({required this.id, required this.symbol, required this.name});

  factory CoinModel.fromJson(Map<String, dynamic> json) {
    return CoinModel(
      id: json['id'] as String,
      symbol: json['symbol'] as String,
      name: json['name'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'symbol': symbol, 'name': name};
  }

  @override
  String toString() => 'CoinModel(id: $id, symbol: $symbol, name: $name)';
}
