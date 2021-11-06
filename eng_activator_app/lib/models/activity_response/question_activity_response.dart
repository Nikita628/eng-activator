import 'package:eng_activator_app/models/activity_response/activity_response.dart';
import 'package:eng_activator_app/models/activity_response_review/activity_response_review.dart';
import 'package:eng_activator_app/models/activity/question_activity.dart';
import 'package:eng_activator_app/models/user.dart';

class QuestionActivityResponse extends ActivityResponse {
  QuestionActivityResponse({
    required String answer,
    required QuestionActivity activity,
    required List<ActivityResponseReview> reviews,
    required DateTime createdDate,
    required User createdBy,
  }) : super(
          answer: answer,
          reviews: reviews,
          createdBy: createdBy,
          createdDate: createdDate,
          activity: activity,
        ) {}
}
