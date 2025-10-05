import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/coin_model.dart';

class CoinGeckoApi {
  static const String baseUrl = 'https://api.coingecko.com/api/v3';

  final http.Client _client;

  CoinGeckoApi({http.Client? client}) : _client = client ?? http.Client();

  /// Fetch the complete list of coins
  Future<List<CoinModel>> fetchCoinsList() async {
    try {
      final url = Uri.parse('$baseUrl/coins/list');
      final response = await _client.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        return jsonList.map((json) => CoinModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to fetch coins list: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching coins list: $e');
    }
  }

  /// Fetch current prices for specific coins
  Future<Map<String, double>> fetchPrices(List<String> coinIds) async {
    if (coinIds.isEmpty) {
      return {};
    }

    try {
      final idsString = coinIds.join(',');
      final url = Uri.parse(
        '$baseUrl/simple/price?ids=$idsString&vs_currencies=usd',
      );
      final response = await _client.get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);
        final Map<String, double> prices = {};

        jsonData.forEach((coinId, priceData) {
          if (priceData is Map<String, dynamic> &&
              priceData.containsKey('usd')) {
            prices[coinId] = (priceData['usd'] as num).toDouble();
          }
        });

        return prices;
      } else {
        throw Exception('Failed to fetch prices: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching prices: $e');
    }
  }

  void dispose() {
    _client.close();
  }
}
