import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'currency_draft.dart';

class SelectionScreen extends StatefulWidget {
  final List currencyCountries;

  SelectionScreen({
    Key key,
    @required this.currencyCountries,
  })  : assert(currencyCountries != null),
        super(key: key);

  @override
  State<StatefulWidget> createState() => _SelectionScreenState();
}

class _SelectionScreenState extends State<SelectionScreen> {
  List countries = []; // Data countries details
  List<CurrencyDraft> _currencyWidgets = <CurrencyDraft>[];

  @override
  void initState() {
    super.initState();
    countries = widget.currencyCountries;
  }

  void updateFav(country) {
    setState(() {
      country['fav'] = !country['fav'];
    });
  }

  Widget _buildCurrencyWidgets(List<Widget> currencies) {
    return ListView.builder(
      itemBuilder: (BuildContext context, int i) {
        if (i.isOdd)
          return Divider(
            color: Colors.grey,
            indent: 0.0,
            height: 2.0,
          );
        final index = i ~/ 2;
        return currencies[index];
      },
      itemCount: currencies.length * 2,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_currencyWidgets != null) {
      _currencyWidgets.clear();
      countries.forEach((country) {
        _currencyWidgets.add(CurrencyDraft(
          flagCode: country['flagCode'],
          detail1: country['countryName'],
          detail2: country['currencyName'],
          tailWidget: InkWell(
            borderRadius: BorderRadius.circular(18.0),
            onTap: () { updateFav(country); },
            child: Container(
              //color: Colors.red[200],
              width: 64.0,
              height: 64.0,
              child: Icon(
                country['fav'] ? Icons.favorite : Icons.favorite_border,
                color: country['fav'] ? Colors.red : null,
              ),
            ),
          ),
        ));
      });
    }

    final appBar = AppBar();

    return Scaffold(
      appBar: appBar,
      body: _buildCurrencyWidgets(_currencyWidgets),
    );
  }
}
