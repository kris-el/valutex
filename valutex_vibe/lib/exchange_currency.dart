import 'package:flutter/material.dart';


class ExchangeCurrency {
  static final ExchangeCurrency _singleton = ExchangeCurrency._internal();
  factory ExchangeCurrency() {
    return _singleton;
  }
  ExchangeCurrency._internal();

  List<CountryDetails> countryList = []; // Data countries details
  //Map currencyRates = {}; // Data exchange rates
  //String currencySource = 'none'; // Source of exchange rates

  set favourites(List<String> favs) {
    countryList.forEach((CountryDetails country) {
      int order = favs.indexOf(country.countryName);
      country.order = order;
      country.fav = (order != -1);
    });
    countryList.sort((CountryDetails a, CountryDetails b) {
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
    countryList.forEach((CountryDetails country) {
      favs.add(country.countryName);
    });
    return favs;
  }

  set loadCountryList(List json) {
    json.forEach((entry) {
      if (entry['currencySymbol'] == null)
        debugPrint('${entry['countryName']} has no symbol');
      try {
        countryList.add(CountryDetails(
          countryName: entry['countryName'],
          countryNormName: entry['countryNormName'],
          flagCode: entry['flagCode'],
          currencyName: entry['currencyName'],
          currencyCode: entry['currencyCode'],
          currencySymbol:
              (entry['currencySymbol'] != null) ? entry['currencySymbol'] : '',
        ));
      } catch (e) {
        debugPrint("Error ${entry['countryName']}");
      }
    });
  }

  List<CountryDetails> searchCountries(input) {
    List<CountryDetails> result = countryList.where((country) {
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
}

class CountryDetails {
  Key key;
  final String countryName;
  final String countryNormName;
  final String flagCode;
  final String currencyName;
  final String currencyCode;
  final String currencySymbol;
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
    this.order,
    this.fav,
  })  : assert(countryName != null),
        assert(countryNormName != null),
        assert(flagCode != null),
        assert(currencyName != null),
        assert(currencyCode != null),
        assert(currencySymbol != null);
}
