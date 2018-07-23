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
          leading: const Icon(Icons.save),
          title: Text('Save input'),
          subtitle: Text('Store amount input in the app'),
          trailing: Switch(
              value: appSettings.rememberInput,
              onChanged: (value) => setState(() {
                    appSettings.rememberInput = value;
                    appSettings.save();
                  })),
        ),
        ListTile(
          leading: const Icon(Icons.euro_symbol),
          title: Text('European notation'),
          subtitle: Text('Apply european notation in amount'),
          trailing: Switch(
              value: appSettings.europeanNotation,
              onChanged: (value) => setState(() {
                    appSettings.europeanNotation = value;
                    appSettings.save();
                  })),
        ),
        ListTile(
          leading: const Icon(Icons.power_input),
          title: Text('Smarth approximation'),
          subtitle: Text('Approximate unnecessary precision'),
          trailing: Switch(
              value: appSettings.amountAppoximation,
              onChanged: (value) => setState(() {
                    appSettings.amountAppoximation = value;
                    appSettings.save();
                  })),
        ),
        ListTile(
          leading: const Icon(Icons.strikethrough_s),
          title: Text('Fictional countries'),
          subtitle: Text('Show fictional counries'),
          trailing: Switch(
              value: appSettings.fictionalCurrencies,
              onChanged: (value) => setState(() {
                    appSettings.fictionalCurrencies = value;
                    appSettings.save();
                  })),
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
