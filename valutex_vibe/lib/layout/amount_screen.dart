import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'currency_draft.dart';
import '../exchange_currency.dart';

ExchangeCurrency exchangeCurrency = ExchangeCurrency();

class AmountScreen extends StatefulWidget {
  final CountryDetails countryDetails;
  final num initialAmount;
  final num maxAmount;

  AmountScreen({
    Key key,
    @required this.countryDetails,
    @required this.initialAmount,
    @required this.maxAmount,
  })  : assert(countryDetails != null),
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

  @override
  void initState() {
    super.initState();
    amountValue = widget.initialAmount;
    _inputTextFieldController =
        TextEditingController(text: amountValue.round().toString());
  }

  _storeAmount() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('amountInput', amountValue.toString());
    prefs.setString('currencyInput', widget.countryDetails.currencyCode);
  }

  void _updateAmoutValue(input) {
    setState(() {
      if (input == null || input.isEmpty) {
        amountValue = 1;
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
        if (amountValue > widget.maxAmount) {
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
        flagCode: widget.countryDetails.flagCode,
        detail1: widget.countryDetails.countryName,
        detail2: widget.countryDetails.currencyName,
        tailWidget: Text(
          '${widget.countryDetails.currencySymbol}    ${widget.countryDetails.currencyCode}',
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
            padding: EdgeInsets.all(0.0),
            child: RaisedButton(
              child: Text(
                'Clear',
                //style: TextStyle(color: Colors.orange[600]),
              ),
              //color: Colors.white,
              onPressed: () {
                _inputTextFieldController.clear();
              },
            ),
          ),
          Container(
            width: 56.0,
          ),
          Padding(
            padding: EdgeInsets.all(0.0),
            child: RaisedButton(
              child: Text('Ok'),
              onPressed: () {
                if (!_isValidationError) {
                  _storeAmount();
                  Navigator.pop(context, amountValue);
                }
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
          Container(height: 72.0),
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
