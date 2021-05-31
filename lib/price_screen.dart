import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'coin_data.dart';
import 'dart:io' show Platform;
// import 'dart:io' hide Platform;
import 'networking.dart';

const String url = 'https://rest.coinapi.io/v1/exchangerate';
const String apiKey = 'FC68C96C-1D04-4A57-94A6-454EC107FC37';

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {

  String selectedCurrency = 'USD';

  String crypto = 'BTC';

  String rateString = '?';

  @override
  void initState(){
    super.initState();

    getPrice();
  }

  getPrice() async {
    String uri = '$url/$crypto/$selectedCurrency?apikey=$apiKey';
    Networking networking = Networking(uri: uri);

    var parsedData = await networking.getData();

    double rate = parsedData['rate'];

    String rateToString = rate.toStringAsFixed(2);
    rateString = rateToString;
  }

  DropdownButton<String> androidDropdown() {
    List<DropdownMenuItem<String>> menuItems = [];

    for (String item in currenciesList) {
      menuItems.add(DropdownMenuItem(
        child: Text(item),
        value: item,
      ));
    }

    return DropdownButton<String>(
      value: selectedCurrency,
      items: menuItems,
      onChanged: (value) {
        setState(() {
          selectedCurrency = value;
          getPrice();
        });
      },
    );
  }

  CupertinoPicker iOSPicker() {
    List<Text> menuItems = [];

    for (String item in currenciesList) {
      menuItems.add(Text(item));
    }

    return CupertinoPicker(
      backgroundColor: Colors.lightBlue,
      itemExtent: 32.0,
      onSelectedItemChanged: (selectedIndex) {
        print(selectedIndex);
      },
      children: menuItems,
    );
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
            padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
            child: Card(
              color: Colors.lightBlueAccent,
              elevation: 5.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
                child: Text(
                  '1 $crypto = $rateString $selectedCurrency',
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
            padding: EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            child: Platform.isIOS ? iOSPicker() : androidDropdown(),
          ),
        ],
      ),
    );
  }
}
