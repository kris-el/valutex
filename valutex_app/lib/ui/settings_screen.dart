import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../app_settings.dart';
import '../dynamic_theme.dart';
import '../localization.dart';

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
        return AlertDialog(
          title: Text(AppLocalizations.of(context).settingsMsgboxTitleDataCleared),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(AppLocalizations.of(context).settingsMsgboxBodyDataCleared),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text(AppLocalizations.of(context).msgboxActionContinue),
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
          title: Text(AppLocalizations.of(context).settingsTitleAppReset),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(AppLocalizations.of(context).settingsMsgboxBodyAppReset),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text(AppLocalizations.of(context).msgboxActionAbort),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text(AppLocalizations.of(context).msgboxActionContinue),
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
      title: Text(AppLocalizations.of(context).drawerSettings),
    );

    final listView = ListView(
      children: <Widget>[
        SwitchListTile(
          secondary: const Icon(Icons.palette),
          title: Text(AppLocalizations.of(context).settingsTitleUseDarkTheme),
          subtitle:
              Text(AppLocalizations.of(context).settingsSubtitleUseDarkTheme),
          value: appSettings.darkTheme,
          onChanged: (value) => setState(() {
                appSettings.darkTheme = value;
                DynamicTheme.of(context).setDarkTheme(value);
              }),
        ),
        SwitchListTile(
          //Icon(Icons.euro_symbol)
          secondary: Icon(Icons.euro_symbol),
          title:
              Text(AppLocalizations.of(context).settingsTitleEuropeanNotation),
          subtitle: Text(
              AppLocalizations.of(context).settingsSubtitleEuropeanNotation),
          value: appSettings.europeanNotation,
          onChanged: (value) => setState(() {
                appSettings.europeanNotation = value;
                appSettings.save();
              }),
        ),
        SwitchListTile(
          secondary: const Icon(Icons.power_input),
          title: Text(AppLocalizations.of(context).settingsTitleExtraPrecision),
          subtitle:
              Text(AppLocalizations.of(context).settingsSubtitleExtraPrecision),
          value: appSettings.extraPrecision,
          onChanged: (value) => setState(() {
                appSettings.extraPrecision = value;
                appSettings.save();
              }),
        ),
        SwitchListTile(
          secondary: const Icon(Icons.input),
          title: Text(AppLocalizations.of(context).settingsTitleLimitInput),
          subtitle:
              Text(AppLocalizations.of(context).settingsSubtitleLimitInput),
          value: appSettings.inputAmountRound,
          onChanged: (value) => setState(() {
                appSettings.inputAmountRound = value;
                appSettings.save();
              }),
        ),
        SwitchListTile(
          secondary: const Icon(Icons.strikethrough_s),
          title: Text(
              AppLocalizations.of(context).settingsTitleFictionalCountries),
          subtitle: Text(
              AppLocalizations.of(context).settingsSubtitleFictionalCountries),
          value: appSettings.fictionalCurrencies,
          onChanged: (value) => setState(() {
                appSettings.fictionalCurrencies = value;
                appSettings.save();
              }),
        ),
        ListTile(
          leading: const Icon(Icons.clear_all),
          title: Text(AppLocalizations.of(context).settingsTitleAppReset),
          subtitle: Text(AppLocalizations.of(context).settingsSubtitleAppReset),
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
