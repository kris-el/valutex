import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'amount_screen.dart';
import 'currency_draft.dart';

typedef void InputAmountCallback(String newCurrency, num newAmount);

class CurrencyWidget extends StatelessWidget {
  final String countryName;
  final String flagCode;
  final String currencyName;
  final String currencyCode;
  final String currencySymbol;
  final String currentAmount;
  final num maxAmount;
  final bool europeanNotation;
  final InputAmountCallback inputAmountCallBack;

  const CurrencyWidget({
    Key key,
    @required this.countryName,
    @required this.flagCode,
    @required this.currencyName,
    @required this.currencyCode,
    @required this.currencySymbol,
    @required this.currentAmount,
    @required this.maxAmount,
    @required this.europeanNotation,
    @required this.inputAmountCallBack,
  })  : assert(countryName != null),
        assert(flagCode != null),
        assert(currencyName != null),
        assert(currencyCode != null),
        assert(currencySymbol != null),
        assert(currentAmount != null),
        assert(maxAmount != null),
        assert(europeanNotation != null),
        super(key: key);

  String applyNotation(String number, bool euNotation) {
    String char;
    String output = '';
    bool startCount = number.indexOf('.') == -1;
    int intpart = 0;

    for (int i = number.length - 1; i >= 0; i--) {
      char = number[i];
      if (startCount) intpart++;
      if ((char == '.')) {
        if (euNotation) char = ',';
        startCount = true;
      }
      output = char + output;
      if (euNotation) {
        if ((intpart % 3 == 0) && (i != 0) && (intpart > 0))
          output = '.' + output;
      } else {
        if ((intpart % 3 == 0) && (i != 0) && (intpart > 0))
          output = ',' + output;
      }
    }
    return output;
  }

  void openAmountScreen(BuildContext context, String countryName) async {
    final amount = await Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => AmountScreen(
                  countryName: countryName,
                  flagCode: flagCode,
                  currencyName: currencyName,
                  currencyCode: currencyCode,
                  currencySymbol: currencySymbol,
                  initialAmount: (currentAmount == null)
                      ? 1.0
                      : double.parse(currentAmount),
                  maxAmount: maxAmount,
                ),
          ),
        );
    inputAmountCallBack(currencyCode, amount);
    //Scaffold.of(context).showSnackBar(SnackBar(content: Text("$amount")));
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: InkWell(
        borderRadius: BorderRadius.circular(18.0),
        child: CurrencyDraft(
          flagCode: flagCode,
          detail1: countryName,
          detail2: currencyName,
          tailWidget: Text(
            '$currencySymbol ${applyNotation(currentAmount, europeanNotation)}',
            style: TextStyle(fontSize: 18.0),
            textAlign: TextAlign.right,
          ),
        ),
        onTap: () {
          //_navigateToChangeAmount(context);
          openAmountScreen(context, countryName);
        },
      ),
    );
  }
}
