import 'package:chatti/pages/home.dart';
import 'package:chatti/pages/level.dart';
import 'package:chatti/pages/part.dart';
import 'package:chatti/pages/play.dart';
import 'package:chatti/pages/score.dart';
import 'package:flutter/material.dart';

void main() {
  //WidgetsFlutterBinding.ensureInitialized();
  //await Firebase.initializeApp();
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
}
