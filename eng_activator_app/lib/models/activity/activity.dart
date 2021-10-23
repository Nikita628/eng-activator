import 'package:eng_activator_app/models/word_entry.dart';

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
}
