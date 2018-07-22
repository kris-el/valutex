class AppSettings {
  static final AppSettings _singleton = AppSettings._internal();
  factory AppSettings() {
    return _singleton;
  }
  AppSettings._internal();

  String amountNotation = 'eu';
  bool amountAppoximation = true;
  bool rememberInput = true;
  bool fictionalCurrencies = false;

  set europeanNotation(bool input) {
    if (input)
      amountNotation = 'eu';
    else
      amountNotation = 'us';
  }

  bool get europeanNotation {
    return (amountNotation == 'eu');
  }
}
