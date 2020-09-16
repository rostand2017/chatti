import 'package:chatti/pages/home.dart';
import 'package:chatti/pages/level.dart';
import 'package:chatti/pages/part.dart';
import 'package:chatti/pages/play.dart';
import 'package:chatti/pages/score.dart';
import 'package:flutter/material.dart';

void main() {
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
      )
  );
}
