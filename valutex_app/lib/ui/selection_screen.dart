import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'currency_draft.dart';
import '../exchange_currency.dart';
import '../localization.dart';

ExchangeCurrency exchangeCurrency = ExchangeCurrency();

class SelectionScreen extends StatefulWidget {
  final String lang;

  SelectionScreen({
    Key key,
    @required this.lang,
  })  : assert(lang != null),
        super(key: key);

  @override
  State<StatefulWidget> createState() => _SelectionScreenState();
}

class _SelectionScreenState extends State<SelectionScreen> {
  TextEditingController _searchTextFieldController;
  List<CurrencyDraft> _currencyWidgets = <CurrencyDraft>[];
  String searchText = '';

  @override
  void initState() {
    super.initState();
    _searchTextFieldController = TextEditingController(text: '');
  }

  void _updateFav(CountryDetails country) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      country.fav = !country.fav;
      prefs.setStringList('favourites', exchangeCurrency.favourites);
    });
  }

  void _updateSearchText(input) {
    setState(() {
      searchText = input;
    });
  }

  void _clearSearchText() {
    _searchTextFieldController.clear();
    setState(() {
      searchText = '';
    });
    FocusScope.of(context).requestFocus(FocusNode());
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
      exchangeCurrency.searchCountries(searchText).forEach((country) {
        _currencyWidgets.add(CurrencyDraft(
          flagCode: country.flagCode,
          detail1: country.countryNameTr,
          detail2: country.currencyNameTr + ' (' + country.currencyCode + ')',
          tailWidget: InkWell(
            borderRadius: BorderRadius.circular(18.0),
            onTap: () {
              _updateFav(country);
            },
            child: Container(
              //color: Colors.red[200],
              width: 64.0,
              height: 64.0,
              child: Icon(
                country.fav ? Icons.favorite : Icons.favorite_border,
                color: country.fav ? Colors.red : null,
              ),
            ),
          ),
        ));
      });
    }

    final appBar = AppBar(
      title: TextField(
        controller: _searchTextFieldController,
        onChanged: _updateSearchText,
        decoration: InputDecoration(
            prefixIcon: Icon(Icons.search, color: Colors.white),
            hintText: AppLocalizations.of(context).inputPlaceHolderSearch,
            hintStyle: TextStyle(color: Colors.white)),
      ),
      actions: <Widget>[
        IconButton(icon: Icon(Icons.clear), onPressed: _clearSearchText),
        IconButton(
          icon: Icon(Icons.send),
          onPressed: () {
            Navigator.pop(context);
          },
        )
      ],
    );

    return Scaffold(
      appBar: appBar,
      body: _buildCurrencyWidgets(_currencyWidgets),
    );
  }
}
