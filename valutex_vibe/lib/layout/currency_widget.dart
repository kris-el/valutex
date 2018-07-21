import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'amount_screen.dart';
import 'currency_draft.dart';
import '../exchange_currency.dart';

typedef void InputAmountCallback(String newCurrency, num newAmount);
ExchangeCurrency exchangeCurrency = ExchangeCurrency();

class CurrencyWidget extends StatelessWidget {
  final CountryDetails countryDetails;
  final String currentAmount;
  final num maxAmount;
  final bool europeanNotation;
  final InputAmountCallback inputAmountCallBack;

  CurrencyWidget({
    Key key,
    @required this.countryDetails,
    @required this.currentAmount,
    @required this.maxAmount,
    @required this.europeanNotation,
    @required this.inputAmountCallBack,
  })  : assert(countryDetails != null),
        assert(currentAmount != null),
        assert(maxAmount != null),
        assert(europeanNotation != null),
        super(key: key);

  void openAmountScreen(BuildContext context) async {
    final amount = await Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => AmountScreen(
                  countryDetails: countryDetails,
                  initialAmount: (currentAmount == null)
                      ? 1.0
                      : double.parse(currentAmount),
                  maxAmount: maxAmount,
                ),
          ),
        );
    inputAmountCallBack(countryDetails.currencyCode, amount);
    //Scaffold.of(context).showSnackBar(SnackBar(content: Text("$amount")));
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: InkWell(
        borderRadius: BorderRadius.circular(18.0),
        child: CurrencyDraft(
          flagCode: countryDetails.flagCode,
          detail1: countryDetails.countryName,
          detail2: countryDetails.currencyName,
          tailWidget: Text(
            '${countryDetails.currencySymbol} ${exchangeCurrency.applyNotation(currentAmount, europeanNotation)}',
            style: TextStyle(fontSize: 18.0),
            textAlign: TextAlign.right,
          ),
        ),
        onTap: () {
          //_navigateToChangeAmount(context);
          openAmountScreen(context);
        },
      ),
    );
  }
}
