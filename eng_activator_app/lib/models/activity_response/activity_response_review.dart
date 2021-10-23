import 'package:eng_activator_app/models/user.dart';

class ActivityResponseReview {
  late String text;
  late double score;
  late User createdBy;
  late DateTime createdDate;

  ActivityResponseReview({
    required String text,
    required double score,
    required User createdBy,
    required DateTime createdDate,
  }) {
    this.text = text;
    this.score = score;
    this.createdBy = createdBy;
    this.createdDate = createdDate;
  }
}
