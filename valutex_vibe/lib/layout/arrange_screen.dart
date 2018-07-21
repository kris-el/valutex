import 'package:flutter/material.dart';
import '../reorderable_list.dart';
import '../exchange_currency.dart';

ExchangeCurrency exchangeCurrency = ExchangeCurrency();

class ArrangeScreen extends StatefulWidget {
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
          countryName: country.countryName,
          countryNormName: country.countryNormName,
          flagCode: country.flagCode,
          currencyName: country.currencyName,
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

  bool _reorderCallback(Key item, Key newPosition) {
    int draggingIndex = _indexOfKey(item);
    int newPositionIndex = _indexOfKey(newPosition);

    final draggedItem = _items[draggingIndex];
    setState(() {
      debugPrint(
          "Reordering " + item.toString() + " -> " + newPosition.toString());
      _items.removeAt(draggingIndex);
      _items.insert(newPositionIndex, draggedItem);

      List<String> favList = [];
      _items.forEach((item) {
        favList.add(item.countryName);
      });
      exchangeCurrency.favourites = favList;
    });
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final appBar = AppBar(
      title: Text('Arrange currencies'),
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
                ? Divider.createBorderSide(context) //
                : BorderSide.none,
            bottom: last && dragging
                ? BorderSide.none //
                : Divider.createBorderSide(context)));
  }

  Widget _buildChild(BuildContext context, bool dragging) {
    return Container(
        // slightly transparent background white dragging (just like on iOS)
        decoration:
            BoxDecoration(color: dragging ? Color(0xD0FFFFFF) : Colors.grey),
        child: SafeArea(
            top: false,
            bottom: false,
            child: Row(
              children: <Widget>[
                Expanded(
                    child: Text(data.countryName,
                        style: Theme.of(context).textTheme.subhead)),
                Icon(Icons.reorder,
                    color: dragging ? Color(0xFF555555) : Color(0xFF888888)),
              ],
            )),
        padding: new EdgeInsets.symmetric(vertical: 14.0, horizontal: 14.0));
  }

  @override
  Widget build(BuildContext context) {
    return ReorderableItem(
        key: data.key, //
        childBuilder: _buildChild,
        decorationBuilder: _buildDecoration);
  }
}
