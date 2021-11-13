import 'package:eng_activator_app/models/activity/picture_activity.dart';
import 'package:eng_activator_app/models/activity/question_activity.dart';
import 'package:eng_activator_app/shared/services/app_navigator.dart';
import 'package:eng_activator_app/shared/services/injector.dart';
import 'package:eng_activator_app/shared/enums.dart';
import 'package:eng_activator_app/state/activity_provider.dart';
import 'package:eng_activator_app/widgets/dialogs/losing_progress_warning_dialog.dart';
import 'package:eng_activator_app/widgets/screens/activity/picture_activity_screen.dart';
import 'package:eng_activator_app/widgets/screens/activity/question_activity_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ActivityService {
  final AppNavigator _appNavigator = Injector.get<AppNavigator>();

  void navigateToNewRandomActivity(ActivityTypeEnum activityType, BuildContext ctx) {
    var provider = Provider.of<ActivityProvider>(ctx, listen: false);

    if (provider.getCurrentActivityAnswer().length > 0) {
      showDialog(
        context: ctx,
        builder: (_) => LosingProgressWarningDialog(),
      ).then(
        (value) {
          if (value == true) {
            _generateAndNavigateToNewActivity(activityType, provider, ctx);
          }
        },
      );
    } else {
      _generateAndNavigateToNewActivity(activityType, provider, ctx);
    }
  }

  void _generateAndNavigateToNewActivity(ActivityTypeEnum activityType, ActivityProvider provider, BuildContext ctx) {
    provider.resetState();
    provider.generateNewActivityOnInitialization = true;

    if (activityType == ActivityTypeEnum.Picture) {
      _appNavigator.replaceCurrentUrl(PictureActivityScreen.screenUrl, ctx);
    } else if (activityType == ActivityTypeEnum.Question) {
      _appNavigator.replaceCurrentUrl(QuestionActivityScreen.screenUrl, ctx);
    }
  }

  void navigateToCurrentActivity(BuildContext context) {
    var activityProvider = Provider.of<ActivityProvider>(context, listen: false);
    var currentActivity = activityProvider.getCurrentActivity();
    activityProvider.generateNewActivityOnInitialization = false;

    if (currentActivity is QuestionActivity) {
      _appNavigator.replaceCurrentUrl(QuestionActivityScreen.screenUrl, context);
    } else if (currentActivity is PictureActivity) {
      _appNavigator.replaceCurrentUrl(PictureActivityScreen.screenUrl, context);
    }
  }
}
