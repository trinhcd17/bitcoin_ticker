import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'coin_data.dart';
import 'dart:convert';

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String selectedItem='USD';
  var API_KEY='E683C8DB-A0F3-4F44-8EBD-3A50E59E8619';
  List<String> listValue=['?','?','?'];

  List<DropdownMenuItem> getDropDownItem(){
    List<DropdownMenuItem<String>> dropDownItems=[];
    for(String currency in currenciesList){
      var newItem=DropdownMenuItem(
        child: Text(currency),
        value: currency,
      );
      dropDownItems.add(newItem);
    }
    return dropDownItems;
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
            children: [
              buildPadding('BTC',listValue[0]),
              buildPadding('ETH',listValue[1]),
              buildPadding('LTC',listValue[2]),
            ],
          ),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            child: DropdownButton(
              value: selectedItem,
              items: getDropDownItem(),
              onChanged: (value){
                setState(() {
                  selectedItem=value;
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Padding buildPadding(String crypto, String value) {
    return Padding(
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
                '1 $crypto = $value $selectedItem',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        );
  }

  Future<String> getAPI(String crypto, String selectedItem,String APIKEY) async{
    var url = 'https://rest.coinapi.io/v1/exchangerate/$crypto/$selectedItem?apikey=$APIKEY';
    http.Response response = await http.get(url);
    String data=response.body;
    String value=jsonDecode(data)['value'];
    return value;
  }

  void getValue(String crypto, String selectedItem,String APIKEY) async{
    for(String crypto in cryptoList){
      listValue.add(await getAPI(crypto, selectedItem, APIKEY));
      print(listValue[0]);
    }
  }

}
