import 'package:eng_activator_app/models/user.dart';

class ActivityResponseReview {
  late int id;
  late int activityResponseId;
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
    required int activityResponseId,
  }) {
    this.text = text;
    this.score = score;
    this.createdBy = createdBy;
    this.createdDate = createdDate;
    this.id = id;
    this.isViewed = isViewed;
    this.activityResponseId = activityResponseId;
  }

  ActivityResponseReview.fromJson(Map<String, dynamic> json) {
    id = json["id"] ?? 0;
    text = json["text"] ?? "";
    
    score = 0;

    var scoreFromJson = json["score"];

    if (scoreFromJson is int) {
      score = scoreFromJson.toDouble();
    } else if (scoreFromJson is double) {
      score = scoreFromJson.toDouble();
    }
    
    createdBy = User.fromJson(json["createdBy"]);
    createdDate = DateTime.parse(json["createdDate"] + 'Z').toLocal();
    isViewed = json["isViewed"] ?? false;
    activityResponseId = json["activityResponseId"] ?? 0;
  }
}
