import 'package:flutter/material.dart';

class AmountScreen extends StatefulWidget {
  final String countryName;

  AmountScreen({Key key, this.countryName}) : super(key: key);

  createState() => _AmountScreenState();
}

class _AmountScreenState extends State<AmountScreen> {
  @override
  Widget build(BuildContext context) {
    final appBar = AppBar(
      title: Text('Set amount'),
    );

    final body = Center(
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(widget.countryName),
          ),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: TextField(
              autofocus: true,
              keyboardType: TextInputType.number,
              style: TextStyle(fontSize: 20.0),
            ),
          ),
          RaisedButton(
            child: Text('Ok'),
            onPressed: () {
              Navigator.pop(context, 15.0);
            },
          ),
        ],
      ),
    );

    return Scaffold(appBar: appBar, body: body);
  }
}
