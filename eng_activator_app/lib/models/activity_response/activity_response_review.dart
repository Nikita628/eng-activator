import 'package:eng_activator_app/models/user.dart';

class ActivityResponseReview {
  late int id;
  late String text;
  late double score;
  late User createdBy;
  late DateTime createdDate;
  late bool isViewed;

  ActivityResponseReview({
    required String text,
    required double score,
    required User createdBy,
    required DateTime createdDate,
    required bool isViewed,
    required int id,
  }) {
    this.text = text;
    this.score = score;
    this.createdBy = createdBy;
    this.createdDate = createdDate;
    this.id = id;
    this.isViewed = isViewed;
  }

  ActivityResponseReview.fromJson(Map<String, dynamic> json) {
    id = json["id"] ?? 0;
    text = json["text"] ?? "";
    score = json["score"] ?? 0;
    createdBy = User.fromJson(json["createdBy"]);
    createdDate = DateTime.parse(json["createdDate"]);
    isViewed = json["isViewed"] ?? false;
  }
}
