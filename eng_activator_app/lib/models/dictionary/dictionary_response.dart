import 'package:eng_activator_app/models/dictionary/dictionary_entry.dart';
import 'package:eng_activator_app/shared/functions.dart';

class DictionaryResponse {
  late List<DictionaryEntry> dictionaryEntries = [];
  late List<String> recommendations = [];

  DictionaryResponse({
    required List<DictionaryEntry> dictionaryEntries,
    required List<String> recommendations,
  }) {
    this.dictionaryEntries = dictionaryEntries;
    this.recommendations = recommendations;
  }

  DictionaryResponse.fromJson(Map<String, dynamic> json) {
    dictionaryEntries = Converter.convertToList(json, "dictionaryEntries", (e) => DictionaryEntry.fromJson(e));
    recommendations = Converter.toList(json, "recommendations");
  }
}
