import 'package:eng_activator_app/models/word_entry.dart';
import 'package:eng_activator_app/shared/constants.dart';
import 'package:eng_activator_app/widgets/dialogs/dictionary_entry_dialog.dart';
import 'package:flutter/material.dart';

class WordListItemDto {
  late WordEntry wordEntry;
  late bool isHighlited;

  WordListItemDto({
    required WordEntry wordEntry,
    required bool isHighlited,
  })  : this.wordEntry = wordEntry,
        this.isHighlited = isHighlited;
}

class WordListItemWidget extends StatelessWidget {
  final WordListItemDto _dto;

  WordListItemWidget({required WordListItemDto dto}) : _dto = dto;


  Future<void> _onWordTap(WordEntry wordEntry, BuildContext context) async {
    await showDialog<int>(
        context: context,
        builder: (BuildContext context) {
          return DictionaryEntryDialog(wordEntry: wordEntry);
        });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Chip(
        backgroundColor: _dto.isHighlited ? Color(AppColors.yellow) : Colors.white,
        label: Text(
          _dto.wordEntry.word,
          style: const TextStyle(fontSize: 20, color: Colors.black54),
        ),
        labelPadding: const EdgeInsets.only(left: 10, right: 10, top: 3, bottom: 3),
      ),
      onTap: () => _onWordTap(_dto.wordEntry, context),
    );
  }
}
