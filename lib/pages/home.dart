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

class _HomeState extends State<Home> with WidgetsBindingObserver {
  Tween<double> _tweenRotation;
  var _player = AudioPlayer();
  AppLifecycleState _lastLifecycleState;


  _startBackgroundSound() async{
    try{
      await _player.setAsset("sounds/Funny-music-loop-for-games-and-videos.mp3");
      await _player.setVolume(0.4);
      _player.setLoopMode(LoopMode.all);
      _player.play();
    }catch(e){
      print("bad url exception !");
      print(e);
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state){
      case AppLifecycleState.inactive:
        _player.pause();
        break;
      case AppLifecycleState.resumed:
        _player.play();
        break;
      case AppLifecycleState.paused:
        // TODO: Handle this case.
        break;
      case AppLifecycleState.detached:
        _player.pause();
        break;
    }
    print("state : $_lastLifecycleState");
    setState(() {
      _lastLifecycleState = state;
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _player.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _startBackgroundSound();
    _tweenRotation = Tween<double>(begin: pi, end: 0);
  }


  @override
  Widget build(BuildContext context) {
    print("lifec $_lastLifecycleState");
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
