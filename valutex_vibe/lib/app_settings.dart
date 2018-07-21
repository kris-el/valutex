
class AppSettings {
  static final AppSettings _singleton = AppSettings._internal();
  factory AppSettings() {
    return _singleton;
  }
  AppSettings._internal();

  static String amountNotation = 'eu';

  set europeanNotation(bool input) {
    if(input) amountNotation = 'eu';
    else amountNotation = 'us';
  }

  bool get europeanNotation {
    return (amountNotation == 'eu');
  }

}