import 'dart:async';
import 'package:flutter/material.dart';import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter/foundation.dart' show SynchronousFuture;
import 'package:intl/intl.dart';

// class ValutexLocalizations {
//   static Future<ValutexLocalizations> load(Locale locale) {
//     final String name = locale.countryCode.isEmpty ? locale.languageCode : locale.toString();
//     final String localeName = Intl.canonicalizedLocale(name);

//     return initializeMessages(localeName).then((_) {
//       Intl.defaultLocale = localeName;
//       return ValutexLocalizations();
//     });
//   }

//   static ValutexLocalizations of(BuildContext context) {
//     return Localizations.of<ValutexLocalizations>(context, ValutexLocalizations);
//   }

//   String get title {
//     return Intl.message(
//       'Hello World',
//       name: 'title',
//       desc: 'Title for the Demo application',
//     );
//   }
// }

class ValutexLocalizations {
  ValutexLocalizations(this.locale);

  final Locale locale;

  static ValutexLocalizations of(BuildContext context) {
    return Localizations.of<ValutexLocalizations>(context, ValutexLocalizations);
  }

  static Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'updated': 'Updated',
    },
    'it': {
      'updated': 'Aggiornato',
    },
  };

  String get updated {
    return _localizedValues[locale.languageCode]['updated'];
  }
}

class ValutexLocalizationsDelegate
    extends LocalizationsDelegate<ValutexLocalizations> {
  const ValutexLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['en'/*, 'it'*/].contains(locale.languageCode);

  // @override
  // Future<ValutexLocalizations> load(Locale locale) => ValutexLocalizations.load(locale);
  @override
  Future<ValutexLocalizations> load(Locale locale) {
    return SynchronousFuture<ValutexLocalizations>(
        ValutexLocalizations(locale));
  }

  @override
  bool shouldReload(ValutexLocalizationsDelegate old) => false;
}