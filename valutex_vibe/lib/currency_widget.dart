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
  final InputAmountCallback inputAmountCallBack;

  const CurrencyWidget({
    Key key,
    @required this.countryName,
    @required this.flagCode,
    @required this.currencyName,
    @required this.currencyCode,
    @required this.currencySymbol,
    @required this.currentAmount,
    @required this.inputAmountCallBack,
  })  : assert(countryName != null),
        assert(flagCode != null),
        assert(currencyName != null),
        assert(currencyCode != null),
        assert(currencySymbol != null),
        assert(currentAmount != null),
        super(key: key);

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
            '$currencySymbol $currentAmount',
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
