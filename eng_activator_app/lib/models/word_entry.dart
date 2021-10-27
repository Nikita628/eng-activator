import 'package:eng_activator_app/shared/functions.dart';

class WordEntry {
  late String word;
  late String meaning;
  late String pictureUrl;
  List<String> examples = [];
  List<String> forms = [];

  WordEntry({
    required String word,
    required String meaning,
    required String picUrl,
    required List<String> examples,
    required List<String> forms,
  }) {
    this.word = word;
    this.meaning = meaning;
    this.pictureUrl = picUrl;
    this.examples = examples;
    this.forms = forms;
  }

  Map<String, dynamic> toJson() {
    return {
      "word": word,
      "meaning": meaning,
      "pictureUrl": pictureUrl,
      "examples": examples,
      "forms": forms,
    };
  }

  WordEntry.fromJson(Map<String, dynamic> json) {
    word = json["word"] ?? "";
    meaning = json["meaning"] ?? "";
    pictureUrl = json["pictureUrl"] ?? "";
    examples = Converter.toList(json, "examples");
    forms = Converter.toList(json, "forms");
  }
}
