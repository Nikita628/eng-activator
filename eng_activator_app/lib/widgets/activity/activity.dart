import 'package:eng_activator_app/models/activity/activity.dart';
import 'package:eng_activator_app/models/word_entry.dart';
import 'package:eng_activator_app/shared/constants.dart';
import 'package:eng_activator_app/state/activity_provider.dart';
import 'package:eng_activator_app/widgets/activity/activity_answer_form.dart';
import 'package:eng_activator_app/widgets/activity/activity_generation_buttons.dart';
import 'package:eng_activator_app/widgets/ui_elements/app_scaffold.dart';
import 'package:eng_activator_app/widgets/word_list.dart';
import 'package:eng_activator_app/widgets/word_list_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';

class ActivityWidget extends StatelessWidget {
  final Function()? _onForward;
  final Function()? _onBack;
  final bool _isOnBackDisabled;
  final Widget _child;
  final Activity _activity;

  ActivityWidget(
      {required Widget child,
      required Activity activity,
      Function()? onForward,
      Function()? onBack,
      bool isOnBackDisabled = false})
      : _child = child,
        _activity = activity,
        _onForward = onForward,
        _onBack = onBack,
        _isOnBackDisabled = isOnBackDisabled,
        super();

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      isAppBarShown: true,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.only(left: 10, right: 10, bottom: 30),
        child: Column(
          children: [
            _child,
            _WordListWidgetListeningToCurrentActivityAnswer(wordEntries: _activity.wordEntries),
            ActivityGenerationButtons(
              onBack: _onBack,
              onForward: _onForward,
              isOnBackDisabled: _isOnBackDisabled,
              margin: const EdgeInsets.only(bottom: 30),
            ),
            ActivityAnswerFormWidget(),
          ],
        ),
      ),
    );
  }
}

class _WordListWidgetListeningToCurrentActivityAnswer extends StatefulWidget {
  final List<WordEntry> _wordEntries;

  _WordListWidgetListeningToCurrentActivityAnswer({required List<WordEntry> wordEntries}) : _wordEntries = wordEntries;

  @override
  _WordListWidgetListeningToCurrentActivityAnswerState createState() =>
      _WordListWidgetListeningToCurrentActivityAnswerState();
}

class _WordListWidgetListeningToCurrentActivityAnswerState
    extends State<_WordListWidgetListeningToCurrentActivityAnswer> {
  late ActivityProvider _activityProvider;
  List<WordListItemDto> _wordListItemDtos = [];

  @override
  void initState() {
    super.initState();

    _activityProvider = Provider.of<ActivityProvider>(context, listen: false);

    _wordListItemDtos = widget._wordEntries
        .map(
          (e) => WordListItemDto(
            wordEntry: e,
            isHighlited: e.isWordPresentInText(_activityProvider.currentActivityAnswer.get()),
          ),
        )
        .toList();

    _activityProvider.currentActivityAnswer.subscribe(_onCurrentActivityAnswerChange);
  }

  @override
  void dispose() {
    super.dispose();
    _activityProvider.currentActivityAnswer.unsubscribe(_onCurrentActivityAnswerChange);
  }

  void _onCurrentActivityAnswerChange(String currentAnswer) {
    for (var dto in _wordListItemDtos) {
      var isPresent = dto.wordEntry.isWordPresentInText(currentAnswer);

      if (isPresent && !dto.isHighlited) {
        _notifyUserAboutWordUsage(dto.wordEntry.word);
      }

      dto.isHighlited = isPresent;
    }

    setState(() {});
  }

  void _notifyUserAboutWordUsage(String word) {
    SchedulerBinding.instance?.addPostFrameCallback((timeStamp) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Just used '$word' !",
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
    return WordListWidget(
      wordListItemDtos: _wordListItemDtos,
      margin: const EdgeInsets.only(bottom: 25),
    );
  }
}
