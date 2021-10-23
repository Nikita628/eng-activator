import 'package:eng_activator_app/models/activity/activity.dart';
import 'package:eng_activator_app/services/activity/activity_service.dart';
import 'package:eng_activator_app/shared/services/injector.dart';
import 'package:eng_activator_app/widgets/activity/activity_answer_form.dart';
import 'package:eng_activator_app/widgets/activity/activity_generation_buttons.dart';
import 'package:eng_activator_app/widgets/ui_elements/app_scaffold.dart';
import 'package:eng_activator_app/widgets/word_list.dart';
import 'package:flutter/material.dart';

class ActivityWidget extends StatefulWidget {
  final Widget _child;
  final Activity _activity;

  ActivityWidget({required Widget child, required Activity activity})
      : _child = child,
        _activity = activity,
        super();

  @override
  State<StatefulWidget> createState() {
    return _ActivityState();
  }
}

class _ActivityState extends State<ActivityWidget> {
  final ActivityService _activityService = Injector.get<ActivityService>();

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      isAppBarShown: true,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.only(left: 10, right: 10, bottom: 30),
        child: Column(
          children: [
            widget._child,
            WordListWidget(
              wordEntries: widget._activity.wordEntries,
              margin: const EdgeInsets.only(bottom: 25),
            ),
            ActivityGenerationButtons(
              onPressed: (a) {
                _activityService.navigateToNewRandomActivity(a, context);
              },
              margin: const EdgeInsets.only(bottom: 30),
            ),
            ActivityAnswerFormWidget(),
          ],
        ),
      ),
    );
  }
}
