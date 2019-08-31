import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'coin_data.dart';
import 'dart:io' show Platform;

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String selectedCurrency = currenciesList
      .firstWhere((currency) => currency.contains('SEK'), orElse: () => null);
  Map<String, String> coinValues = {};
  bool isWaiting = false;

  DropdownButton<String> androidDropdown() {
    var list = List<DropdownMenuItem<String>>();
    for (String currency in currenciesList) {
      list.add(DropdownMenuItem(child: Text(currency), value: currency));
    }
    return DropdownButton<String>(
      items: list,
      value: selectedCurrency,
      onChanged: (value) {
        setState(() {
          selectedCurrency = value;
        });
        getData(value);
      },
    );
  }

  CupertinoPicker iOSPicker() {
    var list = List<Text>();
    for (String currency in currenciesList) {
      list.add(Text(currency));
    }
    return CupertinoPicker(
      backgroundColor: Colors.lightBlue,
      itemExtent: 32.0,
      onSelectedItemChanged: (selectedIndex) {
        getData((currenciesList[selectedIndex]));
      },
      children: list,
    );
  }

  void getData(String currency) async {
    isWaiting = true;
    try {
      var data = await CoinData().getCoinData(currency);
      isWaiting = false;
      setState(() {
        coinValues = data;
      });
    } catch (e) {
      print(e);
    }
  }

  Column makeCards() {
    List<CryptoCard> cryptoCards = [];
    for (String crypto in cryptoList) {
      cryptoCards.add(CryptoCard(
        value: isWaiting ? '?' : coinValues[crypto],
        crypto: crypto,
        currency: selectedCurrency,
      ));
    }
    return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch, children: cryptoCards);
  }

  @override
  void initState() {
    super.initState();
    getData(selectedCurrency);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('🤑 Coin Ticker'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
              padding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0),
              child: makeCards()),
          Container(
              height: 150.0,
              alignment: Alignment.center,
              padding: EdgeInsets.only(bottom: 32.0),
              color: Colors.lightBlue,
              child: Platform.isIOS ? iOSPicker() : androidDropdown()),
        ],
      ),
    );
  }
}

class CryptoCard extends StatelessWidget {
  const CryptoCard({this.value, this.currency, this.crypto});

  final String value;
  final String currency;
  final String crypto;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0),
      child: Card(
        color: Colors.lightBlueAccent,
        elevation: 8.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0),
          child: Text(
            '1 $crypto = $value $currency',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20.0,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
