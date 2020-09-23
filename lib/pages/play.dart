import 'dart:async';
import 'dart:math';
import 'package:chatti/entities/nb_words.dart';
import 'package:chatti/entities/word.dart';
import 'package:chatti/pages/part.dart';
import 'package:circle_button/circle_button.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import'package:chatti/entities/word_list_a1.dart';
import'package:chatti/entities/word_list_a2.dart';
import 'package:just_audio/just_audio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Play extends StatefulWidget {

  static const String PART_TYPE = "part_type";
  static const String DIRECT_TYPE = "direct_type";

  @override
  _PlayState createState() => _PlayState();

}

class _PlayState extends State<Play>{

  // NB_STEP: number of plays in a step
  static const int NB_STEP = 20;
  double progression = 0;
  Timer timer;
  List<int> indexes;
  int position = 0;
  String level;
  int part;
  int currentPart;
  String type;
  List<Word> words;
  List<Word> solutions;
  Word word;
  bool clicked = false;
  int score = 0;
  MaterialColor color;
  AudioPlayer _player = AudioPlayer();

  /**
   * Run a step
   */
  void playOnce(){
    print("jello ${wordsA2.length}");
    startTimer();
    setSolutions();
  }

  /**
   * Run the timer for a step of a 20 steps of the part
   */
  void startTimer() {
    progression = 0;
    timer = new Timer.periodic(
      Duration(milliseconds: 125),
          (Timer timer) {
            if (progression >= 1) {
              setState(() {
                clicked = true;
              });
              runNextStep(2);
            }else{
              setState(() {
                progression += (125/10000);
              });
            }
          },
    );
  }

  void runNextStep(int seconds){
    timer.cancel();
    Future.delayed(Duration(seconds: seconds), (){
      if(position < NB_STEP-1){
        //words.remove(position);
        position ++;
        print("word: ${words[position].word}");
        print("fuckkkkk! $seconds");
        clicked = false;
        startTimer();
        setSolutions();
      }else{
        gotoNextTeil();
      }
    });
  }

  void gotoNextTeil() async{
    if(type != Play.DIRECT_TYPE){
      SharedPreferences prefs = await SharedPreferences.getInstance();
      if(currentPart <= part){
        prefs.setInt(level, part+1);
      }
      prefs.setInt("$level.$part", score);
    }
    showScore();
  }

  @override
  void initState() {
    super.initState();
  }

  void setLevel(BuildContext context){
    Map arguments = ModalRoute.of(context).settings.arguments;
    type = arguments['type'];
    if(type != Play.DIRECT_TYPE){
      level = arguments['level'];
      part = arguments['part'];
      currentPart = arguments['currentPart'];
    }
  }

