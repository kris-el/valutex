import 'package:flutter/material.dart';
import '../app_settings.dart';

AppSettings appSettings = AppSettings();

class SettingsScreen extends StatefulWidget {
  @override
  createState() => SettingsScreenState();
}

class SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final appBar = AppBar(
      title: Text('Settings'),
    );

    final listView = ListView(
      children: <Widget>[
        ListTile(
          leading: const Icon(Icons.euro_symbol),
          title: Text('European notation'),
          subtitle: Text('Apply european notation in amount'),
          trailing: Switch(
              value: appSettings.europeanNotation,
              onChanged: (value) =>
                  setState(() => appSettings.europeanNotation = value)),
        ),
        ListTile(
          leading: const Icon(Icons.strikethrough_s),
          title: Text('Fictional countries'),
          subtitle: Text('Show fictional counries'),
          trailing: Switch(
              value: appSettings.fictionalCurrencies,
              onChanged: (value) =>
                  setState(() => appSettings.fictionalCurrencies = value)),
        ),
      ],
    );
    return Scaffold(
      appBar: appBar,
      body: listView,
    );
  }
}
