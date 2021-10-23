import 'dart:math';
import 'package:eng_activator_app/models/activity/picture_activity.dart';
import 'package:eng_activator_app/models/activity/question_activity.dart';
import 'package:eng_activator_app/shared/services/data.dart';
import 'package:eng_activator_app/models/word_entry.dart';

class AppStorage {
  static final Random _rnd = Random(DateTime.now().millisecondsSinceEpoch);

  String getRandomPicture() {
    var picNumber = getRandomInt(450);
    return 'pic' + picNumber.toString() + '.jpg';
  }

  String getRandomQuestion() {
    var questionMap = AppData.questions[getRandomInt(AppData.questions.length)];

    return questionMap.values.first;
  }

  int getRandomInt(int max) {
    return _rnd.nextInt(max);
  }

  List<WordEntry> getRandomWordEntries() {
    List<WordEntry> wordEntries = [];

    while (wordEntries.length < 4) {
      var wordEntryMap = AppData.wordEntries[getRandomInt(AppData.wordEntries.length)];
      var wordEnt = WordEntry.fromJson(wordEntryMap);

      if (!wordEntries.any((element) => element.word == wordEnt.word)) {
        wordEntries.add(wordEnt);
      }
    }

    return wordEntries;
  }

  QuestionActivity getRandomQuestionActivity() {
    return QuestionActivity(getRandomQuestion(), getRandomWordEntries());
  }

  PictureActivity getRandomPictureActivity() {
    return PictureActivity(getRandomPicture(), getRandomWordEntries());
  }
}
