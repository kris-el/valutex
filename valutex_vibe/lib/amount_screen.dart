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
      child: Text(widget.countryName),
    );

    return Scaffold(
      appBar: appBar,
      body: body
    );
  }
}
