import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'amount_screen.dart';
import 'currency_draft.dart';
import '../exchange_currency.dart';
import '../app_settings.dart';

typedef void InputAmountCallback(String newCurrency, num newAmount);
ExchangeCurrency exchangeCurrency = ExchangeCurrency();
AppSettings appSettings = AppSettings();

class CurrencyWidget extends StatelessWidget {
  final CountryDetails countryDetails;
  final String currentAmount;
  final num maxAmount;
  final String lang;
  final InputAmountCallback inputAmountCallBack;
  final String label;

  CurrencyWidget({
    Key key,
    @required this.countryDetails,
    @required this.currentAmount,
    @required this.maxAmount,
    @required this.inputAmountCallBack,
    @required this.lang,
    this.label,
  })  : assert(countryDetails != null),
        assert(currentAmount != null),
        assert(maxAmount != null),
        assert(lang != null),
        super(key: key);

  void openAmountScreen(BuildContext context) async {
    final amount = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AmountScreen(
              lang: lang,
              countryDetails: countryDetails,
              initialAmount:
                  (currentAmount == null) ? 1.0 : double.parse(currentAmount),
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
          label: label,
          flagCode: countryDetails.flagCode,
          detail1: countryDetails.countryNameAlt[lang],
          detail2: countryDetails.currencyNameAlt[lang],
          tailWidget: Text(
            '${countryDetails.currencySymbol} ${exchangeCurrency.applyNotation(currentAmount, appSettings.europeanNotation)}',
            style: TextStyle(fontSize: 18.0 * appSettings.scaleWidth),
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
