import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../app_settings.dart';
import '../dynamic_theme.dart';

AppSettings appSettings = AppSettings();

class SettingsScreen extends StatefulWidget {
  @override
  createState() => SettingsScreenState();
}

class SettingsScreenState extends State<SettingsScreen> {
  @override
  void initState() {
    super.initState();
    appSettings.darkTheme = DynamicTheme.of(context).getDarkTheme();
  }

  Future<Null> _reopenAppAlertDialog() async {
  return showDialog<Null>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return new AlertDialog(
        title: new Text('Data cleared'),
        content: new SingleChildScrollView(
          child: new ListBody(
            children: <Widget>[
              new Text('Close and open the app again.'),
            ],
          ),
        ),
        actions: <Widget>[
          new FlatButton(
            child: new Text('Continue'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

  Future<Null> clearPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  Future<Null> _appResetAlertDialog() async {
    return showDialog<Null>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('App reset'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Do you want to delete all your app data?\n'),
                Text(
                    'If you continue you will lose all your preferences, bringing back the application as just downloaded state.'),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Abort'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text('Continue'),
              onPressed: () {
                clearPreferences();
                Navigator.of(context).pop();
                _reopenAppAlertDialog();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final appBar = AppBar(
      title: Text('Settings'),
    );

    final listView = ListView(
      children: <Widget>[
        SwitchListTile(
          secondary: const Icon(Icons.palette),
          title: Text('Use dark theme'),
          subtitle: Text('Use theme more relaxing for your eyes'),
          value: appSettings.darkTheme,
          onChanged: (value) => setState(() {
                appSettings.darkTheme = value;
                DynamicTheme.of(context).setDarkTheme(value);
              }),
        ),
        SwitchListTile(
          //Icon(Icons.euro_symbol)
          secondary: Icon(Icons.euro_symbol),
          title: Text('European notation'),
          subtitle: Text('Change the separator of thousands and decimals'),
          value: appSettings.europeanNotation,
          onChanged: (value) => setState(() {
                appSettings.europeanNotation = value;
                appSettings.save();
              }),
        ),
        SwitchListTile(
          secondary: const Icon(Icons.power_input),
          title: Text('Extra precision'),
          subtitle: Text('Increase precision of one significant digit in amounts calculation'),
          value: appSettings.extraPrecision,
          onChanged: (value) => setState(() {
                appSettings.extraPrecision = value;
                appSettings.save();
              }),
        ),
        SwitchListTile(
          secondary: const Icon(Icons.input),
          title: Text('Limit input to decimalas'),
          subtitle: Text('Rounds the amount input in "Set amount" screen.'),
          value: appSettings.inputAmountRound,
          onChanged: (value) => setState(() {
                appSettings.inputAmountRound = value;
                appSettings.save();
              }),
        ),
        SwitchListTile(
          secondary: const Icon(Icons.strikethrough_s),
          title: Text('Fictional countries'),
          subtitle: Text('Show fictional counries'),
          value: appSettings.fictionalCurrencies,
          onChanged: (value) => setState(() {
                appSettings.fictionalCurrencies = value;
                appSettings.save();
              }),
        ),
        ListTile(
          leading: const Icon(Icons.clear_all),
          title: Text('App reset'),
          subtitle: Text('Clear all app data'),
          onTap: () {
            _appResetAlertDialog();
          },
        ),
      ],
    );
    return Scaffold(
      appBar: appBar,
      body: listView,
    );
  }
}

//crop_free -> approx
