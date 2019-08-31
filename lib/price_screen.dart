import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'coin_data.dart';
import 'dart:io' show Platform;

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String selectedCurrency = currenciesList.first;
  String btcText = '1 BTC = ? USD';

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
    try {
      double data = await CoinData().getCoinData(currency);
      setState(() {
        btcText = '1 BTC = ${data.toStringAsFixed(2)} $currency';
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    getData('USD');
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
            child: Card(
              color: Colors.lightBlueAccent,
              elevation: 5.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0),
                child: Text(
                  btcText,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          Container(
              height: 150.0,
              alignment: Alignment.center,
              padding: EdgeInsets.only(bottom: 32.0),
              color: Colors.lightBlue,
              child: Platform.isIOS ? iOSPicker() : iOSPicker()),
        ],
      ),
    );
  }
}
