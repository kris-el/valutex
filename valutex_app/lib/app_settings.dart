import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppSettings {
  static final AppSettings _singleton = AppSettings._internal();
  factory AppSettings() {
    return _singleton;
  }
  AppSettings._internal();

  String appVersion = '2.0.9';
  bool darkTheme = true;
  String amountNotation = 'us';
  bool extraPrecision = false;
  bool rememberInput = true;
  bool fictionalCurrencies = false;
  bool inputAmountRound = true;

  bool isTourComplete = false; // On first run shows mini tutorial
  bool isLinked = false; // On first connection create an account on the server

  String product = '';
  String osVersion = '';
  String androidSdk = '';

  num designWidth = 411;
  num designHeight = 683;
  num screenWidth = 320;
  num screenHeight = 533;
  num screenRatio = 1.5;

  num get scaleWidth {
    num ratio = screenWidth / designWidth;
    return (ratio <= 1.3) ? ratio : 1.3;
  }

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
      'amountAppoximation': extraPrecision,
      'rememberInput': rememberInput,
      'fictionalCurrencies': fictionalCurrencies,
      'inputAmountRound': inputAmountRound,
    };
    return JsonEncoder().convert(settingsData);
  }

  void importFromJson(String input) {
    var settingsData = JsonDecoder().convert(input);
    try {
      amountNotation = settingsData['amountNotation'];
      extraPrecision = settingsData['amountAppoximation'];
      rememberInput = settingsData['rememberInput'];
      fictionalCurrencies = settingsData['fictionalCurrencies'];
      inputAmountRound = settingsData['inputAmountRound'];
    } catch (e) {
      debugPrint('Error on reading settings');
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

  bool get isInDebugMode {
    bool inDebugMode = false;
    assert(inDebugMode = true);
    return inDebugMode;
  }
}
