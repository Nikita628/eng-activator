class ActivityResponseReviewForCreate {
  String text;
  int activityResponseId;
  double score;

  ActivityResponseReviewForCreate({
    required String text,
    required int activityResponseId,
    required double score,
  })  : text = text,
        activityResponseId = activityResponseId,
        score = score;

  Map<String, dynamic> toJson() {
    return {
      "text": text,
      "activityResponseId": activityResponseId,
      "score": score,
    };
  }
}
