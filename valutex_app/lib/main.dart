import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'ui/home_screen.dart';


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
    return MaterialApp(
      debugShowCheckedModeBanner: true,
      title: 'Valutex',
      home: HomeScreen(title: 'Valutex'), // Currency converter
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.orange[800],
        accentColor: Colors.orange[600],
        toggleableActiveColor: Colors.orange[600],
        buttonColor: Colors.orange[600],
      ),
    );
  }
}