  void showScore(){
    Navigator.pushReplacementNamed(context, "/score", arguments: {
      "level": level,
      "part": part,
      "score": score,
      "type": Play.PART_TYPE
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    print("dispose");
    timer.cancel();
    super.dispose();
  }

  /**
   * set the 20 words to predict for a PART
   */
  void setWords(){
    if(type == Play.DIRECT_TYPE){
      List<Word> wordsTemp = [];
      wordsTemp.addAll(wordsA1);
      wordsTemp.addAll(wordsA2);
      wordsTemp.shuffle();
      words = wordsTemp.getRange(0, NB_STEP).toList();
      print("words: ${words.length}");
    }else{
      switch(level){
        case "A1":
          words = wordsA1.getRange(part*NB_STEP - NB_STEP, part*NB_STEP).toList();
          words.shuffle();
          break;
        case "A2":
          words = wordsA2.getRange(part*NB_STEP - NB_STEP, part*NB_STEP).toList();
          words.shuffle();
          break;
        default:
          print("fuck!!!!! $level");
      }
    }
  }

  /**
   *  set a 3 solutions words and the user choose the correct.
   *  use this function in any step of a 20 steps of a part
   */
  void setSolutions(){
    if(type == Play.DIRECT_TYPE){
      List<Word> wordsTemp = [];
      wordsTemp.addAll(wordsA1);
      wordsTemp.addAll(wordsA2);
      wordsTemp.remove(words[position]);
      wordsTemp.shuffle();
      solutions = wordsTemp.getRange(0, 2).toList();
    }else{
      switch(level){
        case "A1":
          List<Word> wordA1Copy = List.from(wordsA1);
          wordA1Copy.remove(words[position]);
          int rd = Random().nextInt(NBWord.NB_WORD_A1 - 2);
          if (rd+2 >= (NBWord.NB_WORD_A1-2) )
            solutions = wordA1Copy.getRange(rd-2, rd).toList();
          else
            solutions = wordA1Copy.getRange(rd, rd+2).toList();
          break;
        case "A2":
        // removing the good word in the list of false answers
          List<Word> wordA2Copy = List.from(wordsA2);
          wordA2Copy.remove(words[position]);
          print("etw: ${wordA2Copy.length}");
          int rd = Random().nextInt(NBWord.NB_WORD_A2 - 2);
          if (rd+2 >= (NBWord.NB_WORD_A2 - 2))
            solutions = wordA2Copy.getRange(rd-2, rd).toList();
          else
            solutions = wordA2Copy.getRange(rd, rd+2).toList();
          break;
      }
    }
    // add good answer
    solutions.add(words[position]);
    solutions.shuffle();
  }

  /**
   * get the word to predict
   */
  String getWord(){
    Word word = words[position];
    if(word.word != "")
      return word.word;
    else
      return word.pluralForm;
  }

  /**
   * get the good color depending of the article
   * blue = masculin
   * red  = femenin
   * yellow = plural
   * black = verb and adjectiv
   */
  MaterialColor getWordColor(){
    Word word = words[position];
    if(word.word != ""){
      String article = word.word.split(" ")[0];
      switch(article){
        case "der":
          return Colors.indigo;
        case "die":
          return Colors.red;
        case "das":
          return Colors.green;
      }
    }else
      return Colors.orange;
  }

  void verifyAnswer(Word word) async{
    if(!clicked){
      setState(() {
        clicked = true;
      });
      if (word == words[position]){
        setState(() {
          score ++;
        });
        await _player.setAsset('sounds/hero_decorative-celebration-02.wav');
        runNextStep(0);
      }else{
        await _player.setAsset('sounds/Wrong-answer-sound-effect.mp3');
        runNextStep(2);
      }
      await _player.setVolume(0.5);
      _player.play();
    }
  }

  // load a video after 5 parts
  void _loadAdsVideo(int part){
    double cu = part/5;
    if(cu == (part/5).toInt().toDouble()) {
      RewardedVideoAd.instance..load(adUnitId: RewardedVideoAd.testAdUnitId, targetingInfo: Part.targetingInfo)..show();
      RewardedVideoAd.instance.listener =
        (RewardedVideoAdEvent event, {String rewardType, int rewardAmount}) {
            print("reward : $rewardAmount");
            if(event == RewardedVideoAdEvent.started){
              print("reward started");
              timer.cancel();
            }
            if(event == RewardedVideoAdEvent.closed){
              print("reward closed");
              startTimer();
            }
      };
    }
  }

  MaterialColor getGoodColor(Word word){
    if(!clicked)
      return Colors.orange;
    else{
      if(word != words[position]){
        return Colors.red;
      }else{
        return Colors.green;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    setLevel(context);
    print("builtttt");
    if(words == null){
      setWords();
      playOnce();
      if (part != null)
        _loadAdsVideo(part);
    }
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("images/bg_chatti1ldpi.png"),
                fit: BoxFit.cover,
                repeat: ImageRepeat.noRepeat,
              ),
              color: Colors.black12,
              backgroundBlendMode: BlendMode.xor,
            ),
            child: Column(
              children: [
                LinearProgressIndicator(
                  backgroundColor: Colors.red[200],
                  valueColor: new AlwaysStoppedAnimation<Color>(Colors.red),
                  value: progression,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Text(
                      "${(10 - progression * 10).round()}\"",
                      style: TextStyle(
                        color: Colors.lightBlue,
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 20,),
                    Text(
                      "${getWord()}",
                      style: TextStyle(
                        fontSize: 40,
                        letterSpacing: 2.0,
                        color: getWordColor(),
                        decoration: TextDecoration.overline,
                      ),
                    ),
                    Text(
                      "${words[position].pluralForm}",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.orange[800],
                      ),
                    ),
                    SizedBox(height: 20,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: solutions.map((Word word) {
                        CircleButton btn = CircleButton(
                          onTap: (){
                            verifyAnswer(word);
                          },
                          width: 200,
                          height: 200,
                          borderStyle: BorderStyle.none,
                          backgroundColor: getGoodColor(word),
                          child:
                          Text(
                            word.translation[Word.FRENCH],
                            textAlign: TextAlign.center,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        );
                        return Expanded(child: btn,);
                    }).toList(),
                    ),
                    SizedBox(height: 20,),
                    Text(
                      "  score: $score  ",
                      style: TextStyle(
                        color: Colors.white,
                        backgroundColor: Colors.red,
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
      ),
    );
  }
}
