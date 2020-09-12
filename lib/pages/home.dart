import 'package:chatti/pages/play.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.translate, color: Colors.black),
                  Text(
                    'Wortschatz',
                    style: TextStyle(
                      fontSize: 38,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2.0,
                    ),
                  ),
                ]
              ),
              SizedBox(height: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  FlatButton.icon(
                    onPressed: (){
                      Navigator.pushNamed(context, "/play", arguments: {
                        "type": Play.DIRECT_TYPE
                      });
                    },
                    icon: Icon(Icons.play_arrow, color: Colors.grey[100]),
                    label: Text("DIREKT SPIELEN", style: TextStyle(color: Colors.grey[100]),),
                    color: Colors.yellow[800],
                  ),
                  FlatButton.icon(
                    onPressed: (){
                      Navigator.pushNamed(context, "/level");
                    },
                    icon: Icon(Icons.arrow_upward, color: Colors.grey[100],),
                    label: Text("WÄHLEN SIE EIN NIVEAU", style: TextStyle(color: Colors.grey[100]),),
                    color: Colors.red,
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
