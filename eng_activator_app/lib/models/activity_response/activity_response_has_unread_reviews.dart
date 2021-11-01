class ActivityResponseHasMoreUnreadReviews {
  late bool activityResponseHasUnreadReviews;

  ActivityResponseHasMoreUnreadReviews.fromJson(Map<String, dynamic> json) {
    activityResponseHasUnreadReviews = json["activityResponseHasUnreadReviews"];
  }
}
