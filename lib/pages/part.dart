import 'dart:collection';

import 'package:chatti/entities/nb_words.dart';
import 'file:///C:/Users/Ross/AndroidStudioProjects/chatti/lib/pages/play.dart';
import 'package:flutter/material.dart';
import'package:chatti/entities/word_list_a1.dart';
import'package:chatti/entities/word_list_a2.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Part extends StatefulWidget {
  @override
  _PartState createState() => _PartState();
}

class _PartState extends State<Part> {
  int nbPart ;
  String level;
  int currentPart;
  HashMap<String, int> scores = HashMap();

  void play(index){
    Navigator.pushNamed(context, "/play", arguments: {
      "level": level,
      "currentPart": currentPart,
      "part": index+1,
      "type": Play.PART_TYPE
    });
  }

  bool isEnable(index) {
    return (currentPart >= index+1 || index == 0);
  }


  @override
  void initState(){
    super.initState();
  }

  void setScores() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    HashMap<String, int> goodScores = HashMap();
    for(var i=1; i <= nbPart; i++){
      goodScores.putIfAbsent("$level.$i",()=>prefs.getInt("$level.$i")??0);
    }
    setState(() {
      scores = goodScores;
    });
  }

  @override
  Widget build(BuildContext context) {
    Map arguments = ModalRoute.of(context).settings.arguments;
    level = arguments['level'];
    currentPart = arguments['currentPart'];
    nbPart = (NBWord.NB_WORDS[level] / NBWord.NB_WORD_PER_PLAY).round();
    setScores();

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: ListView.builder(
        itemCount: (nbPart),
        itemBuilder: (context, index){
          return Card(
            child: ListTile(
              onTap: () => play(index),
              title: Text("Teil ${index+1}"),
              subtitle: Text('Punkte: ${scores.putIfAbsent("$level.${index+1}", () => 0)} von 20'),
              enabled: isEnable(index),
            ),
          );
        },
      ),
      appBar: AppBar(
        title: Text("NIVEAU $level"),
        centerTitle: true,
        backgroundColor: Colors.red,
      ),
    );
  }
}
