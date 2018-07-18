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
  TextEditingController _searchTextFieldController;
  List countries = []; // Data countries details
  List<CurrencyDraft> _currencyWidgets = <CurrencyDraft>[];
  String searchText = '';

  @override
  void initState() {
    super.initState();
    countries = widget.currencyCountries;
    _searchTextFieldController = TextEditingController(text: '');
  }

  void _updateFav(country) {
    setState(() {
      country['fav'] = !country['fav'];
    });
  }

  void _updateSearchText(input) {
    setState(() {
      searchText = input;
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
      countries.where((country) {
        if (searchText == '') return country['fav'];
        if (country['countryNormName']
            .toString()
            .contains(searchText.toLowerCase())) return true;
        if (country['currencyName']
            .toString()
            .toLowerCase()
            .contains(searchText.toLowerCase())) return true;
        if (country['currencyCode']
            .toString()
            .toLowerCase()
            .contains(searchText.toLowerCase())) return true;
        return false;
      }).forEach((country) {
        _currencyWidgets.add(CurrencyDraft(
          flagCode: country['flagCode'],
          detail1: country['countryName'],
          detail2: country['currencyName'],
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
                country['fav'] ? Icons.favorite : Icons.favorite_border,
                color: country['fav'] ? Colors.red : null,
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
        style: TextStyle(
            //color: Colors.white,
            ),
        decoration: new InputDecoration(
            prefixIcon: new Icon(Icons.search, color: Colors.white),
            hintText: "Search...",
            hintStyle: new TextStyle(color: Colors.white)),
      ),
      actions: <Widget>[
        /*IconButton(
          icon: Icon(Icons.clear),
          onPressed: () { _searchTextFieldController.clear(); },
        ),*/
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
