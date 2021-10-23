import 'package:eng_activator_app/models/activity_response/activity_response.dart';
import 'package:eng_activator_app/models/activity_response/activity_response_review.dart';
import 'package:eng_activator_app/models/activity/picture_activity.dart';
import 'package:eng_activator_app/models/user.dart';

class PictureActivityResponse extends ActivityResponse {
  PictureActivityResponse({
    required String answer,
    required PictureActivity activity,
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
