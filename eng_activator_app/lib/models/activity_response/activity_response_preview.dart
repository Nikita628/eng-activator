import 'package:eng_activator_app/shared/enums.dart';

class ActivityResponsePreview {
  late int id;
  late String answer;
  late ActivityTypeEnum activityTypeId;
  late DateTime createdDateLocal;
  late bool hasUnreadReviews;
  late DateTime lastUpdatedDateUtc;

  ActivityResponsePreview.fromJson(Map<String, dynamic> json) {
    id = json["id"] ?? 0;
    answer = json["answer"] ?? "";
    activityTypeId = ActivityTypeEnum.values[json["activityTypeId"] - 1];
    createdDateLocal = DateTime.parse(json["createdDate"] + 'Z').toLocal();
    hasUnreadReviews = json["hasUnreadReviews"] ?? false;
    lastUpdatedDateUtc = DateTime.parse(json["lastUpdatedDate"]);
  }
}
