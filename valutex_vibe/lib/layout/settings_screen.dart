import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  final Map settings;

  SettingsScreen({
    Key key,
    @required this.settings,
  })  : assert(settings != null),
        super(key: key);

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
              value: widget.settings['europeanNotation'],
              onChanged: (value) =>
                  setState(() => widget.settings['europeanNotation'] = value)),
        )
      ],
    );

    return Scaffold(
      appBar: appBar,
      body: listView,
    );
  }
}
