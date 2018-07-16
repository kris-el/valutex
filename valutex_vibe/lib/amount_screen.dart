import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'currency_draft.dart';

class AmountScreen extends StatefulWidget {
  final String countryName;
  final String flagCode;
  final String currencyName;
  final String currencyCode;
  final String currencySymbol;
  final num initialAmount;
  final num maxAmount;

  AmountScreen({
    Key key,
    @required this.countryName,
    @required this.flagCode,
    @required this.currencyName,
    @required this.currencyCode,
    @required this.currencySymbol,
    @required this.initialAmount,
    @required this.maxAmount,
  })  : assert(countryName != null),
        assert(flagCode != null),
        assert(currencyName != null),
        assert(currencyCode != null),
        assert(currencySymbol != null),
        assert(initialAmount != null),
        assert(maxAmount != null),
        super(key: key);

  createState() => _AmountScreenState();
}

class _AmountScreenState extends State<AmountScreen> {
  TextEditingController _inputTextFieldController;
  bool _isValidationError = false;
  String _textValidationError = '';
  num amountValue;

  _AmountScreenState() {
    //amountValue = widget.initAmount;
  }

  @override
  void initState() {
    super.initState();
    amountValue = widget.initialAmount;
    _inputTextFieldController =
        TextEditingController(text: amountValue.round().toString());
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
          _isValidationError = false;
        } on Exception catch (e) {
          print('Error: $e');
          _isValidationError = true;
          _textValidationError = 'Invalid number entered';
        }
        if(amountValue > widget.maxAmount) {
          _isValidationError = true;
          _textValidationError = 'Amount to high';
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final appBar = AppBar(
      title: Text('Set amount'),
    );

    final upperBox = Padding(
      padding: EdgeInsets.all(16.0),
      child: CurrencyDraft(
        flagCode: widget.flagCode,
        detail1: widget.countryName,
        detail2: widget.currencyName,
        tailWidget: Text(
          '${widget.currencySymbol}    ${widget.currencyCode}',
          style: TextStyle(fontSize: 18.0),
          textAlign: TextAlign.right,
        ),
      ),
    );

    final inputBox = Padding(
      padding: EdgeInsets.all(16.0),
      child: TextField(
        controller: _inputTextFieldController,
        decoration: InputDecoration(
          hintText: 'Currency amount',
          errorText: _isValidationError ? _textValidationError : null,
        ),
        autofocus: true,
        autocorrect: true,
        keyboardType: TextInputType.number,
        style: TextStyle(fontSize: 20.0),
        onChanged: _updateAmoutValue,
      ),
    );

    final actionBox = Container(
      color: Colors.transparent,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(32.0),
            child: RaisedButton(
              child: Text('Clear'),
              onPressed: () {
                _inputTextFieldController.clear();
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(32.0),
            child: RaisedButton(
              child: Text('Ok'),
              onPressed: () {
                if(!_isValidationError) Navigator.pop(context, amountValue);
              },
            ),
          ),
        ],
      ),
    );

    final body = Center(
      child: Column(
        children: <Widget>[
          upperBox,
          inputBox,
          actionBox,
        ],
      ),
    );

    return Scaffold(
      appBar: appBar,
      body: body,
    );
  }
}
