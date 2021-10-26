import 'package:eng_activator_app/shared/enums.dart';

class ActivityResponsePreview {
  late int id;
  late String answer;
  late ActivityTypeEnum activityTypeId;
  late DateTime createdDate;
  late bool hasUnreadReviews;

  ActivityResponsePreview.fromJson(Map<String, dynamic> json) {
    id = json["id"] ?? 0;
    answer = json["answer"] ?? "";
    activityTypeId = ActivityTypeEnum.values[json["activityTypeId"] - 1];
    createdDate = DateTime.parse(json["createdDate"]);
    hasUnreadReviews = json["hasUnreadReviews"] ?? false;
  }
}
