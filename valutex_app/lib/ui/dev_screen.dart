import 'package:flutter/material.dart';

class DevScreen extends StatefulWidget {
  @override
  _DevScreenState createState() => _DevScreenState();
}

class _DevScreenState extends State<DevScreen> {
  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> _devInfo = {
      "Screen": MediaQuery.of(context).size.width.truncate().toString() +
          'x' +
          MediaQuery.of(context).size.height.truncate().toString() +
          ' ' +
          MediaQuery.of(context).devicePixelRatio.toString(),
    };

    final appBar = AppBar(
      title: Text('Dev info'),
    );

    final body = ListView(
      children: _devInfo.keys.map((String property) {
        return Row(
          children: <Widget>[
            new Container(
              padding: const EdgeInsets.all(10.0),
              child: new Text(
                property,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            new Expanded(
                child: new Container(
              padding: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 10.0),
              child: new Text(
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
