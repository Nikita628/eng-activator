import 'package:eng_activator_app/models/activity/activity.dart';
import '../word_entry.dart';

class QuestionActivity extends Activity {
  late String question;

  QuestionActivity(String question, List<WordEntry> wordEntries)
      : super(wordEntries) {
    this.question = question;
  }

  Map<String, dynamic> toJson() {
    return {
      "question": question,
      ...super.toJson(),
    };
  }

  QuestionActivity.fromJson(Map<String, dynamic> json): super.fromJson(json) {
    question = json["question"] ?? "";
  }
}
