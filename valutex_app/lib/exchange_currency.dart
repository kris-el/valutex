import 'dart:math';
import 'package:flutter/material.dart';
import 'app_settings.dart';

AppSettings appSettings = AppSettings();

class ExchangeCurrency {
  static final ExchangeCurrency _singleton = ExchangeCurrency._internal();
  factory ExchangeCurrency() {
    return _singleton;
  }
  ExchangeCurrency._internal();

  final num maxEuroAmount = 1000000;

  static List<CountryDetails> _countryList =
      <CountryDetails>[]; // Data countries details
  static Map _currencyRates = {}; // Data exchange rates
  String currencyInput = 'eur';
  num amountInput = 1.0;

  bool isCountryListLoaded() {
    if (_countryList == null) return false;
    if (_countryList.isEmpty) return false;
    return (_countryList.length > 0);
  }

  bool isReady() {
    if (_countryList == null) return false;
    if (_currencyRates == null) return false;
    if (_countryList.isEmpty) return false;
    if (_currencyRates.isEmpty) return false;
    if (currencyInput == null) return false;
    if (currencyInput == '') return false;
    if (amountInput == null) return false;
    return true;
  }

  set countryList(List<CountryDetails> input) {
    _countryList = List.from(input);
  }

  List<CountryDetails> get countryList {
    List<CountryDetails> output = <CountryDetails>[];
    if (!appSettings.fictionalCurrencies) {
      output = List.from(
          _countryList.where((CountryDetails country) => country.real));
    } else {
      output = List.from(_countryList);
    }
    return output;
  }

  set currencyRates(Map input) {
    _currencyRates = Map.from(input);
  }

  set favourites(List<String> favs) {
    _countryList.forEach((CountryDetails country) {
      int order = favs.indexOf(country.countryName);
      country.order = order;
      country.fav = (order != -1);
    });
    _countryList.sort((CountryDetails a, CountryDetails b) {
      if (a.fav && !b.fav) return -1;
      if (!a.fav && b.fav) return 1;
      if (a.order < b.order) return -1;
      if (a.order > b.order) return 1;
      if (a.countryNormName.toString().compareTo(b.countryNormName.toString()) <
          0) return -1;
      if (a.countryNormName.toString().compareTo(b.countryNormName.toString()) >
          0) return 1;
      return 0;
    });
  }

  List<String> get favourites {
    List<String> favs = [];
    _countryList
        .where((CountryDetails country) => country.fav)
        .forEach((CountryDetails country) {
      favs.add(country.countryName);
    });
    return favs;
  }

  set loadCountryList(List json) {
    json.forEach((entry) {
      if (entry['currencySymbol'] == null)
        debugPrint('${entry['countryName']} has no symbol');
      try {
        _countryList.add(CountryDetails(
          countryName: entry['countryName'],
          countryNormName: entry['countryNormName'],
          flagCode: entry['flagCode'],
          currencyName: entry['currencyName'],
          currencyCode: entry['currencyCode'],
          currencySymbol:
              (entry['currencySymbol'] != null) ? entry['currencySymbol'] : '',
          real: entry['real'],
        ));
      } catch (e) {
        debugPrint("Error ${entry['countryName']}");
      }
    });
  }

  List<CountryDetails> searchCountries(input) {
    List<CountryDetails> result = _countryList.where((country) {
      if (!appSettings.fictionalCurrencies) {
        if (!country.real) return false;
      }
      if (input == '') return country.fav;
      if (country.countryNormName.toString().contains(input.toLowerCase()))
        return true;
      if (country.currencyName.toLowerCase().contains(input.toLowerCase()))
        return true;
      if (country.currencyCode.toLowerCase().contains(input.toLowerCase()))
        return true;
      return false;
    }).toList();
    return result;
  }

  num exchange(String cInput, num aInput, String cOutput) {
    cOutput = cOutput.toUpperCase();
    cInput = cInput.toUpperCase();
    num aEuro;
    num aOutput;

    // Convert aInput cInput -> eur
    if (cInput == 'EUR') {
      aEuro = aInput;
    } else {
      aEuro = aInput / _currencyRates[cInput];
    }
    // Convert amountEuro euro -> cOutput
    if (cOutput == 'EUR') {
      aOutput = aEuro;
    } else {
      aOutput = aEuro * _currencyRates[cOutput];
    }
    return aOutput;
  }

  int decPart(num input) {
    List lst = input.toString().split('.');
    return (lst.length == 1) ? 0 : lst[1].length;
  }

  int intPart(num input) {
    List lst = input.toString().split('.');
    return (lst[0].length > 1) ? lst[0].length : ((input < 1) ? 0 : 1);
  }

  String normalizeAmount(num inRate, num inAmount) {
    int approx = 3;
    int rateIntPart = intPart(inRate);
    String strAmount;
    int pad;

    if (appSettings.extraPrecision) approx = 4;
    if (rateIntPart > 0) {
      int decimals = approx - rateIntPart;
      if (decimals > 0) {
        return inAmount.toStringAsFixed(decimals);
      } else {
        pad = decimals * -1;
        strAmount = (inAmount / pow(10, pad)).round().toString();
        return strAmount.padRight(strAmount.length + pad, '0');
      }
    }
    int ints = 0;
    while (intPart(inAmount) < approx) {
      inAmount *= 10;
      ints++;
    }
    pad = ints - approx;
    strAmount = inAmount.round().toString();
    return '0.' + strAmount.padLeft(strAmount.length + pad, '0');
  }

  String getCurrentAmount(String currencyOutput) {
    num amountOutput = exchange(currencyInput, amountInput, currencyOutput);
    return normalizeAmount(_currencyRates[currencyOutput], amountOutput);
  }

  num getMaxAmount(String currencyOutput) {
    int digits = 0;
    if (currencyOutput.toUpperCase() == 'EUR') return 10000000;
    num maxAmount = exchange('EUR', maxEuroAmount, currencyOutput);
    digits = maxAmount.round().toString().length + 1;
    maxAmount = int.parse(1.toString().padRight(digits, '0'));
    return maxAmount;
  }

  String applyNotation(String number, bool euNotation) {
    String char;
    String output = '';
    bool startCount = number.indexOf('.') == -1;
    int intpart = 0;
    if (number.length > 1) {
      if ((number[0].compareTo('0') == 0) && (number[1].compareTo('.') != 0)) {
        number = number.substring(1, number.length);
      }
    }

    for (int i = number.length - 1; i >= 0; i--) {
      char = number[i];
      if (startCount) intpart++;
      if ((char.compareTo('.') == 0)) {
        if (euNotation) char = ',';
        startCount = true;
      }
      output = char + output;
      if (euNotation) {
        if ((intpart % 3 == 0) && (i != 0) && (intpart > 0))
          output = '.' + output;
      } else {
        if ((intpart % 3 == 0) && (i != 0) && (intpart > 0))
          output = ',' + output;
      }
    }
    return output;
  }
}

class CountryDetails {
  Key key;
  final String countryName;
  final String countryNormName;
  final String flagCode;
  final String currencyName;
  final String currencyCode;
  final String currencySymbol;
  bool real;
  int order;
  bool fav;

  CountryDetails({
    this.key,
    @required this.countryName,
    @required this.countryNormName,
    @required this.flagCode,
    @required this.currencyName,
    @required this.currencyCode,
    @required this.currencySymbol,
    this.real,
    this.order,
    this.fav,
  })  : assert(countryName != null),
        assert(countryNormName != null),
        assert(flagCode != null),
        assert(currencyName != null),
        assert(currencyCode != null),
        assert(currencySymbol != null);
}
