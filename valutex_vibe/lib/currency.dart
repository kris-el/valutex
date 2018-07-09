import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

final _rowHeight = 88.0;
final _borderRadius = BorderRadius.circular(_rowHeight / 10);
String currentAmount = '1500.50';

class Currency extends StatefulWidget {
  final String countryName;
  final String flagCode;
  final String currencyName;
  final String currencyCode;
  final String currencySymbol;

  const Currency({
    Key key,
    @required this.countryName,
    @required this.flagCode,
    @required this.currencyName,
    @required this.currencyCode,
    @required this.currencySymbol,
  })  : assert(countryName != null),
        assert(flagCode != null),
        assert(currencyName != null),
        assert(currencyCode != null),
        assert(currencySymbol != null),
        super(key: key);

  @override
  createState() => CurrencyState();
}

class CurrencyState extends State<Currency> {
  String currentAmount = '1500.50';
  String countryCurrencyInput = 'Europe';

  @override
  Widget build(BuildContext context) {
    final countryBox = Padding(
      padding: EdgeInsets.all(0.0),
      child: Container(
        color: Colors.transparent,
        child: Image.asset(
            "assets/images/flags/country_${widget.flagCode.toLowerCase()}_64.png",
            fit: BoxFit.fitHeight),
      ),
    );

    final detailsBox = Expanded(
      child: Padding(
        padding: EdgeInsets.all(4.0),
        child: Container(
            color: Colors.transparent,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                    color: Colors.transparent,
                    child: Text(
                      '${widget.countryName}',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 20.0),
                      textAlign: TextAlign.left,
                    )),
                Container(
                  height: 6.0,
                ),
                Container(
                    color: Colors.transparent,
                    child: Text(
                      '${widget.currencyName}',
                      style: TextStyle(fontSize: 18.0),
                    ))
              ],
            )
            //Text('${widget.countryName}'),
            ),
      ),
    );

    final exchangeBox = Padding(
      padding: EdgeInsets.all(8.0),
      child: Container(
        color: Colors.transparent,
        child: Center(
          child: Text(
            "${widget.currencySymbol} $currentAmount",
            style: TextStyle(fontSize: 20.0),
            textAlign: TextAlign.right,
          ),
        ),
      ),
    );

    return Material(
      color: Colors.transparent,
      child: Container(
        height: _rowHeight,
        child: InkWell(
          borderRadius: _borderRadius,
          child: Padding(
            padding: EdgeInsets.all(0.0),
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
          ),
          onTap: () {
            //_navigateToChangeAmount(context);
            debugPrint('Currency Tapped');
          },
        ),
      ),
    );
  }
}
