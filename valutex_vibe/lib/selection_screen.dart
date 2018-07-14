import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'currency_draft.dart';

class SelectionScreen extends StatefulWidget {
  final List<String> currencyList;

  SelectionScreen({
    Key key,
    @required this.currencyList,
  })  : assert(currencyList != null),
        super(key: key);

  @override
  State<StatefulWidget> createState() => _SelectionScreenState();
}

class _SelectionScreenState extends State<SelectionScreen> {
  @override
  Widget build(BuildContext context) {
    final appBar = AppBar();

    final body = Container(child: Text('Select currency'),);

    return Scaffold(
      appBar: appBar,
      body: body,
    );
  }
}
