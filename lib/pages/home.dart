import 'dart:math';
import 'dart:ui';
import 'package:chatti/pages/play.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Tween<double> _tweenRotation;
  var _player = AudioPlayer();
  bool _isPlayerstop = false;
  _startBackgroundSound() async{
    try{
      await _player.setUrl("http://www.orangefreesounds.com/wp-content/uploads/2020/07/Funny-music-loop-for-games-and-videos.mp3");
      await _player.setVolume(0.4);
      _player.setLoopMode(LoopMode.all);
      _player.play();
    }catch(e){
      print("bad url exception !");
      print(e);
    }
  }

  @override
  void dispose() {
    print("dispose.....dispose.....dispose.....dispose.....dispose.....dispose.....dispose.....");
    _player.dispose();
    _isPlayerstop = true;
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _startBackgroundSound();
    _tweenRotation = Tween<double>(begin: pi, end: 0);
  }

  @override
  Widget build(BuildContext context) {
    if(_isPlayerstop){
      print("Replay...Replay...Replay...Replay...Replay...");
      _startBackgroundSound();
      _isPlayerstop = false;
    }
    return Scaffold(
      backgroundColor: Colors.grey,
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TweenAnimationBuilder(
                duration: Duration(milliseconds: 1500),
                tween: _tweenRotation,
                curve: Curves.elasticInOut,
                builder: (BuildContext context, double angle, Widget child) {
                  return Transform.rotate(
                    angle: angle,
                    child: Image.asset(
                      "images/ic_logo_normal_foreground.png",
                      width: 150,
                      height: 150,
                      fit: BoxFit.fill,
                    ),
                  );
                },
              ),
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.translate, color: Colors.black54),
                    Text(
                      'Wortschatz',
                      style: TextStyle(
                        fontSize: 38,
                        color: Colors.black54,
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
                    onPressed: () async{
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
