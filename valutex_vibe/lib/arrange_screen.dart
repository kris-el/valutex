import 'package:meta/meta.dart';
import 'package:flutter/material.dart';
import 'reorderable_list.dart';

class ArrangeScreen extends StatefulWidget {
  final List currencyCountries;

  ArrangeScreen({
    Key key,
    @required this.currencyCountries,
  })  : assert(currencyCountries != null),
        super(key: key);
  @override
  createState() => _ArrangeScreenState();
}

class ItemData {
  final Key key;
  final String countryName;
  final String flagCode;
  final String currencyName;
  final String currencyCode;
  final String currencySymbol;

  const ItemData({
    @required this.key,
    @required this.countryName,
    @required this.flagCode,
    @required this.currencyName,
    @required this.currencyCode,
    @required this.currencySymbol,
  })  : assert(countryName != null),
        assert(flagCode != null),
        assert(currencyName != null),
        assert(currencyCode != null),
        assert(currencySymbol != null);
}

class _ArrangeScreenState extends State<ArrangeScreen> {
  List<ItemData> _items = [];
  List countries = [];

  @override
  void initState() {
    super.initState();
    int i = 0;
    countries = widget.currencyCountries;
    countries.where((country) => country['fav']).forEach((country) {
      _items.add(
        ItemData(
          key: ValueKey(i),
          countryName: country['countryName'],
          flagCode: country['flagCode'],
          currencyName: country['currencyName'],
          currencyCode: country['currencyCode'],
          currencySymbol: country['currencySymbol'],
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
      int i = 0;
      _items.forEach((item) {
        //debugPrint('${item.countryName} ${item.key}');
        for (var j = 0; j < countries.length; j++) {
          if (countries[j]['countryName'] == item.countryName) {
            countries[j]['sort'] = i;
            debugPrint('--- ${item.countryName} $i');
          }
        }
        countries.sort((a, b) {
          if (a['fav'] && !b['fav']) return -1;
          if (!a['fav'] && b['fav']) return 1;
          if (a['sort'] < b['sort']) return -1;
          if (a['sort'] > b['sort']) return 1;
          if (a['countryName']
                  .toString()
                  .compareTo(b['countryName'].toString()) <
              0) return -1;
          if (a['countryName']
                  .toString()
                  .compareTo(b['countryName'].toString()) >
              0) return 1;
          return 0;
        });
        /*
        item.countryName;
        var selectedCountry = widget.currencyCountries.firstWhere(
            (country) => country['countryName'] == item.countryName);
        selectedCountry['sort'] = i;*/
        i++;
      });
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

  final ItemData data;
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
