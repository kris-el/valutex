import 'package:flutter/material.dart';

class AmountScreen extends StatefulWidget {
  final String countryName;
  final double initialAmount;

  AmountScreen({
    Key key,
    this.countryName,
    this.initialAmount,
  })  : assert(countryName != null),
        assert(initialAmount != null),
        super(key: key);

  createState() => _AmountScreenState();
}

class _AmountScreenState extends State<AmountScreen> {
  TextEditingController _controller;
  bool _showValidationError = false;
  double amountValue;

  _AmountScreenState() {
    //amountValue = widget.initAmount;
  }

  @override
  void initState() {
    super.initState();
    amountValue = widget.initialAmount;
    _controller = TextEditingController(text: amountValue.toString());
  }

  void _updateAmoutValue(input) {
    setState(() {
      if (input == null || input.isEmpty) {
        amountValue = 1.0;
      } else {
        // Even though we are using the numerical keyboard, we still have to check
        // for non-numerical input such as '5..0' or '6 -3'
        try {
          amountValue = double.parse(input);
          _showValidationError = false;
        } on Exception catch (e) {
          print('Error: $e');
          _showValidationError = true;
        }
      }
    });
  }

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
              controller: _controller,
              decoration: InputDecoration(
                hintText: 'Currency amount',
                errorText:
                    _showValidationError ? 'Invalid number entered' : null,
              ),
              autofocus: true,
              autocorrect: true,
              keyboardType: TextInputType.number,
              style: TextStyle(fontSize: 20.0),
              onChanged: _updateAmoutValue,
            ),
          ),
          RaisedButton(
            child: Text('Ok'),
            onPressed: () {
              Navigator.pop(context, amountValue);
            },
          ),
        ],
      ),
    );

    return Scaffold(appBar: appBar, body: body);
  }
}
