import 'package:eng_activator_app/models/word_entry.dart';
import 'package:eng_activator_app/shared/functions.dart';

class Activity {
  List<WordEntry> wordEntries = [];

  Activity(List<WordEntry> wordEntries) {
    this.wordEntries = wordEntries;
  }

  Map<String, dynamic> toJson() {
    return {
      "wordEntries": wordEntries.map((e) => e.toJson()).toList(),
    };
  }

  Activity.fromJson(Map<String, dynamic> json) {
    wordEntries = Converter.convertToList(json, "wordEntries", (w) => WordEntry.fromJson(w));
  }
}
