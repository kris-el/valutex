import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'settings_screen.dart';
import '../app_settings.dart';
import 'about_screen.dart';
import '../localization.dart';

AppSettings appSettings = AppSettings();

class HomeDrawer extends StatelessWidget {
  void _openSettingsScreen(BuildContext context) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => SettingsScreen(),
      ),
    );
  }

  _openEmailApp(BuildContext context) async {
    String toAddress = 'valutex.pardut@gmail.com';
    String emailSubject = 'Valutex: About your app...';
    String emailBody = '';
    if (appSettings.product != '')
      emailBody += '${AppLocalizations.of(context).emailTextDetailsProduct}: ${appSettings.product}\n';
    if ((appSettings.osVersion != '') && (appSettings.androidSdk != ''))
      emailBody +=
          'Android ${appSettings.osVersion}   API ${appSettings.androidSdk}\n';
    emailBody += '${AppLocalizations.of(context).emailTextDetailsScreen}: ' + appSettings.screenWidth.toString();
    emailBody += 'x' + appSettings.screenHeight.toString();
    emailBody += ' ' + appSettings.screenRatio.toStringAsFixed(3) + '\n\n';
    emailBody += '${AppLocalizations.of(context).emailTextHello} ';

    toAddress = Uri.encodeComponent(toAddress);
    emailSubject = Uri.encodeComponent(emailSubject);
    emailBody = Uri.encodeComponent(emailBody);
    String url = 'mailto:$toAddress?subject=$emailSubject&body=$emailBody';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void _openAboutScreen(BuildContext context) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AboutScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Text(
                  'Valutex',
                  style: TextStyle(color: Colors.white, fontSize: 30.0),
                ),
                //Container(height: 4.0),
                Text(
                  AppLocalizations.of(context).appSubtitle,
                  style: TextStyle(color: Colors.white, fontSize: 18.0),
                ),
                Container(height: 16.0),
              ],
            ),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
            ),
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: Text(AppLocalizations.of(context).drawerSettings),
            onTap: () {
              Navigator.pop(context);
              _openSettingsScreen(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: Text(AppLocalizations.of(context).drawerAboutApp),
            onTap: () {
              Navigator.pop(context);
              _openAboutScreen(context);
            },
          ),
          // ListTile(
          //   leading: const Icon(Icons.star),
          //   title: Text('Rate on the store'),
          //   onTap: () {},
          // ),
          // ListTile(
          //   leading: const Icon(Icons.share),
          //   title: Text('Share this app'),
          //   onTap: () {},
          // ),
          ListTile(
            leading: const Icon(Icons.email),
            title: Text(AppLocalizations.of(context).drawerContactDeveloper),
            onTap: () {
              Navigator.pop(context);
              _openEmailApp(context);
            },
          ),
        ],
      ),
    );
  }
}
