import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'currency.dart';

class HomeRoute extends StatefulWidget {
  @override
  createState() => HomeRouteState();
}

class HomeRouteState extends State<HomeRoute> {
  List currencyCountries = [];
  List<Currency> _activeCountryCurrencyWidgets = <Currency>[];
  List<String> activeCountryCurrencyNames = <String>[
    'Europe',
    'United States',
    'Thailand',
    'Vietnam',
  ];
  double baseValue = 1.0;

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
    _loadCountriesAsset(context);

    if (currencyCountries.isNotEmpty) {
      _activeCountryCurrencyWidgets.clear();

      var filteredCurrencyCountries = currencyCountries
          .where((country) =>
              activeCountryCurrencyNames.indexOf(country['countryName']) != -1)
          .toList();
      filteredCurrencyCountries.forEach((element) {
        print(element['countryName']);
        _activeCountryCurrencyWidgets.add(Currency(
          countryName: element['countryName'],
          flagCode: element['flagCode'],
          currencyName: element['currencyName'],
          currencyCode: element['currencyCode'],
          currencySymbol: element['currencySymbol'],
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
            onPressed: () => debugPrint('Refresh'))
      ],
    );

    final listView = _buildCurrencyWidgets(_activeCountryCurrencyWidgets);

    return Scaffold(
      appBar: appBar,
      body: listView,
    );
  }
}
