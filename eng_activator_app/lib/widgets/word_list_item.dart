import 'package:eng_activator_app/models/word_entry.dart';
import 'package:eng_activator_app/shared/constants.dart';
import 'package:eng_activator_app/state/activity_provider.dart';
import 'package:eng_activator_app/widgets/dialogs/dictionary_entry_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';

class WordListItemWidget extends StatefulWidget {
  final WordEntry _wordEntry;

  WordListItemWidget({required WordEntry wordEntry}) : _wordEntry = wordEntry;

  @override
  _WordListItemWidgetState createState() => _WordListItemWidgetState();
}

class _WordListItemWidgetState extends State<WordListItemWidget> {
  late bool _isWordHighlighted = false;
  late ActivityProvider _activityProvider;

  @override
  void initState() {
    super.initState();

    _activityProvider = Provider.of<ActivityProvider>(context, listen: false);

    _activityProvider.currentActivityAnswer.subscribe(_onCurrentActivityAnswerChange);

    _isWordHighlighted = _currentAnswerContainsWord(_activityProvider.currentActivityAnswer.get());
  }

  @override
  void dispose() {
    super.dispose();
    _activityProvider.currentActivityAnswer.unsubscribe(_onCurrentActivityAnswerChange);
  }

  void _onCurrentActivityAnswerChange(String value) {
    _checkIfCurrentAnswerContainsWord(value);
    setState(() {});
  }

  Future<void> _onWordTap(WordEntry wordEntry, BuildContext context) async {
    await showDialog<int>(
        context: context,
        builder: (BuildContext context) {
          return DictionaryEntryDialog(wordEntry: wordEntry);
        });
  }

  void _checkIfCurrentAnswerContainsWord(String answer) {
    bool contains = _currentAnswerContainsWord(answer);
    bool isUserAlreadyNotified = _isWordHighlighted;

    if (contains && !isUserAlreadyNotified) {
      _notifyUserAboutWordUsage();
    }

    _isWordHighlighted = contains;
  }

  bool _currentAnswerContainsWord(String answer) {
    if (answer.isEmpty) {
      return false;
    }

    var loweredAnswer = answer.toLowerCase();
    var contains = false;

    if (loweredAnswer.contains(widget._wordEntry.word)) {
      contains = true;
    } else {
      for (var form in widget._wordEntry.forms) {
        if (loweredAnswer.contains(form)) {
          contains = true;
          break;
        }
      }
    }

    return contains;
  }

  void _notifyUserAboutWordUsage() {
    SchedulerBinding.instance?.addPostFrameCallback((timeStamp) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Just used '${widget._wordEntry.word}' !",
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16, color: Color(AppColors.green)),
          ),
          duration: const Duration(milliseconds: 1500),
          width: 250,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Chip(
        backgroundColor: _isWordHighlighted ? Color(AppColors.yellow) : Colors.white,
        label: Text(
          widget._wordEntry.word,
          style: const TextStyle(fontSize: 20, color: Colors.black54),
        ),
        labelPadding: const EdgeInsets.only(left: 10, right: 10, top: 3, bottom: 3),
      ),
      onTap: () => _onWordTap(widget._wordEntry, context),
    );
  }
}
