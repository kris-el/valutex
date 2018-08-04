import 'dart:async';
import 'package:flutter/material.dart';
import 'ui/home_screen.dart';
import 'dynamic_theme.dart';
import 'app_settings.dart';

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
            title: 'Valutex',
            theme: theme,
            debugShowCheckedModeBanner: false,
            home: HomeScreen(
                title: appSettings.isInDebugMode ? 'Valutex #' : 'Valutex'),
          );
        });
  }
}
