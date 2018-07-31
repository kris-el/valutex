import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'currency_draft.dart';
import '../exchange_currency.dart';
import '../keypad.dart';
import '../app_settings.dart';

ExchangeCurrency exchangeCurrency = ExchangeCurrency();
AppSettings appSettings = AppSettings();

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
  final bool enableClear = false;
  final bool useAmountPrefix = true;
  final int maxLength = 12;
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

  void _updateAmoutValue(String input) {
    if (appSettings.europeanNotation) {
      input = input.replaceAll('.', '');
      input = input.replaceAll(',', '.');
    } else {
      input = input.replaceAll(',', '');
    }
    // if (input.length > maxLength) {
    //   input = input.substring(0, maxLength - 1);
    // }
    // _inputTextFieldController.value = TextEditingValue(text: input);

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

  String amountPrefix() {
    if (!useAmountPrefix) return '';
    if (_inputTextFieldController.text.length == 0) return '';
    return widget.countryDetails.currencySymbol + ' ';
  }

  @override
  Widget build(BuildContext context) {
    final appBar = AppBar(
      title: Text('Set amount'),
    );

    final upperBox = Padding(
      padding: EdgeInsets.all(0.0),
      child: CurrencyDraft(
        flagCode: widget.countryDetails.flagCode,
        detail1: widget.countryDetails.countryName,
        detail2: widget.countryDetails.currencyName,
        tailWidget: Text(
          (useAmountPrefix)
              ? '${widget.countryDetails.currencyCode}'
              : '${widget.countryDetails.currencySymbol}    ${widget.countryDetails.currencyCode}',
          style: TextStyle(fontSize: 18.0),
          textAlign: TextAlign.right,
        ),
      ),
    );

    final inputBox = Padding(
      padding: EdgeInsets.all(16.0),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Stack(
              //alignment: const Alignment(1.0, 0.0),
              children: <Widget>[
                TextField(
                  controller: _inputTextFieldController,
                  decoration: InputDecoration(
                    hintText: 'Currency amount',
                    errorText: _isValidationError ? _textValidationError : null,
                  ),
                  style: TextStyle(fontSize: 32.0, color: Colors.transparent),
                  onChanged: _updateAmoutValue,
                ),
                Container(
                  color: Colors.transparent,
                  //padding: EdgeInsets.all(40.0),
                  height: 160.0,
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.only(top: 0.0, right: 12.0),
                        child: Text(
                          '${amountPrefix()}${_inputTextFieldController.text}',
                          style: TextStyle(fontSize: 32.0),
                          textAlign: TextAlign.end,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.backspace),
                      padding: EdgeInsets.all(12.0),
                      iconSize: 32.0,
                      onPressed: () {
                        {
                          String text = _inputTextFieldController.text;
                          if (text.length > 0) {
                            text = text.substring(0, text.length - 1);
                            _inputTextFieldController.value =
                                TextEditingValue(text: text);
                            _updateAmoutValue(text);
                          }
                        }
                      },
                    ),
                    (enableClear)
                        ? IconButton(
                            icon: Icon(Icons.clear),
                            padding: EdgeInsets.all(12.0),
                            iconSize: 36.0,
                            onPressed: () {
                              _inputTextFieldController.clear();
                              _updateAmoutValue('');
                            },
                          )
                        : Container(),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );

    final body = Stack(
      children: <Widget>[
        Container(
          child: Column(
            children: <Widget>[
              upperBox,
              inputBox,
            ],
          ),
        ),
        Keypad(
          activeTextFieldController: _inputTextFieldController,
          onSubmit: () {
            _updateAmoutValue(_inputTextFieldController.text);
            if (!_isValidationError) {
              _storeAmount();
              Navigator.pop(context, amountValue);
            }
          },
          onChange: () {
            _updateAmoutValue(_inputTextFieldController.text);
          },
        ),
      ],
    );

    return Scaffold(
      appBar: appBar,
      body: body,
    );
  }
}
