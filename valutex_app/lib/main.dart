import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'ui/home_screen.dart';
import 'dynamic_theme.dart';
import 'app_settings.dart';
import 'localization.dart';

AppSettings appSettings = AppSettings();

void main() {
  runZoned(() {
    runApp(ValutexApp());
  }, onError: (dynamic error, dynamic stack) {
    debugPrint(error);
    debugPrint(stack);
  });
}

class ValutexApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DynamicTheme(
        defaultDarkTheme: appSettings.darkTheme,
        data: (brightness) => ThemeData(
              brightness: brightness,
              primaryColor: Colors.orange[800],
              accentColor: Colors.orange[600],
              toggleableActiveColor: Colors.orange[600],
              buttonColor: Colors.orange[600],
            ),
        themedWidgetBuilder: (context, theme) {
          return MaterialApp(
            localizationsDelegates: [
              const AppLocalizationsDelegate(),
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
            ],
            supportedLocales: [
              const Locale('en', 'US'),
              const Locale('it', 'IT'),
              const Locale('th', 'TH'),
              const Locale('vi', 'VI'),
              // const Locale('fr', 'FR'),
              // const Locale('ko', 'KR'),
              // const Locale('sp', 'SP'),
            ],
            title: 'Valutex',
            theme: theme,
            debugShowCheckedModeBanner: false,
            home: HomeScreen(
                title: appSettings.isInDebugMode ? 'Valutex #' : 'Valutex'),
          );
        });
  }
}

/*
[2.1.2] #13
Feature discovery tutorial

[2.1.1] #12
Fixed hero animation
Long press to clear input
Localize country data on server side
Display localized info
Localization IT, TH, VN
Set notation accordingly to system language

[2.1.0] #10
Fix zero amount

[2.0.9] #9
Optimization for release

[2.0.6] #4
Apply notation to "Set amount" screen

[2.0.5] #3
Settings names are rewritten to be more meaningfull
The switch in settings now work from all the row
Added settings to control amount rounding
Added settings App reset
Fix bug: Switching approximation ruins the amount
Fix: Bitcoin amount reppresentation
*/
