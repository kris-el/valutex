import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'currency_draft.dart';
import '../reorderable_list.dart';
import '../exchange_currency.dart';
import '../localization.dart';

ExchangeCurrency exchangeCurrency = ExchangeCurrency();

class ArrangeScreen extends StatefulWidget {
  final String lang;

  ArrangeScreen({
    Key key,
    @required this.lang,
  })  : assert(lang != null),
        super(key: key);

  @override
  createState() => _ArrangeScreenState();
}

class _ArrangeScreenState extends State<ArrangeScreen> {
  List<CountryDetails> _items = [];

  @override
  void initState() {
    super.initState();
    int i = 0;

    exchangeCurrency.countryList
        .where((country) => country.fav)
        .forEach((country) {
      _items.add(
        CountryDetails(
          key: ValueKey(i),
          countryIndex: country.countryIndex,
          countryNameTr: country.countryNameTr,
          countryNameNormEn: country.countryNameNormEn,
          countryNameNormTr: country.countryNameNormTr,
          currencyNameTr: country.currencyNameTr,
          currencyNameNormEn: country.currencyNameNormEn,
          currencyNameNormTr: country.currencyNameNormTr,
          flagCode: country.flagCode,
          currencyCode: country.currencyCode,
          currencySymbol: country.currencySymbol,
        ),
      );
      i++;
    });
  }

  // Returns index of item with given key
  int _indexOfKey(Key key) {
    for (int i = 0; i < _items.length; ++i) {
      if (_items[i].key == key) return i;
    }
    return -1;
  }

  _saveFavourites() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList('favourites', exchangeCurrency.favourites);
  }

  bool _reorderCallback(Key item, Key newPosition) {
    int draggingIndex = _indexOfKey(item);
    int newPositionIndex = _indexOfKey(newPosition);

    final draggedItem = _items[draggingIndex];
    setState(() {
      _items.removeAt(draggingIndex);
      _items.insert(newPositionIndex, draggedItem);

      List<String> favList = [];
      _items.forEach((item) {
        favList.add(item.countryIndex);
      });
      exchangeCurrency.favourites = favList;
      _saveFavourites();
    });
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final appBar = AppBar(
      title: Text(AppLocalizations.of(context).screenTitleArrangeCurrencies),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.send),
          onPressed: () {
            Navigator.pop(context);
          },
        )
      ],
    );

    final body = Column(
      children: <Widget>[
        Expanded(
          child: ReorderableList(
            onReorder: _reorderCallback,
            child: ListView.builder(
              itemCount: _items.length,
              itemBuilder: (BuildContext c, index) => Item(
                  data: _items[index],
                  first: index == 0,
                  last: index == _items.length - 1),
            ),
          ),
        )
      ],
    );

    return Scaffold(
      appBar: appBar,
      body: body,
    );
  }
}

class Item extends StatelessWidget {
  Item({this.data, this.first, this.last});

  final CountryDetails data;
  final bool first;
  final bool last;

  // Builds decoration for list item; During dragging we don't want top border on first item
  // and bottom border on last item
  BoxDecoration _buildDecoration(BuildContext context, bool dragging) {
    return BoxDecoration(
        border: Border(
            top: first && !dragging
                ? Divider.createBorderSide(context, color: Colors.grey) //
                : BorderSide.none,
            bottom: last && dragging
                ? BorderSide.none //
                : Divider.createBorderSide(context, color: Colors.grey)));
  }

  Widget _buildChild(BuildContext context, bool dragging) {
    return Container(
      // slightly transparent background white dragging (just like on iOS)
      decoration: BoxDecoration(
        color: dragging ? Colors.grey : null,
      ),
      child: SafeArea(
        top: false,
        bottom: false,
        child: CurrencyDraft(
          flagCode: data.flagCode,
          detail1: data.countryNameTr,
          detail2: data.currencyNameTr + ' (' + data.currencyCode + ')',
          tailWidget: Padding(
            padding: EdgeInsets.all(10.0),
            child: Icon(
              Icons.drag_handle,
              size: 48.0,
              color: dragging ? Colors.grey[200] : null,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ReorderableItem(
        key: data.key, //
        childBuilder: _buildChild,
        decorationBuilder: _buildDecoration);
  }
}
