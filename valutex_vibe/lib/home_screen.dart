import 'dart:async';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'currency.dart';

class HomeScreen extends StatefulWidget {
  final String title;

  HomeScreen({Key key, this.title}) : super(key: key);

  @override
  createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List currencyCountries = []; // Data countries details
  Map currencyRates = {}; // Data exchange rates
  String currencySource = 'none'; // Source of exchange rates
  DateTime ratesUpdate = new DateTime.now();
  List<Currency> _activeCountryCurrencyWidgets = <Currency>[]; // listview items
  List<String> activeCountryCurrencyNames = <String>[
    // index of Items to show in listview
    'Europe',
    'United States',
    'Thailand',
    'Vietnam',
  ];
  String currencyInput = 'eur';
  double amountInput = 1.0;
  DateFormat formatter = new DateFormat('H:m E, d MMMM yyyy');

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
      ratesUpdate = DateTime.parse(dataRates['age']);
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
      ratesUpdate = DateTime.parse(dataRates['age']);
      print('currencySource: $currencySource');
    });
  }

  void refreshRates() {
    currencySource = 'old';
    _getRatesFromApi();
  }

  double getCurrentAmount(String currencyOutput) {
    currencyOutput = currencyOutput.toUpperCase();
    currencyInput = currencyInput.toUpperCase();
    double amountEuro;
    double amountOutput;
    // Convert amountInput currencyInput -> eur
    if (currencyInput == 'EUR') {
      amountEuro = amountInput;
    } else {
      // 40thb ?eur
      amountEuro = amountInput / currencyRates[currencyInput];
    }
    // Convert amountEuro euro -> currencyOutput
    if (currencyOutput == 'EUR') {
      amountOutput = amountEuro;
    } else {
      amountOutput = amountEuro * currencyRates[currencyOutput];
    }
    return amountOutput;
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
      title: Text(widget.title),
      actions: <Widget>[
        new IconButton(
            icon: new Icon(Icons.playlist_add),
            onPressed: addCountryCurrencyWidget),
        new IconButton(
            icon: new Icon(Icons.wrap_text),
            onPressed: () => debugPrint("Sort element!")),
        new IconButton(icon: new Icon(Icons.refresh), onPressed: refreshRates)
      ],
    );

    final bottomBar = BottomAppBar(
      child: Container(
        color: Theme.of(context).primaryColor,
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            'Updated: ${formatter.format(ratesUpdate)}',
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );

    final listView = _buildCurrencyWidgets(_activeCountryCurrencyWidgets);

    return Scaffold(
      appBar: appBar,
      body: listView,
      bottomNavigationBar: bottomBar,
    );
  }
}