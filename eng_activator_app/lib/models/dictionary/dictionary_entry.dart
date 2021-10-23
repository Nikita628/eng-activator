import 'package:eng_activator_app/shared/functions.dart';

class DictionaryEntry {
  late String word;
  late String partOfSpeech;
  late String transcript;
  late List<String> meanings = [];
  late String details;
  late List<String> examples = [];

  DictionaryEntry({
    required String word,
    required String partOfSpeech,
    required String transcript,
    required List<String> meanings,
    required List<String> examples,
    required String details,
  }) {
    this.word = word;
    this.partOfSpeech = partOfSpeech;
    this.transcript = transcript;
    this.meanings = meanings;
    this.details = details;
    this.examples = examples;
  }

  DictionaryEntry.fromJson(Map<String, dynamic> json) {
    word = json["word"] ?? "";
    partOfSpeech = json["partOfSpeech"] ?? "";
    transcript = json["transcript"] ?? "";
    meanings = Converter.toList(json, "meanings");
    examples = Converter.toList(json, "examples");
    details = json["details"] ?? "";
  }
}
