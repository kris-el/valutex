import 'package:flutter/material.dart';

class Keypad extends StatelessWidget {
  final List buttons = [
    '7',
    '8',
    '9',
    '0',
    '4',
    '5',
    '6',
    '.',
    '1',
    '2',
    '3',
    '↲'
  ];

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0.0,
      left: 0.0,
      child: Container(
        color: Colors.blueGrey[800],
        padding: EdgeInsets.all(0.0),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.width / 4 * 3,
        child: GridView.count(
          crossAxisCount: 4,
          // Generate 100 Widgets that display their index in the List
          children: List.generate(12, (index) {
            return InkWell(
              borderRadius: BorderRadius.circular(10.0),
              splashColor: Colors.orangeAccent,
              highlightColor: Colors.green,
              child: Container(
                child: Center(
                  child: FractionalTranslation(
                    translation: ((index != 11))
                        ? Offset(0.0, 0.0)
                        : Offset(-0.25, -0.15),
                    child: Text(
                      '${buttons[index]}',
                      style: ((index != 11))
                          ? TextStyle(fontSize: 22.0)
                          : TextStyle(fontSize: 48.0),
                    ),
                  ),
                ),
              ),
              onTap: () {
                //_inputTextFieldController.value = TextEditingValue(text: '123');
                debugPrint('p ${buttons[index]}');
              },
            );
          }),
        ),
      ),
    );
  }
}
