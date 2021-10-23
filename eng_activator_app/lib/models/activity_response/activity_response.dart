import 'package:eng_activator_app/models/activity/activity.dart';
import 'package:eng_activator_app/models/activity_response/activity_response_review.dart';
import 'package:eng_activator_app/models/user.dart';

class ActivityResponse {
  late Activity activity;
  late String answer;
  late DateTime createdDate;
  late User createdBy;
  List<ActivityResponseReview> reviews = [];

  ActivityResponse({
    required String answer,
    required List<ActivityResponseReview> reviews,
    required DateTime createdDate,
    required User createdBy,
    required Activity activity,
  }) {
    this.answer = answer;
    this.reviews = reviews;
    this.createdBy = createdBy;
    this.createdDate = createdDate;
    this.activity = activity;
  }

  Map<String, dynamic> toJson() {
    return {
      "answer": answer,
      "createdDate": createdDate.toString(),
      "activity": activity.toJson(),
      "createdBy": createdBy.toJson(),
    };
  }
}
