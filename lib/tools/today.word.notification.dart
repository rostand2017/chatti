import 'package:chatti/entities/word.dart';
import'package:chatti/entities/word_list_a1.dart';
import'package:chatti/entities/word_list_a2.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class TodayWordNotification{
  static var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'words', 'Daily Word', 'Get a new word every day',
      importance: Importance.Max, priority: Priority.High,
      ticker: 'ticker'
  );
  static var scheduledNotificationDateTime =  DateTime.now().add(Duration(seconds: 5));
  static var iOSPlatformChannelSpecifics = IOSNotificationDetails();
  static final   FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  static showNotification() async{
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    Word word = _getTodayWord();
    /*await flutterLocalNotificationsPlugin.show(
      0,
      'Das Wort des Tages',
      '${word.word} - ${word.pluralForm}  (${word.translation[Word.FRENCH]})',
      platformChannelSpecifics,
    );*/
    await flutterLocalNotificationsPlugin.showDailyAtTime(
      0,
      'Das Wort des Tages',
      '${word.word} - ${word.pluralForm}',
      Time(6, 40, 0),
      platformChannelSpecifics,
    );
  }

  static Word _getTodayWord(){
    List<Word> wordList = [];
    wordList.addAll(wordsA1);
    wordList.addAll(wordsA2);
    wordList.shuffle();
    return wordList[0];
  }
}