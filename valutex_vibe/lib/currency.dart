import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'amount_screen.dart';
import 'currency_core.dart';

typedef void InputCallback(String newCurrency, num newAmount);

class Currency extends StatelessWidget {
  final String countryName;
  final String flagCode;
  final String currencyName;
  final String currencyCode;
  final String currencySymbol;
  final String currentAmount;
  final InputCallback callback;

  const Currency({
    Key key,
    @required this.countryName,
    @required this.flagCode,
    @required this.currencyName,
    @required this.currencyCode,
    @required this.currencySymbol,
    @required this.currentAmount,
    @required this.callback,
  })  : assert(countryName != null),
        assert(flagCode != null),
        assert(currencyName != null),
        assert(currencyCode != null),
        assert(currencySymbol != null),
        assert(currentAmount != null),
        super(key: key);

  void openAmount(BuildContext context, String countryName) async {
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
                ),
          ),
        );
    callback(currencyCode, amount);
    //Scaffold.of(context).showSnackBar(SnackBar(content: Text("$amount")));
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: InkWell(
        borderRadius: BorderRadius.circular(18.0),
        child: CurrencyCore(
          flagCode: flagCode,
          detail1: countryName,
          detail2: currencyName,
          tail: '$currencySymbol $currentAmount',
        ),
        onTap: () {
          //_navigateToChangeAmount(context);
          openAmount(context, countryName);
        },
      ),
    );
  }
}
