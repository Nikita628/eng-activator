import 'dart:async';
import 'package:eng_activator_app/models/activity/activity.dart';
import 'package:eng_activator_app/models/activity/picture_activity.dart';
import 'package:eng_activator_app/models/activity/question_activity.dart';
import 'package:eng_activator_app/services/activity/activity_service.dart';
import 'package:eng_activator_app/shared/services/event_hub.dart';
import 'package:eng_activator_app/shared/services/injector.dart';
import 'package:eng_activator_app/widgets/activity/activity_answer_form.dart';
import 'package:eng_activator_app/widgets/activity/activity_generation_buttons.dart';
import 'package:eng_activator_app/widgets/dialogs/first_picture_activity_dialog.dart';
import 'package:eng_activator_app/widgets/dialogs/first_question_activity_dialog.dart';
import 'package:eng_activator_app/widgets/ui_elements/app_scaffold.dart';
import 'package:eng_activator_app/widgets/word_list.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _firstPictureActivityKey = "eng-activator-first-pic-activity";
const _firstQuestionActivityKey = "eng-activator-first-quest-activity";

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
  // final EventHub _eventHub = Injector.get<EventHub>();

  @override
  void initState() {
    super.initState();

    // if (widget._activity is PictureActivity) {
    //   Future.delayed(Duration(milliseconds: 500), () {
    //     _eventHub.notifyListeners("updateScrollPosition_AppScaffold");
    //   }); 
    // }

    SharedPreferences.getInstance().then((value) {
      if (widget._activity is QuestionActivity && !value.containsKey(_firstQuestionActivityKey)) {
        _showFirstActivityDialog(FirstQuestionActivityDialog(), _firstQuestionActivityKey);
      } else if (widget._activity is PictureActivity && !value.containsKey(_firstPictureActivityKey)) {
        _showFirstActivityDialog(FirstPictureActivityDialog(), _firstPictureActivityKey);
      }
    }).catchError((e) {});
  }

  Future<void> _showFirstActivityDialog(Widget dialog, String key) async {
    await showDialog<int>(
        context: context,
        builder: (BuildContext context) {
          return dialog;
        });

    var sharedPrefs = await SharedPreferences.getInstance();
    sharedPrefs.setBool(key, true);
  }

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
