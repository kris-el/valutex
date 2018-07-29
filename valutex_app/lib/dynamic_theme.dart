import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

typedef Widget ThemedWidgetBuilder(BuildContext context, ThemeData data);

typedef ThemeData ThemeDataWithBrightnessBuilder(Brightness brightness);

class DynamicTheme extends StatefulWidget {
  final ThemedWidgetBuilder themedWidgetBuilder;

  final ThemeDataWithBrightnessBuilder data;

  final bool defaultDarkTheme;

  const DynamicTheme(
      {Key key, this.data, this.themedWidgetBuilder, this.defaultDarkTheme})
      : super(key: key);

  @override
  DynamicThemeState createState() => new DynamicThemeState();

  static DynamicThemeState of(BuildContext context) {
    return context.ancestorStateOfType(const TypeMatcher<DynamicThemeState>());
  }
}

class DynamicThemeState extends State<DynamicTheme> {
  ThemeData _data;

  bool _darkTheme;

  static const String _sharedPreferencesKey = "isDark";

  bool loaded = false;

  @override
  void initState() {
    super.initState();
    _darkTheme = widget.defaultDarkTheme;
    _data = widget.data(_darkTheme ? Brightness.dark : Brightness.light);

    loadBrightness().then((dark) {
      setState(() {
        _darkTheme = dark;
        _data = widget.data(_darkTheme ? Brightness.dark : Brightness.light);
        loaded = true;
      });
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _data = widget.data(_darkTheme ? Brightness.dark : Brightness.light);
  }

  @override
  void didUpdateWidget(DynamicTheme oldWidget) {
    super.didUpdateWidget(oldWidget);
    _data = widget.data(_darkTheme ? Brightness.dark : Brightness.light);
  }

  @override
  Widget build(BuildContext context) {
    return widget.themedWidgetBuilder(context, _data);
  }

  void setDarkTheme(bool dark) async {
    Brightness brightness;
    brightness = dark ? Brightness.dark : Brightness.light;
    setState(() {
      this._data = widget.data(brightness);
      this._darkTheme = dark;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(
        _sharedPreferencesKey, brightness == Brightness.dark ? true : false);
  }

  bool getDarkTheme() => _darkTheme;

  void setThemeData(ThemeData data) {
    setState(() {
      this._data = data;
    });
  }

  Future<bool> loadBrightness() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return (prefs.getBool(_sharedPreferencesKey) ?? _darkTheme);
  }
}
