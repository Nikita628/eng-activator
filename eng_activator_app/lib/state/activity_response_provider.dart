import 'package:eng_activator_app/models/activity_response/activity_response_preview.dart';
import 'package:eng_activator_app/models/activity_response/activity_response_search_param.dart';
import 'package:flutter/material.dart';

class ActivityResponseProvider with ChangeNotifier {
  final List<ActivityResponsePreview> previews = [];
  ActivityResponseSearchParam currentSearchParam = ActivityResponseSearchParam();
  int totalCount = 0;
  double scrollPosition = 0;

  void resetState() {
    previews.clear();
    currentSearchParam = ActivityResponseSearchParam();
    totalCount = 0;
    scrollPosition = 0;
  }
}
