import 'package:flutter/material.dart';
import 'coin_data.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io' show Platform;
import 'services/networking.dart';
import 'utilities/constants.dart';
import 'utilities/bitcoint_data_parser.dart';

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String selectedCurrency = 'USD';
  double BTCEchangeRate = 0;
  double ETHEchangeRate = 0;
  double LTCEchangeRate = 0;

  List<DropdownMenuItem<String>> getMenuItems(List<String> currenciesList) {
    List<DropdownMenuItem<String>> dropDownItems = [];

    for (String currency in currenciesList) {
      dropDownItems.add(
        DropdownMenuItem(
          child: Text(currency),
          value: currency,
        ),
      );
    }

    return dropDownItems;
  }

  List<Widget> getIOSMenuItems(List<String> currenciesList) {
    List<Widget> dropDownItems = [];

    for (String currency in currenciesList) {
      dropDownItems.add(
        Text(
          currency,
           style: TextStyle(
             color: Colors.white,
          ),
        ),
      );
    }

    return dropDownItems;
  }

  DropdownButton<String> getDropDownButton() {
    return DropdownButton<String>(
      value: selectedCurrency,
      items: getMenuItems(currenciesList),
      onChanged: (value) {
        updateExchangeRates(value);
      },
    );
  }

  CupertinoPicker getCupertinoPicker() {
    return CupertinoPicker(
      backgroundColor: Colors.lightBlue,
      itemExtent: 32.0,
      onSelectedItemChanged: (selectedIndex) {
        updateExchangeRates(currenciesList[selectedIndex]);
      },
      children: getIOSMenuItems(currenciesList),
    );
  }

  Future updateExchangeRates(String currency) async {
    NetworkHelper helper = NetworkHelper();
    var decodedBTCData = await helper.getBitcoinData('https://rest.coinapi.io/v1/exchangerate/BTC/$currency?apikey=$kBitcoinAPIKey');
    var decodedETHData = await helper.getBitcoinData('https://rest.coinapi.io/v1/exchangerate/ETH/$currency?apikey=$kBitcoinAPIKey');
    var decodedLTCData = await helper.getBitcoinData('https://rest.coinapi.io/v1/exchangerate/LTC/$currency?apikey=$kBitcoinAPIKey');

    BitcoinAPIParser parser = BitcoinAPIParser();
    setState(() {
      selectedCurrency = currency;
      BTCEchangeRate = parser.getExchangeRate(decodedBTCData);
      ETHEchangeRate = parser.getExchangeRate(decodedETHData);
      LTCEchangeRate = parser.getExchangeRate(decodedLTCData);
    });
    print(BTCEchangeRate);
    print(ETHEchangeRate);
    print(LTCEchangeRate);
  }
  
  @override
  void initState() {
    updateExchangeRates(selectedCurrency);
    super.initState();
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
          Column(
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
                     '1 BTC = ${BTCEchangeRate.toStringAsFixed(2)} $selectedCurrency',
                     textAlign: TextAlign.center,
                     style: TextStyle(
                       fontSize: 20.0,
                       color: Colors.white,
                     ),
                   ),
                 ),
               ),
             ),
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
                      '1 ETH = ${ETHEchangeRate.toStringAsFixed(2)} $selectedCurrency',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20.0,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
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
                      '1 LTC = ${LTCEchangeRate.toStringAsFixed(2)} $selectedCurrency',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20.0,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
           ],
          ),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            child: Platform.isIOS ? getCupertinoPicker() : getDropDownButton(),
          ),
        ],
      ),
    );
  }
}
