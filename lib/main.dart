

import 'file:///C:/Users/Ross/AndroidStudioProjects/chatti/lib/pages/play.dart';
import 'package:chatti/pages/home.dart';
import 'package:chatti/pages/level.dart';
import 'package:chatti/pages/loading.dart';
import 'package:chatti/pages/part.dart';
import 'package:chatti/pages/score.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(
      MaterialApp(
        routes: {
          '/': (context) => Loading(),
          '/home': (context) => Home(),
          '/level': (context) => Level(),
          '/part': (context) => Part(),
          '/play': (context) => Play(),
          '/score': (context) => Score(),
        },
      )
  );
}
