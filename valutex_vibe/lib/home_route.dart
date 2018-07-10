import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'currency.dart';

class HomeRoute extends StatefulWidget {
  @override
  createState() => HomeRouteState();
}

class HomeRouteState extends State<HomeRoute> {
  List currencyCountries = [];
  String currencySource = 'none';
  Map currencyRates = {};
  List<Currency> _activeCountryCurrencyWidgets = <Currency>[];
  List<String> activeCountryCurrencyNames = <String>[
    'Europe',
    'United States',
    'Thailand',
    'Vietnam',
  ];
  double baseValue = 1.0;
  String currencyInput = 'eur';

  void addCountryCurrencyWidget() {
    print('addCountryCurrencyWidget');
  }

  Future<void> _loadCountriesAsset(BuildContext context) async {
    if (currencyCountries.isNotEmpty) return;
    final jsonCountries =
        DefaultAssetBundle.of(context).loadString('assets/data/countries.json');
    final dataCountries = JsonDecoder().convert(await jsonCountries);

    if (dataCountries is! List) {
      throw ('Data retrieved is not a List');
    }
    setState(() {
      currencyCountries = dataCountries;
    });
  }

  Future<void> _loadRatesAsset(BuildContext context) async {
    if (currencySource != 'none') return;
    currencySource = 'json';
    final jsonRates =
        DefaultAssetBundle.of(context).loadString('assets/data/rates.json');
    final dataRates = JsonDecoder().convert(await jsonRates);
    if (dataRates is! Map) {
      throw ('Data retrieved is not a Map');
    }
    setState(() {
      currencySource = 'json';
      currencyRates = dataRates['rates'];
      print('currencySource: $currencySource');
    });
  }

  Future<void> _getRatesFromApi() async {
    if (currencySource == 'api') {
      debugPrint('Api request refused');
      return;
    }
    currencySource = 'api';
    String apiUrl = 'https://valutex.herokuapp.com/api/getrates';

    http.Response response = await http.get(apiUrl);
    var dataRates = JsonDecoder().convert(response.body);

    if (dataRates is! Map) {
      throw ('Data retrieved is not a Map');
    }
    setState(() {
      currencySource = 'api';
      currencyRates = dataRates['rates'];
      print('currencySource: $currencySource');
    });
  }

  void refreshRates() {
    currencySource = 'old';
    _getRatesFromApi();
  }

  double getCurrentAmount(String currency) {
    currency = currency.toUpperCase();
    if (currency.toUpperCase() == 'EUR') return 1.0;
    return currencyRates[currency];
  }

  Widget _buildCurrencyWidgets(List<Widget> currencies) {
    return ListView.builder(
      itemBuilder: (BuildContext context, int i) {
        if (i.isOdd) return Divider();
        final index = i ~/ 2;
        return currencies[index];
      },
      itemCount: currencies.length * 2,
    );
  }

  @override
  Widget build(BuildContext context) {
    _loadRatesAsset(context);
    _loadCountriesAsset(context);
    _getRatesFromApi();

    if (currencyCountries.isNotEmpty) {
      _activeCountryCurrencyWidgets.clear();

      var filteredCurrencyCountries = currencyCountries
          .where((country) =>
              activeCountryCurrencyNames.indexOf(country['countryName']) != -1)
          .toList();
      filteredCurrencyCountries.forEach((element) {
        _activeCountryCurrencyWidgets.add(Currency(
          countryName: element['countryName'],
          flagCode: element['flagCode'],
          currencyName: element['currencyName'],
          currencyCode: element['currencyCode'],
          currencySymbol: element['currencySymbol'],
          currentAmount: getCurrentAmount(element['currencyCode']),
        ));
      });
    }

    final appBar = AppBar(
      title: Text('Currency converter'),
      actions: <Widget>[
        new IconButton(
            icon: new Icon(Icons.playlist_add),
            onPressed: addCountryCurrencyWidget),
        new IconButton(
            icon: new Icon(Icons.wrap_text),
            onPressed: () => debugPrint("Sort element!")),
        new IconButton(
            icon: new Icon(Icons.refresh),
            onPressed: refreshRates)
      ],
    );

    final listView = _buildCurrencyWidgets(_activeCountryCurrencyWidgets);

    return Scaffold(
      appBar: appBar,
      body: listView,
    );
  }
}
