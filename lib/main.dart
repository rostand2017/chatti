import 'package:chatti/pages/home.dart';
import 'package:chatti/pages/level.dart';
import 'package:chatti/pages/part.dart';
import 'package:chatti/pages/play.dart';
import 'package:chatti/pages/score.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final   FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

Future selectNotification(String payload) async {
  if (payload != null) {
    debugPrint('notification payload: ' + payload);
  }
  /*await Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => Home()),
  );*/
}



void initializingNotification() async {
// initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
  var initializationSettingsAndroid = AndroidInitializationSettings('app_icon');
  var initializationSettingsIOS = IOSInitializationSettings(
      onDidReceiveLocalNotification: null);
  var initializationSettings = InitializationSettings(
      initializationSettingsAndroid, initializationSettingsIOS);
  await flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onSelectNotification: selectNotification);
}

Future<void> main() async {
  runApp(
      MaterialApp(
        initialRoute: "/",
        routes: {
          //'/': (context) => Loading(),
          '/': (context) => Home(),
          '/level': (context) => Level(),
          '/part': (context) => Part(),
          '/play': (context) => Play(),
          '/score': (context) => Score(),
        },
        onGenerateRoute: (RouteSettings settings)  {
          switch (settings.name) {
            case "/":
              print("fuck");
              break;
          }
          return MaterialPageRoute(builder: (BuildContext context) {  });
        },
      )
  );
  initializingNotification();
}
