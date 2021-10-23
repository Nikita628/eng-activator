import 'package:eng_activator_app/models/activity/picture_activity.dart';
import 'package:eng_activator_app/models/activity/question_activity.dart';
import 'package:eng_activator_app/state/activity_provider.dart';
import 'package:eng_activator_app/widgets/activity/activity.dart';
import 'package:eng_activator_app/widgets/activity_picture_widget.dart';
import 'package:eng_activator_app/widgets/activity_question_widget.dart';
import 'package:eng_activator_app/widgets/ui_elements/empty_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CurrentActivityWidget extends StatefulWidget {
  static const String screenUrl = '/current-activity';

  const CurrentActivityWidget({Key? key}) : super(key: key);

  @override
  _CurrentActivityWidgetState createState() => _CurrentActivityWidgetState();
}

class _CurrentActivityWidgetState extends State<CurrentActivityWidget> {
  @override
  Widget build(BuildContext context) {
    var activityProvider = Provider.of<ActivityProvider>(context, listen: false);
    var activity = activityProvider.getCurrentActivity();

    if (activity is QuestionActivity) {
      return ActivityWidget(
        activity: activity,
        child: ActivityQuestionWidget(
          text: activity.question,
          margin: const EdgeInsets.only(top: 10, bottom: 25),
        ),
      );
    } else if (activity is PictureActivity) {
      return ActivityWidget(
        activity: activity,
        child: ActivityPictureWidget(
          picUrl: activity.picUrl,
          margin: const EdgeInsets.only(top: 10, bottom: 25),
        ),
      );
    } else {
      return EmptyScreenWidget();
    }
  }
}
