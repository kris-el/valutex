import 'package:flutter/material.dart';
import '../app_settings.dart';
import 'dev_screen.dart';
import '../localization.dart';

AppSettings appSettings = AppSettings();

class AboutScreen extends StatelessWidget {
  void openDevScreen(BuildContext context) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => DevScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final boxHead = InkWell(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              "assets/images/logo/curex.png",
              height: 96.0,
              width: 96.0,
            ),
            Container(
              width: 14.0,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Valutex ${appSettings.appVersion}',
                  style: TextStyle(fontSize: 30.0, color: Colors.blueGrey[900]),
                ),
                Text(
                  AppLocalizations.of(context).appSubtitle,
                  style: TextStyle(fontSize: 18.0, color: Colors.blueGrey[900]),
                ),
                Container(height: 8.0),
                Text(
                  '${AppLocalizations.of(context).appAuthor}: Christian Grassi',
                  style: TextStyle(fontSize: 14.0, color: Colors.blueGrey[700]),
                ),
              ],
            ),
          ],
        ),
      ),
      onTap: () {
        if (appSettings.isInDebugMode) {
          Navigator.pop(context);
          openDevScreen(context);
        }
      },
    );

    final boxBottom = Padding(
      padding: EdgeInsets.all(16.0),
      child: Text(
        AppLocalizations.of(context).aboutBodyAppDescription,
        style: TextStyle(color: Colors.white),
      ),
    );

    var body = Column(
      children: <Widget>[
        boxHead,
        Expanded(child: Container()),
        boxBottom,
      ],
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).drawerAboutApp),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/pictures/backmoney.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: body,
      ),
    );
  }
}
