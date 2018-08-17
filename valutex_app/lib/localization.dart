import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'l10n/messages_all.dart';

List allowedLanguages = ['en', 'it', 'th', 'vi'];

class AppLocalizations {
  static Future<AppLocalizations> load(Locale locale) {
    final String name =
        locale.countryCode.isEmpty ? locale.languageCode : locale.toString();
    final String localeName = Intl.canonicalizedLocale(name);

    return initializeMessages(localeName).then((bool _) {
      Intl.defaultLocale = localeName;
      return AppLocalizations();
    });
  }

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  String get msgboxActionContinue {
    return Intl.message(
      'Continue',
      name: 'msgboxActionContinue',
      desc: 'Messagebox action: Continue',
    );
  }

  String get msgboxActionAbort {
    return Intl.message(
      'Cancel',
      name: 'msgboxActionAbort',
      desc: 'Messagebox action: Cancel',
    );
  }

  String get updated {
    return Intl.message(
      'Updated',
      name: 'updated',
      desc: 'bottomNavigationBar: Updated',
    );
  }

  String get appSubtitle {
    return Intl.message(
      'Currency converter',
      name: 'appSubtitle',
      desc: 'Subtitle of the app',
    );
  }

  String get appAuthor {
    return Intl.message(
      'Author',
      name: 'appAuthor',
      desc: 'Author of the app',
    );
  }

  String get drawerSettings {
    return Intl.message(
      'Settings',
      name: 'drawerSettings',
      desc: 'Drawer list item: Settings',
    );
  }

  String get drawerAboutApp {
    return Intl.message(
      'About App',
      name: 'drawerAboutApp',
      desc: 'Drawer list item: About App',
    );
  }

  String get aboutBodyAppDescription {
    return Intl.message(
      'This application is designed for casual usage.\nRates update are available once an hour.\n\nApplication realized with Flutter and Dart.\n',
      name: 'aboutBodyAppDescription',
      desc: 'About body App description',
    );
  }

  String get drawerContactDeveloper {
    return Intl.message(
      'Contact developer',
      name: 'drawerContactDeveloper',
      desc: 'Drawer list item: Contact developer',
    );
  }

  String get emailTextDetailsProduct {
    return Intl.message(
      'Product',
      name: 'emailTextDetailsProduct',
      desc: 'Email details: Product',
    );
  }

  String get emailTextDetailsScreen {
    return Intl.message(
      'Screen',
      name: 'emailTextDetailsScreen',
      desc: 'Email details: Screen',
    );
  }

  String get emailTextHello {
    return Intl.message(
      'Hello,',
      name: 'emailTextHello',
      desc: 'Email details: Hello',
    );
  }

  String get settingsTitleUseDarkTheme {
    return Intl.message(
      'Use dark theme',
      name: 'settingsTitleUseDarkTheme',
      desc: 'Settings title: Use dark theme',
    );
  }

  String get settingsSubtitleUseDarkTheme {
    return Intl.message(
      'Use theme more relaxing for your eyes',
      name: 'settingsSubtitleUseDarkTheme',
      desc: 'Settings subtitle: Use dark theme',
    );
  }

  String get settingsTitleEuropeanNotation {
    return Intl.message(
      'European notation',
      name: 'settingsTitleEuropeanNotation',
      desc: 'Settings title: European notation',
    );
  }

  String get settingsSubtitleEuropeanNotation {
    return Intl.message(
      'Change the separator of thousands and decimals',
      name: 'settingsSubtitleEuropeanNotation',
      desc: 'Settings subtitle: European notation',
    );
  }

  String get settingsTitleExtraPrecision {
    return Intl.message(
      'Extra precision',
      name: 'settingsTitleExtraPrecision',
      desc: 'Settings title: Extra precision',
    );
  }

  String get settingsSubtitleExtraPrecision {
    return Intl.message(
      'Increase precision of one significant digit in amounts calculation',
      name: 'settingsSubtitleExtraPrecision',
      desc: 'Settings subtitle: Extra precision',
    );
  }

  String get settingsTitleLimitInput {
    return Intl.message(
      'Limit input to integer',
      name: 'settingsTitleLimitInput',
      desc: 'Settings title: Limit input to decimalas',
    );
  }

  String get screenTitleSetAmount {
    return Intl.message(
      'Set amount',
      name: 'screenTitleSetAmount',
      desc: 'Scree title: Set amount',
    );
  }

  String get screenTitleArrangeCurrencies {
    return Intl.message(
      'Arrange favourites',
      name: 'screenTitleArrangeCurrencies',
      desc: 'Scree title: Arrange favourites',
    );
  }

  String get settingsSubtitleLimitInput {
    return Intl.message(
      'Rounds the amount input in "Set amount" screen',
      name: 'settingsSubtitleLimitInput',
      desc: 'Settings subtitle: Limit input to decimalas',
    );
  }

  String get settingsTitleFictionalCountries {
    return Intl.message(
      'Fictional countries',
      name: 'settingsTitleFictionalCountries',
      desc: 'Settings title: Fictional countries',
    );
  }

  String get settingsSubtitleFictionalCountries {
    return Intl.message(
      'Show fictional counries',
      name: 'settingsSubtitleFictionalCountries',
      desc: 'Settings subtitle: Fictional countries',
    );
  }

  String get settingsTitleAppReset {
    return Intl.message(
      'App reset',
      name: 'settingsTitleAppReset',
      desc: 'Settings title: App reset',
    );
  }

  String get settingsSubtitleAppReset {
    return Intl.message(
      'Clear all app data',
      name: 'settingsSubtitleAppReset',
      desc: 'Settings subtitle: App reset',
    );
  }

  String get settingsMsgboxBodyAppReset {
    return Intl.message(
      'Do you want to delete all your app data?\n\nIf you continue you will lose all your preferences, bringing back the application as just downloaded state.',
      name: 'settingsMsgboxBodyAppReset',
      desc: 'Settings messagebox text: App reset',
    );
  }

  String get settingsMsgboxTitleDataCleared {
    return Intl.message(
      'Data cleared',
      name: 'settingsMsgboxTitleDataCleared',
      desc: 'Settings messagebox title: Data cleared',
    );
  }

  String get settingsMsgboxBodyDataCleared {
    return Intl.message(
      'Close and open the app again.',
      name: 'settingsMsgboxBodyDataCleared',
      desc: 'Settings messagebox text: Data cleared',
    );
  }

  String get inputPlaceHolderSearch {
    return Intl.message(
      'Search...',
      name: 'inputPlaceHolderSearch',
      desc: 'Input search place holder',
    );
  }

  String get inputPlaceHolderAmount {
    return Intl.message(
      'Currency amount',
      name: 'inputPlaceHolderAmount',
      desc: 'Input place holder',
    );
  }

  String get inputErrorInvalidAmount {
    return Intl.message(
      'Invalid number entered',
      name: 'inputErrorInvalidAmount',
      desc: 'Input error: Invalid number entered',
    );
  }

  String get inputErrorAmountToHigh {
    return Intl.message(
      'Amount too high',
      name: 'inputErrorAmountToHigh',
      desc: 'Input error: Amount too high',
    );
  }

  String get inputErrorNonZeroAmount {
    return Intl.message(
      'Enter an amount different from zero',
      name: 'inputErrorNonZeroAmount',
      desc: 'Input error: Non zero amount',
    );
  }
}

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => allowedLanguages.contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) => AppLocalizations.load(locale);

  @override
  bool shouldReload(AppLocalizationsDelegate old) => false;
}
