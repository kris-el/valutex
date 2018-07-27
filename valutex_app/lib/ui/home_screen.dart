import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';
import 'package:device_info/device_info.dart';
import 'home_drawer.dart';
import 'currency_widget.dart';
import 'selection_screen.dart';
import 'arrange_screen.dart';
import '../exchange_currency.dart';
import '../app_settings.dart';

ExchangeCurrency exchangeCurrency = ExchangeCurrency();
AppSettings appSettings = AppSettings();

class HomeScreen extends StatefulWidget {
  final String title;

  HomeScreen({Key key, this.title}) : super(key: key);

  @override
  createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static final DeviceInfoPlugin deviceInfoPlugin = new DeviceInfoPlugin();
  String currencySource = 'none'; // Source of exchange rates
  DateTime ratesUpdate = DateTime.now();
  List<CurrencyWidget> _activeCountryCurrencyWidgets =
      <CurrencyWidget>[]; // listview items
  List<String> selectedCountries =
      <String>[]; // index of Items to show in listview
  DateFormat dateFormatter = new DateFormat('H:m E, d MMMM yyyy');

  @override
  void initState() {
    super.initState();
    _loadAssetsData();
    _loadRatesFromApi();
    initPlatformState();
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

  _loadAssetsData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      appSettings.isTourComplete = (prefs.getBool('isTourComplete') ?? false);
      String rates = prefs.getString('rates');
      String update = prefs.getString('update');
      if ((rates != null) && (update != null)) {
        currencySource = 'internal';
        exchangeCurrency.currencyRates = JsonDecoder().convert(rates);
        ratesUpdate = DateTime.parse(update).toLocal();
        print('currencySource: $currencySource');
      } else {
        _loadRatesFromAsset(context);
      }
      selectedCountries = (prefs.getStringList('favourites') ??
          ['Europe', 'United States', 'Thailand', 'Vietnam']);
      if (appSettings.rememberInput) {
        String amountLoaded = prefs.getString('amountInput');
        if (amountLoaded != null) {
          exchangeCurrency.amountInput = double.parse(amountLoaded);
        }
        String currencyLoaded = prefs.getString('currencyInput');
        if (currencyLoaded != null) {
          exchangeCurrency.currencyInput = currencyLoaded;
        }
      }
      String settings = prefs.getString('settings');
      if (settings != null) {
        appSettings.importFromJson(settings);
      }
      _loadCountriesFromAsset(context);
    });
  }

  Future<void> _loadCountriesFromAsset(BuildContext context) async {
    if (exchangeCurrency.isCountryListLoaded()) return;
    final jsonCountries =
        DefaultAssetBundle.of(context).loadString('assets/data/countries.json');
    final dataCountries = JsonDecoder().convert(await jsonCountries);

    if (dataCountries is! List) {
      throw ('Data retrieved is not a List');
    }
    setState(() {
      exchangeCurrency.loadCountryList = dataCountries;
      exchangeCurrency.favourites = selectedCountries;
    });
  }

  Future<void> _loadRatesFromAsset(BuildContext context) async {
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

  Future<void> _loadRatesFromApi() async {
    if (currencySource == 'api') {
      debugPrint('Api request refused');
      return;
    }
    SharedPreferences prefs = await SharedPreferences.getInstance();
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
      prefs.setString('rates', JsonEncoder().convert(dataRates['rates']));
      prefs.setString('update', dataRates['age']);
    });
  }

  Future<Null> initPlatformState() async {
    Map<String, dynamic> deviceData;

    try {
      if (Platform.isAndroid) {
        deviceData = _readAndroidBuildData(await deviceInfoPlugin.androidInfo);
      } else if (Platform.isIOS) {
        deviceData = _readIosDeviceInfo(await deviceInfoPlugin.iosInfo);
      }
    } on PlatformException {
      deviceData = <String, dynamic>{
        'Error:': 'Failed to get platform version.'
      };
    }

    if (!mounted) return;

    setState(() {
      if (Platform.isAndroid) {
        appSettings.product =
            '${deviceData['product']} (${deviceData['model']})';
        appSettings.version = deviceData['version.release'];
        appSettings.sdk = deviceData['version.sdkInt'].toString();
      }
    });
  }

  Map<String, dynamic> _readAndroidBuildData(AndroidDeviceInfo build) {
    return <String, dynamic>{
      'version.securityPatch': build.version.securityPatch,
      'version.sdkInt': build.version.sdkInt,
      'version.release': build.version.release,
      'version.previewSdkInt': build.version.previewSdkInt,
      'version.incremental': build.version.incremental,
      'version.codename': build.version.codename,
      'version.baseOS': build.version.baseOS,
      'board': build.board,
      'bootloader': build.bootloader,
      'brand': build.brand,
      'device': build.device,
      'display': build.display,
      'fingerprint': build.fingerprint,
      'hardware': build.hardware,
      'host': build.host,
      'id': build.id,
      'manufacturer': build.manufacturer,
      'model': build.model,
      'product': build.product,
      'supported32BitAbis': build.supported32BitAbis,
      'supported64BitAbis': build.supported64BitAbis,
      'supportedAbis': build.supportedAbis,
      'tags': build.tags,
      'type': build.type,
      'isPhysicalDevice': build.isPhysicalDevice,
    };
  }

  Map<String, dynamic> _readIosDeviceInfo(IosDeviceInfo data) {
    return <String, dynamic>{
      'name': data.name,
      'systemName': data.systemName,
      'systemVersion': data.systemVersion,
      'model': data.model,
      'localizedModel': data.localizedModel,
      'identifierForVendor': data.identifierForVendor,
      'isPhysicalDevice': data.isPhysicalDevice,
      'utsname.sysname:': data.utsname.sysname,
      'utsname.nodename:': data.utsname.nodename,
      'utsname.release:': data.utsname.release,
      'utsname.version:': data.utsname.version,
      'utsname.machine:': data.utsname.machine,
    };
  }

  void refreshRates() {
    currencySource = 'old';
    _loadRatesFromApi();
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
    if (exchangeCurrency.isReady()) {
      _activeCountryCurrencyWidgets.clear();
      exchangeCurrency.countryList
          .where((country) => country.fav)
          .forEach((element) {
        _activeCountryCurrencyWidgets.add(CurrencyWidget(
          countryDetails: element,
          currentAmount:
              exchangeCurrency.getCurrentAmount(element.currencyCode),
          maxAmount: exchangeCurrency.getMaxAmount(element.currencyCode),
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
            'Updated: ${dateFormatter.format(ratesUpdate)}',
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );

    return Scaffold(
      appBar: appBar,
      drawer: HomeDrawer(),
      body: _buildCurrencyWidgets(_activeCountryCurrencyWidgets),
      bottomNavigationBar: bottomBar,
    );
  }
}
