import 'dart:convert';
import 'package:coin_tracker/constants.dart';
import 'package:coin_tracker/models/coin_model.dart';
import 'package:http/http.dart' as http;

const List<String> currenciesList = [
  'AUD',
  'BRL',
  'CAD',
  'CNY',
  'EUR',
  'GBP',
  'HKD',
  'IDR',
  'ILS',
  'INR',
  'JPY',
  'MXN',
  'NOK',
  'NZD',
  'PLN',
  'RON',
  'RUB',
  'SEK',
  'SGD',
  'USD',
  'ZAR'
];

class CoinData {
  Future<List<CoinModel>> getCoinData(String currency) async {
    List<String> cryptoList = ['BTC/Bitcoin', 'ETH/Ethereum', 'LTC/Litecoin'];
    List<CoinModel> cryptoPrices = [];

    for (var crypto in cryptoList) {
      final symbol = crypto.split('/')[0];
      final url = Uri.parse('$kBaseURL/$symbol/$currency');
      final response = await http.get(
        url,
        headers: {
          'X-CoinAPI-Key': kAPIKey,
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final rate = double.tryParse(data['rate'].toString()) ?? 0.0;

        CoinModel coin = CoinModel(
          icon: symbol,
          name: crypto.split('/')[1],
          price: rate,
        );

        cryptoPrices.add(coin);
      } else {
        print(
            'Failed to fetch exchange rate for $crypto. Status code: ${response.statusCode}');
      }
    }
    return cryptoPrices;
  }
}
