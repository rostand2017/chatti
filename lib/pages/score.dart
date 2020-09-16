import 'file:///C:/Users/Ross/AndroidStudioProjects/chatti/lib/pages/play.dart';
import 'package:chatti/entities/nb_words.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Score extends StatefulWidget {
  @override
  _ScoreState createState() => _ScoreState();
}

class _ScoreState extends State<Score> {
  int score;
  int part;
  String level;
  String type;

  String getButtonText(int part){
    return part == null? "Wiederholen" : part<(NBWord.NB_WORD_A2/NBWord.NB_WORD_PER_PLAY).floor()? "Weiter spielen": "Teil fertig";
  }

  void gotToNext(int part, String level) async{
    if(part == null){
      Navigator.pushReplacementNamed(context, "/play", arguments: {
        "type": Play.DIRECT_TYPE
      });
    }
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int currentPart = prefs.getInt(level)??1;
    Map arguments = {
      "level": level,
      "currentPart": currentPart,
      "part": part+1,
      "type": type
    };
    if(part < (NBWord.NB_WORD_A2/NBWord.NB_WORD_PER_PLAY).floor()){
      Navigator.pushReplacementNamed(context, "/play", arguments:arguments);
    }else{
      Navigator.pop(context, arguments);
    }
  }

  String getAppreciation(int score){
    return score<10?"Nicht gut!":score>=10 && score <=14?"Gut!":"Sehr gut!";
  }

  String getImage(int score){
    return "images/"+(score<10?"sad.svg":score>=10 && score <=14?"happiness.svg":"champagne.svg");
  }

  @override
  Widget build(BuildContext context) {
    Map arguments = ModalRoute.of(context).settings.arguments;
    score = arguments['score'];
    level = arguments['level'];
    part = arguments['part'];
    type = arguments['type'];
    return Scaffold(
      body: Center(
        child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("images/bg_chatti1ldpi.png"),
                fit: BoxFit.cover
              )
            ),
            padding: EdgeInsets.all(10),
            child: ListView(
              children: [
                SafeArea(
                  child: Column(
                    children: [
                      CircleAvatar(
                        child: SvgPicture.asset(
                          getImage(score),
                          width: 100,
                          height: 100,
                          fit: BoxFit.fill,
                          semanticsLabel: "Hallo",
                        ),
                        radius: 100,
                      ),
                      SizedBox(height: 20,),
                      Text(
                          "$score/20",
                          style: TextStyle(
                              color: Colors.orange,
                              fontSize: 24.0,
                              fontWeight: FontWeight.bold
                          )
                      ),
                      Text(
                        (part!= null )?"Score Teil $part":"Score direkt Spiel",
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 35.0,
                          letterSpacing: 2.0,
                          fontWeight: FontWeight.bold,
                        )
                      ),
                      Text(getAppreciation(score)),
                      SizedBox(height: 20,),
                      RaisedButton(
                        child: Text(getButtonText(part),style: TextStyle(color: Colors.white),),
                        padding: EdgeInsets.fromLTRB(60, 15, 60, 15),
                        color: Colors.blue,
                        onPressed: ()=>gotToNext(part, level),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
      ),
    );
  }
}
