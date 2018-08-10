import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'l10n/messages_all.dart';

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

  String get updated {
    return Intl.message(
      'Updated:',
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

  String get drawerContactDeveloper {
    return Intl.message(
      'Contact developer',
      name: 'drawerContactDeveloper',
      desc: 'Drawer list item: Contact developer',
    );
  }
}

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'it'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) => AppLocalizations.load(locale);

  @override
  bool shouldReload(AppLocalizationsDelegate old) => false;
}
