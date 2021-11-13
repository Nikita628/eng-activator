import 'package:eng_activator_app/models/word_entry.dart';
import 'package:eng_activator_app/shared/constants.dart';
import 'package:eng_activator_app/widgets/ui_elements/rounded_box.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'word_list_item.dart';

class WordListWidget extends StatelessWidget {
  final List<WordEntry> _wordEntries;
  final EdgeInsets? _margin;

  WordListWidget({required List<WordEntry> wordEntries, EdgeInsets? margin})
      : _wordEntries = wordEntries,
        _margin = margin;

  @override
  Widget build(BuildContext context) {
    return RoundedBox(
      bgColor: const Color(AppColors.green),
      margin: _margin,
      padding: const EdgeInsets.only(top: 10, bottom: 10, left: 8, right: 8),
      child: Wrap(
        spacing: 8.0,
        runSpacing: 10,
        children: _wordEntries
            .map((e) => WordListItemWidget(
                  wordEntry: e,
                ))
            .toList(),
      ),
    );
  }
}
