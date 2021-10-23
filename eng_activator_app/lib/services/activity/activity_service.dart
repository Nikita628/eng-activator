import 'package:eng_activator_app/shared/services/app_navigator.dart';
import 'package:eng_activator_app/shared/services/injector.dart';
import 'package:eng_activator_app/shared/enums.dart';
import 'package:eng_activator_app/state/activity_provider.dart';
import 'package:eng_activator_app/widgets/dialogs/losing_progress_warning_dialog.dart';
import 'package:eng_activator_app/widgets/screens/activity/current_activity.dart';
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
    if (activityType == ActivityTypeEnum.Picture) {
      provider.setRandomPictureActivity();
      _appNavigator.replaceCurrentUrl(CurrentActivityWidget.screenUrl, ctx);
    } else if (activityType == ActivityTypeEnum.Question) {
      provider.setRandomQuestionActivity();
      _appNavigator.replaceCurrentUrl(CurrentActivityWidget.screenUrl, ctx);
    }
  }
}
