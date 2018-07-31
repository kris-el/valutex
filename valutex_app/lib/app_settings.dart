import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class AppSettings {
  static final AppSettings _singleton = AppSettings._internal();
  factory AppSettings() {
    return _singleton;
  }
  AppSettings._internal();

  String appVersion = '2.0.3';
  bool darkTheme = true;
  String amountNotation = 'us';
  bool amountAppoximation = true;
  bool rememberInput = true;
  bool fictionalCurrencies = false;

  bool isTourComplete = false; // On first run shows mini tutorial
  bool isLinked = false; // On first connection create an account on the server

  String product = '';
  String osVersion = '';
  String androidSdk = '';


  set europeanNotation(bool input) {
    if (input)
      amountNotation = 'eu';
    else
      amountNotation = 'us';
  }

  bool get europeanNotation {
    return (amountNotation == 'eu');
  }

  String exportToJson() {
    var settingsData = {
      'amountNotation': amountNotation,
      'amountAppoximation': amountAppoximation,
      'rememberInput': rememberInput,
      'fictionalCurrencies': fictionalCurrencies,
    };
    return JsonEncoder().convert(settingsData);
  }

  void importFromJson(String input) {
    var settingsData = JsonDecoder().convert(input);
    try {
      amountNotation = settingsData['amountNotation'];
      amountAppoximation = settingsData['amountAppoximation'];
      rememberInput = settingsData['rememberInput'];
      fictionalCurrencies = settingsData['fictionalCurrencies'];
    } catch (e) {
      print('Error on reading settings');
    }
  }

  void save() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String settings = exportToJson();
    prefs.setString('settings', settings);
  }

  void load() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String settings = prefs.getString('Settings');
    if (settings != null) importFromJson(settings);
  }
}
