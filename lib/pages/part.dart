import 'dart:collection';

import 'package:chatti/entities/nb_words.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'file:///C:/Users/Ross/AndroidStudioProjects/chatti/lib/pages/play.dart';
import 'package:flutter/material.dart';
import'package:chatti/entities/word_list_a1.dart';
import'package:chatti/entities/word_list_a2.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Part extends StatefulWidget {
  static MobileAdTargetingInfo targetingInfo = MobileAdTargetingInfo(
    keywords: <String>['flutterio', 'beautiful apps'],
    contentUrl: 'https://flutter.io',
    childDirected: false,
    testDevices: <String>[], //// Android emulators are considered test devices
  );

  @override
  _PartState createState() => _PartState();
}

class _PartState extends State<Part> {
  int _nbPart ;
  String _level;
  int _currentPart;
  HashMap<String, int> _scores = HashMap();


  BannerAd _myBanner;
  String _appId = "ca-app-pub-6745620935873225~8698410260";
  String _pubId = "ca-app-pub-6745620935873225/9233596887";

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
    FirebaseAdMob.instance.initialize(appId: _appId);
    setScores();
    _buildBanner();
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

  _buildBanner(){
    _myBanner = BannerAd(
      // Replace the testAdUnitId with an ad unit id from the AdMob dash.
      // https://developers.google.com/admob/android/test-ads
      // https://developers.google.com/admob/ios/test-ads
      adUnitId: BannerAd.testAdUnitId,
      size: AdSize.smartBanner,
      targetingInfo: Part.targetingInfo,
      listener: (MobileAdEvent event) {
        print("BannerAd event is $event");
      },
    );
    _myBanner..load()..show(
        anchorType: AnchorType.bottom
    );
  }

  @override
  Widget build(BuildContext context) {
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
              subtitle: _subTitleWidget(_scores, _level, index),
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

  Widget _subTitleWidget(HashMap<String, int> scores, String level, index){
    return Row(
      children: [
        Expanded(child: Text('Punkte von 20')),
        Stack(
          alignment: Alignment.center,
          children: [
            CircularProgressIndicator(
              backgroundColor: Colors.orange[100],
              valueColor: new AlwaysStoppedAnimation<Color>(Colors.orange),
              value: (scores.putIfAbsent("$level.${index+1}", () => 0)) / 20,
            ),
            Text('${scores.putIfAbsent("$level.${index+1}", () => 0)}'),
          ],
        )
      ],
    );
  }
}
