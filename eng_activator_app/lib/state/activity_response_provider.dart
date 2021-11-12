import 'package:eng_activator_app/models/activity_response/activity_response_for_review.dart';
import 'package:eng_activator_app/models/activity_response/activity_response_preview.dart';
import 'package:eng_activator_app/models/activity_response/activity_response_search_param.dart';
import 'package:flutter/material.dart';

class ActivityResponseProvider with ChangeNotifier {
  final List<ActivityResponsePreview> previews = [];
  ActivityResponseSearchParam currentSearchParam = ActivityResponseSearchParam();
  bool hasMoreItems = false;
  double scrollPosition = 0;
  ActivityResponseForReview? activityResponseForReview;
  int activityResponseDetailsId = 0;
  bool isActivityResponseListOpenedFromBackButton = false;

  void resetState() {
    previews.clear();
    currentSearchParam = ActivityResponseSearchParam();
    hasMoreItems = false;
    scrollPosition = 0;
    activityResponseForReview = null;
    activityResponseDetailsId = 0;
    isActivityResponseListOpenedFromBackButton = false;
  }
}
