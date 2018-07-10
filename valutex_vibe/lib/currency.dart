import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

final _rowHeight = 88.0;
final _borderRadius = BorderRadius.circular(_rowHeight / 10);


class Currency extends StatelessWidget {
  final String countryName;
  final String flagCode;
  final String currencyName;
  final String currencyCode;
  final String currencySymbol;
  final double currentAmount;

  const Currency({
    Key key,
    @required this.countryName,
    @required this.flagCode,
    @required this.currencyName,
    @required this.currencyCode,
    @required this.currencySymbol,
    @required this.currentAmount,
  })  : assert(countryName != null),
        assert(flagCode != null),
        assert(currencyName != null),
        assert(currencyCode != null),
        assert(currencySymbol != null),
        assert(currentAmount != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final countryBox = Padding(
      padding: EdgeInsets.all(0.0),
      child: Container(
        color: Colors.transparent,
        child: Image.asset(
            "assets/images/flags/country_${flagCode.toLowerCase()}_64.png",
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
                      '$countryName',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 18.0),
                      textAlign: TextAlign.left,
                    )),
                Container(
                  height: 6.0,
                ),
                Container(
                    color: Colors.transparent,
                    child: Text(
                      '$currencyName',
                      style: TextStyle(fontSize: 14.0),
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
            "$currencySymbol $currentAmount",
            style: TextStyle(fontSize: 18.0),
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
