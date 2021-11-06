import 'dart:convert';
import 'package:eng_activator_app/models/activity/activity.dart';
import 'package:eng_activator_app/shared/enums.dart';

class ActivityResponseForCreate {
  String answer;
  Activity activity;
  ActivityTypeEnum activityTypeId;

  ActivityResponseForCreate({
    required String answer,
    required Activity activity,
    required ActivityTypeEnum activityTypeId,
  })  : answer = answer,
        activity = activity,
        activityTypeId = activityTypeId;

  Map<String, dynamic> toJson() {
    return {
      "answer": answer,
      "activity": jsonEncode(activity),
      "activityTypeId": activityTypeId.index + 1,
    };
  }
}
