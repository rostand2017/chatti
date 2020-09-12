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
  int _nbPart ;
  String _level;
  int _currentPart;
  HashMap<String, int> _scores = HashMap();

  void play(index) {
    Navigator.pushNamed(context, "/play", arguments: {
      "level": _level,
      "currentPart": _currentPart,
      "part": index+1,
      "type": Play.PART_TYPE
    });
  }

  bool isEnable(index) {
    return (_currentPart >= index+1 || index == 0);
  }


  @override
  void initState(){
    super.initState();
    setScores();
  }

  void setScores() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    HashMap<String, int> goodScores = HashMap();
    for(var i=1; i <= _nbPart; i++){
      goodScores.putIfAbsent("$_level.$i",()=>prefs.getInt("$_level.$i")??0);
    }
    setState(() {
      _scores = goodScores;
      _currentPart = prefs.getInt(_level)??1;
    });
  }

  @override
  Widget build(BuildContext context) {
    print("build");
    Map arguments = ModalRoute.of(context).settings.arguments;
    _level = arguments['level'];
    _currentPart = arguments['currentPart'];
    _nbPart = (NBWord.NB_WORDS[_level] / NBWord.NB_WORD_PER_PLAY).round();

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: ListView.builder(
        itemCount: (_nbPart),
        itemBuilder: (context, index){
          return Card(
            child: ListTile(
              onTap: () => play(index),
              title: Text("Teil ${index+1}"),
              subtitle: Text('Punkte: ${_scores.putIfAbsent("$_level.${index+1}", () => 0)} von 20'),
              enabled: isEnable(index),
            ),
          );
        },
      ),
      appBar: AppBar(
        title: Text("NIVEAU $_level"),
        centerTitle: true,
        backgroundColor: Colors.red,
      ),
    );
  }
}
