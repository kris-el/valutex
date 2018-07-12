import 'package:flutter/material.dart';

class AmountRoute extends StatefulWidget {
  final String countryName;

  AmountRoute({Key key, this.countryName}) : super(key: key);

  createState() => AmountRouteState();
}

class AmountRouteState extends State<AmountRoute> {

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
