import 'dart:async';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'home_drawer.dart';
import 'currency_widget.dart';
import 'selection_screen.dart';
import 'arrange_screen.dart';
import 'exchange_currency.dart';

class HomeScreen extends StatefulWidget {
  final String title;

  HomeScreen({Key key, this.title}) : super(key: key);

  @override
  createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  ExchangeCurrency exchangeCurrency = ExchangeCurrency();
  String currencySource = 'none'; // Source of exchange rates
  DateTime ratesUpdate = DateTime.now();
  List<CurrencyWidget> _activeCountryCurrencyWidgets =
      <CurrencyWidget>[]; // listview items
  Map settings = {'europeanNotation': true};
  List<String> activeCountryCurrencyNames = <String>[
    // index of Items to show in listview
    'Europe',
    'United States',
    'Thailand',
    'Vietnam',
  ];
  DateFormat formatter = new DateFormat('H:m E, d MMMM yyyy');

  @override
  void initState() {
    super.initState();
    _loadRatesAsset(context);
    _loadCountriesAsset(context);
    _getRatesFromApi();
  }

  void updateFavourite(List countries, List<String> favs) {
    countries.forEach((country) {
      int sort = favs.indexOf(country['countryName']);
      country.putIfAbsent('sort', () => sort);
      country.putIfAbsent('fav', () => (sort != -1));
    });
    countries.sort((a, b) {
      if (a['fav'] && !b['fav']) return -1;
      if (!a['fav'] && b['fav']) return 1;
      if (a['sort'] < b['sort']) return -1;
      if (a['sort'] > b['sort']) return 1;
      if (a['countryName'].toString().compareTo(b['countryName'].toString()) <
          0) return -1;
      if (a['countryName'].toString().compareTo(b['countryName'].toString()) >
          0) return 1;
      return 0;
    });
  }

  Future<void> _loadCountriesAsset(BuildContext context) async {
    if (exchangeCurrency.countryList.isNotEmpty) return;
    final jsonCountries =
        DefaultAssetBundle.of(context).loadString('assets/data/countries.json');
    final dataCountries = JsonDecoder().convert(await jsonCountries);

    if (dataCountries is! List) {
      throw ('Data retrieved is not a List');
    }
    setState(() {
      exchangeCurrency.loadCountryList = dataCountries;
      exchangeCurrency.favourites = activeCountryCurrencyNames;
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
      exchangeCurrency.currencyRates = dataRates['rates'];
      ratesUpdate = DateTime.parse(dataRates['age']).toLocal();
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
      exchangeCurrency.currencyRates = dataRates['rates'];
      ratesUpdate = DateTime.parse(dataRates['age']).toLocal();
      print('currencySource: $currencySource');
    });
  }

  void refreshRates() {
    currencySource = 'old';
    _getRatesFromApi();
  }

  Widget _buildCurrencyWidgets(List<Widget> currencies) {
    return ListView.builder(
      itemBuilder: (BuildContext context, int i) {
        if (i.isOdd)
          return Divider(
            color: Colors.grey,
            indent: 0.0,
            height: 2.0,
          );
        final index = i ~/ 2;
        return currencies[index];
      },
      itemCount: currencies.length * 2,
    );
  }

  void openSelScreen(BuildContext context) async {
    await Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => SelectionScreen(),
          ),
        );
  }

  void openArrScreen(BuildContext context) async {
    await Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ArrangeScreen(),
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    if (exchangeCurrency.countryList.isNotEmpty && exchangeCurrency.currencyRates.isNotEmpty) {
      _activeCountryCurrencyWidgets.clear();
      exchangeCurrency.countryList
          .where((country) => country.fav)
          .forEach((element) {
        _activeCountryCurrencyWidgets.add(CurrencyWidget(
          countryName: element.countryName,
          flagCode: element.flagCode,
          currencyName: element.currencyName,
          currencyCode: element.currencyCode,
          currencySymbol: element.currencySymbol,
          currentAmount: exchangeCurrency.getCurrentAmount(element.currencyCode),
          maxAmount: exchangeCurrency.getMaxAmount(element.currencyCode),
          europeanNotation: settings['europeanNotation'],
          inputAmountCallBack: (newCurrency, newAmount) {
            if (newCurrency == null) return;
            if (newAmount == null) return;
            setState(() {
              exchangeCurrency.currencyInput = newCurrency;
              exchangeCurrency.amountInput = newAmount;
            });
          },
        ));
      });
    }

    final appBar = AppBar(
      title: Text(widget.title),
      actions: <Widget>[
        new IconButton(
            icon: new Icon(Icons.playlist_add),
            onPressed: () {
              openSelScreen(context);
            }),
        new IconButton(
            icon: new Icon(Icons.wrap_text),
            onPressed: () {
              openArrScreen(context);
            }),
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

    return Scaffold(
      appBar: appBar,
      drawer: HomeDrawer(settings: settings),
      body: _buildCurrencyWidgets(_activeCountryCurrencyWidgets),
      bottomNavigationBar: bottomBar,
    );
  }
}
