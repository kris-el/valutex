import 'package:flutter/material.dart';
import 'currency.dart';

class HomeRoute extends StatelessWidget {
  final localCurrencies = null; //<Currency>[];

  // Widget _buildCategoryWidgets(List<Widget> categories) {
  //   return ListView.builder(
  //     itemBuilder: (BuildContext context, int i) {
  //       if (i.isOdd) return Divider();
  //       final index = i ~/ 2;
  //       return categories[index];
  //     },
  //     itemCount: categories.length * 2 - 1,
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    final appBar = AppBar(
      title: Text('Currency converter'),
      actions: <Widget>[
        new IconButton(
            icon: new Icon(Icons.playlist_add),
            onPressed: () => debugPrint("Add element!")),
        new IconButton(
            icon: new Icon(Icons.wrap_text),
            onPressed: () => debugPrint("Sort element!")),
        new IconButton(
            icon: new Icon(Icons.refresh),
            onPressed: () => debugPrint('Refresh'))
      ],
    );

    //final listView = _buildCategoryWidgets(localCurrencies);
    final listView = Container(child: Text('Something to say'));

    return Scaffold(
      appBar: appBar,
      body: Container(
        child: Currency(
          countryName: 'Italy',
          flagCode: 'IT',
          currencyName: 'Euro',
          currencyCode: 'EUR',
          currencySymbol: '€',
        ),
      ),
    );
  }
}
