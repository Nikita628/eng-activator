import 'package:eng_activator_app/models/dictionary/dictionary_entry.dart';
import 'package:flutter/material.dart';

class DictionaryEntryWidget extends StatelessWidget {
  final DictionaryEntry _entry;

  const DictionaryEntryWidget({required DictionaryEntry entry})
      : _entry = entry,
        super();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          child: Text(
            _entry.word,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          margin: const EdgeInsets.only(top: 10, bottom: 10),
        ),
        ..._entry.meanings.map(
          (e) => Container(
            child: Text("- $e"),
            margin: EdgeInsets.only(bottom: 10),
          ),
        ),
        _entry.examples.isNotEmpty
            ? const Text(
                "Examples:",
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.bold,
                ),
              )
            : const SizedBox.shrink(),
        ..._entry.examples.map(
          (e) => Container(
            child: Text("- $e"),
            margin: const EdgeInsets.only(top: 10),
          ),
        ),
      ],
    );
  }
}