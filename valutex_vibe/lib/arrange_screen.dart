import 'package:meta/meta.dart';
import 'package:flutter/material.dart';

class ArrangeScreen extends StatefulWidget {
  final List currencyCountries;

  ArrangeScreen({
    Key key,
    @required this.currencyCountries,
  })  : assert(currencyCountries != null),
        super(key: key);
  @override
  createState() => _ArrangeScreenState();
}

class _ArrangeScreenState extends State<ArrangeScreen> {
  final appBar = AppBar(title: Text('Arrange currencies'),);

  final body = Container(
    child: Text('Sort countries'),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      body: body,
    );
  }
}
