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

  bool isWordPresentInText(String text) {
    if (text.isEmpty) {
      return false;
    }

    var loweredText = text.toLowerCase();
    var isPresent = false;

    if (loweredText.contains(this.word)) {
      isPresent = true;
    } else {
      for (var form in this.forms) {
        if (loweredText.contains(form)) {
          isPresent = true;
          break;
        }
      }
    }

    return isPresent;
  }
}
