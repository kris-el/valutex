import 'package:flutter/material.dart';
import 'home_route.dart';

void main() => runApp(ValutexApp());

class ValutexApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: true,
      title: 'Valutex',
      home: HomeRoute(title: 'Currency converter'),
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.orange[800],
        accentColor: Colors.orange[600],
        scaffoldBackgroundColor: Color(0xFF292929),
      ),
    );
  }
}
