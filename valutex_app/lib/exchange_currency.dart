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
      output = List
          .from(_countryList.where((CountryDetails country) => country.real));
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

  String normalizeAmount(num inRate, num inAmount) {
    num rate = inRate;
    num amount = inAmount;
    String strAmount;
    int approx = 0;

    if (rate >= 1000) {
      while (rate >= 1000) {
        rate /= 10;
        amount /= 10;
        approx--;
      }
      amount = amount.round();
      if (amount == 0) return '0';
      while (approx < 0) {
        amount *= 10;
        approx++;
      }
      return amount.toString();
    }
    if (rate < 1000) {
      while (rate < 1000) {
        rate *= 10;
        amount *= 10;
        approx++;
      }
      amount = amount.round().toDouble();
      while (approx > 0) {
        amount /= 10.0;
        approx--;
      }
      strAmount = amount.toString();
      int pos = strAmount.indexOf('.') + 3;
      pos = (strAmount.length > pos) ? pos : strAmount.length;
      if (pos != -1) strAmount = strAmount.substring(0, pos);
      return strAmount;
    }
    return amount.round().toString();
  }

  String getCurrentAmount(String currencyOutput) {
    num amountOutput = exchange(currencyInput, amountInput, currencyOutput);
    if (!appSettings.amountAppoximation) {
      amountOutput *= 100.0;
      amountOutput = amountOutput.round();
      amountOutput /= 100.0;
      return amountOutput.toString();
    }
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
    if (euNotation) {
      number = number.replaceAll('.', '');
      number = number.replaceAll(',', '.');
    } else {
      number = number.replaceAll(',', '');
    }
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
