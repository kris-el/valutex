import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import '../app_settings.dart';

AppSettings appSettings = AppSettings();

class CurrencyDraft extends StatelessWidget {
  final String flagCode;
  final String detail1;
  final String detail2;
  final String detail3;
  final Widget tailWidget;
  final String label;

  const CurrencyDraft({
    Key key,
    @required this.flagCode,
    @required this.detail1,
    @required this.detail2,
    this.detail3,
    this.label,
    @required this.tailWidget,
  })  : assert(flagCode != null),
        assert(detail1 != null),
        assert(detail2 != null),
        assert(tailWidget != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final countryBox = Hero(
      tag:
          (label != null) ? 'f' + label : 'hero-flag-' + flagCode.toLowerCase(),
      child: Container(
        color: Colors.transparent,
        child: Image.asset(
            "assets/images/flags/country_${flagCode.toLowerCase()}_64.png",
            fit: BoxFit.fitHeight),
      ),
    );

    final detailsBox = Expanded(
      child: Hero(
        // -- Hero -- should be used when got fix transition
        tag: (label != null)
            ? 'd' + label
            : 'hero-flag-' + flagCode.toLowerCase(),
        child: Padding(
          padding: EdgeInsets.all(4.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Material(
                color: Colors.transparent,
                child: Text(
                  detail1,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0 * appSettings.scaleWidth),
                  textAlign: TextAlign.left,
                ),
              ),
              Container(
                height: 6.0,
              ),
              Material(
                color: Colors.transparent,
                child: Text(
                  detail2,
                  style: TextStyle(fontSize: 14.0 * appSettings.scaleWidth),
                ),
              ),
            ],
          ),
        ),
      ),
    );

    final exchangeBox = Padding(
      padding: EdgeInsets.all(8.0),
      child: Center(
        child: tailWidget,
      ),
    );

    return Container(
      height: 88.0,
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
    );
  }
}
