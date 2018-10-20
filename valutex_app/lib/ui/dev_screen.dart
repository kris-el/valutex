import 'package:flutter/material.dart';
import '../app_settings.dart';

AppSettings appSettings = AppSettings();

class DevScreen extends StatefulWidget {
  @override
  _DevScreenState createState() => _DevScreenState();
}

class _DevScreenState extends State<DevScreen> {
  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> _devInfo = {
      "Screen": appSettings.screenWidth.toString() +
          'x' +
          appSettings.screenHeight.toString() +
          ' ' +
          appSettings.screenRatio.toString(),
      "Scale width": appSettings.scaleWidth.toString(),
    };

    final appBar = AppBar(
      title: Text('Dev info'),
    );

    final body = ListView(
      children: _devInfo.keys.map((String property) {
        return Row(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                property,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
                child: Container(
              padding: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 10.0),
              child: Text(
                '${_devInfo[property]}',
                overflow: TextOverflow.ellipsis,
              ),
            )),
          ],
        );
      }).toList(),
    );

    return Scaffold(
      appBar: appBar,
      body: body,
    );
  }
}
