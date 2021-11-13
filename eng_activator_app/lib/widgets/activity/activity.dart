import 'package:eng_activator_app/models/activity/activity.dart';
import 'package:eng_activator_app/widgets/activity/activity_answer_form.dart';
import 'package:eng_activator_app/widgets/activity/activity_generation_buttons.dart';
import 'package:eng_activator_app/widgets/ui_elements/app_scaffold.dart';
import 'package:eng_activator_app/widgets/word_list.dart';
import 'package:flutter/material.dart';

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
            WordListWidget(
              wordEntries: _activity.wordEntries,
              margin: const EdgeInsets.only(bottom: 25),
            ),
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
