import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Level extends StatelessWidget {

  void gotoLevel(context, level) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int part = prefs.getInt(level)??1;
    Navigator.pushNamed(context, "/part", arguments: {'level':level, 'currentPart': part});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: ListView(
        children: [
          Center(
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
                          'NIVEAU',
                          style: TextStyle(
                            fontSize: 38,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2.0,
                          ),
                        ),
                      ]
                  ),
                  Divider(height: 40, color: Colors.grey,),
                  SizedBox(height: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      FlatButton.icon(
                        onPressed: ()=>gotoLevel(context, "A1"),
                        icon: Icon(Icons.arrow_upward, color: Colors.grey[100],),
                        label: Text("A1", style: TextStyle(color: Colors.grey[100]),),
                        color: Colors.black54,
                      ),
                      FlatButton.icon(
                        onPressed: ()=>gotoLevel(context, "A2"),
                        icon: Icon(Icons.arrow_upward, color: Colors.grey[100],),
                        label: Text("A2", style: TextStyle(color: Colors.grey[100]),),
                        color: Colors.black54,
                      ),
                      FlatButton.icon(
                        onPressed: ()=>gotoLevel(context, "B1"),
                        icon: Icon(Icons.arrow_upward, color: Colors.grey[100],),
                        label: Text("B1", style: TextStyle(color: Colors.grey[100]),),
                        color: Colors.red,
                      ),
                      FlatButton.icon(
                        onPressed: ()=>gotoLevel(context, "B2"),
                        icon: Icon(Icons.arrow_upward, color: Colors.grey[100],),
                        label: Text("B2", style: TextStyle(color: Colors.grey[100]),),
                        color: Colors.red,
                      ),
                      FlatButton.icon(
                        onPressed: ()=>gotoLevel(context, "C1"),
                        icon: Icon(Icons.arrow_upward, color: Colors.grey[100],),
                        label: Text("C1", style: TextStyle(color: Colors.grey[100]),),
                        color: Colors.yellow[800],
                      ),
                      FlatButton.icon(
                        onPressed: ()=>gotoLevel(context, "C2"),
                        icon: Icon(Icons.arrow_upward, color: Colors.grey[100],),
                        label: Text("C2", style: TextStyle(color: Colors.grey[100]),),
                        color: Colors.yellow[800],
                      ),
                    ],
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );;
  }
}
