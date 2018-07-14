import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'amount_screen.dart';

final _rowHeight = 88.0;
final _borderRadius = BorderRadius.circular(_rowHeight / 10);
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
                    : double.parse(currentAmount)),
          ),
        );
    callback(currencyCode, amount);
    //Scaffold.of(context).showSnackBar(SnackBar(content: Text("$amount")));
  }

  @override
  Widget build(BuildContext context) {
    final countryBox = Container(
      color: Colors.transparent,
      child: Image.asset(
          "assets/images/flags/country_${flagCode.toLowerCase()}_64.png",
          fit: BoxFit.fitHeight),
    );

    final detailsBox = Expanded(
      child: Padding(
          padding: EdgeInsets.all(4.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                '$countryName',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
                textAlign: TextAlign.left,
              ),
              Container(
                height: 6.0,
              ),
              Text(
                '$currencyName',
                style: TextStyle(fontSize: 14.0),
              ),
            ],
          )
          //Text('${widget.countryName}'),
          ),
    );

    final exchangeBox = Padding(
      padding: EdgeInsets.all(8.0),
      child: Center(
        child: Text(
          "$currencySymbol $currentAmount",
          style: TextStyle(fontSize: 18.0),
          textAlign: TextAlign.right,
        ),
      ),
    );

    return Material(
      child: Container(
        height: _rowHeight,
        child: InkWell(
          borderRadius: _borderRadius,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Container(width: 8.0),
              countryBox,
              Container(width: 10.0),
              detailsBox,
              exchangeBox
            ],
          ),
          onTap: () {
            //_navigateToChangeAmount(context);
            openAmount(context, countryName);
          },
        ),
      ),
    );
  }
}
