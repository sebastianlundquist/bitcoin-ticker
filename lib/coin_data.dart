import 'dart:convert';
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

const List<String> cryptoList = [
  'BTC',
  'ETH',
  'LTC',
];

const url = 'https://apiv2.bitcoinaverage.com/indices/global/ticker';

class CoinData {
  Future getCoinData(String currency) async {
    Map<String, String> prices = {};
    for (String crypto in cryptoList) {
      http.Response response = await http.get('$url/$crypto$currency');
      if (response.statusCode == 200) {
        var decodedData = jsonDecode(response.body);
        double price = decodedData['last'];
        prices[crypto] = price.toStringAsFixed(2);
      } else {
        print(response.statusCode);
        throw 'Get request unsuccessful.';
      }
    }
    return prices;
  }
}
