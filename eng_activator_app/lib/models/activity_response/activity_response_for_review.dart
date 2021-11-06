import 'dart:convert';
import 'package:eng_activator_app/models/activity/activity.dart';
import 'package:eng_activator_app/models/activity/picture_activity.dart';
import 'package:eng_activator_app/models/activity/question_activity.dart';
import 'package:eng_activator_app/models/user.dart';
import 'package:eng_activator_app/shared/enums.dart';

class ActivityResponseForReview {
  late int id;
  late String answer;
  late ActivityTypeEnum activityTypeId;
  late Activity activity;
  late User createdBy;

  ActivityResponseForReview.fromJson(Map<String, dynamic> json) {
    id = json["id"] ?? 0;
    answer = json["answer"] ?? "";
    activityTypeId = ActivityTypeEnum.values[json["activityTypeId"] - 1];
    createdBy = User.fromJson(json["createdBy"]);

    var activityMap = jsonDecode(json["activity"]);
    activity = activityTypeId == ActivityTypeEnum.Question
        ? QuestionActivity.fromJson(activityMap)
        : PictureActivity.fromJson(activityMap);
  }
}