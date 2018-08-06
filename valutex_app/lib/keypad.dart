import 'package:meta/meta.dart';
import 'package:flutter/material.dart';
import 'app_settings.dart';

typedef void KeypadSubmitCallback();
typedef void KeypadUpdateCallBack();

AppSettings appSettings = AppSettings();

class Keypad extends StatelessWidget {
  final TextEditingController activeTextFieldController;
  final KeypadSubmitCallback onSubmit;
  final KeypadSubmitCallback onChange;
  final maxLength;
  final String shownSeparator = appSettings.europeanNotation ? ',' : '.';
  final String realSeparator = '.';
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

  Keypad({
    Key key,
    @required this.activeTextFieldController,
    @required this.onSubmit,
    this.onChange,
    this.maxLength,
  })  : assert(activeTextFieldController != null),
        super(key: key);

  void keypadButtonPressed(itemIndex) {
    int cCode = buttons[itemIndex].codeUnitAt(0);
    String text = activeTextFieldController.text;

    debugPrint('p ${buttons[itemIndex]}');
    if ((cCode >= '0'.codeUnitAt(0)) && (cCode <= '9'.codeUnitAt(0))) {
      if (maxLength != null) {
        String digits = text;
        if (digits.length >= maxLength) return;
      }
      activeTextFieldController.value =
          TextEditingValue(text: text + String.fromCharCode(cCode));
      onChange();
    } else if (itemIndex == 7) {
      if (!text.contains(realSeparator)) {
        activeTextFieldController.value =
            TextEditingValue(text: text + realSeparator);
        onChange();
      }
    } else {
      onSubmit();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0.0,
      left: 0.0,
      child: Container(
        color: Colors.blueGrey.withOpacity(0.10),
        padding: EdgeInsets.all(0.0),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.width / 4 * 3,
        child: GridView.count(
          crossAxisCount: 4,
          children: List.generate(12, (index) {
            return FlatButton(
              // shape: Border.all(
              //   color: Colors.grey.withOpacity(0.2),
              //   width: 0.5,
              //   style: BorderStyle.solid,
              // ),
              color: Colors.transparent,
              child: Center(
                child: FractionalTranslation(
                  translation:
                      ((index != 11)) ? Offset(0.0, 0.0) : Offset(-0.15, -0.1),
                  child: Text(
                    (index == 7) ? shownSeparator : buttons[index],
                    style: (index != 11)
                        ? TextStyle(fontSize: 22.0)
                        : TextStyle(fontSize: 48.0),
                  ),
                ),
              ),
              onPressed: () {
                keypadButtonPressed(index);
              },
            );
          }),
        ),
      ),
    );
  }
}
