import 'package:flutter/material.dart';
import '../app_settings.dart';

AppSettings appSettings = AppSettings();

class AboutScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final boxHead = Padding(
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
                'Currency exchange',
                style: TextStyle(fontSize: 18.0, color: Colors.blueGrey[900]),
              ),
              Container(height: 8.0),
              Text(
                'Author: Christian Grassi',
                style: TextStyle(fontSize: 14.0, color: Colors.blueGrey[700]),
              ),
            ],
          ),
        ],
      ),
    );

    String description = '';
    description += 'This application is designed for casual usage.\n';
    description += 'Rates update are available once an hour.\n\n';
    description += 'Application realized with Flutter and Dart.\n';

    final boxBottom = Padding(
      padding: EdgeInsets.all(16.0),
      child: Text(
        description,
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
        title: Text('About'),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/pictures/backmoney_v.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: body,
      ),
    );
  }
}
