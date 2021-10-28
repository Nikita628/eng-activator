import 'package:eng_activator_app/models/activity_response/activity_response_details.dart';
import 'package:eng_activator_app/widgets/activity_response/activity_answer_and_reviews_panel.dart';
import 'package:eng_activator_app/widgets/ui_elements/app_scaffold.dart';
import 'package:eng_activator_app/widgets/word_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ActivityResponseDetailsWidget extends StatefulWidget {
  final ActivityResponseDetails _activityResponse;
  final Widget _child;

  ActivityResponseDetailsWidget({
    required ActivityResponseDetails activityResponse,
    required Widget child,
  })  : _activityResponse = activityResponse,
        _child = child;

  @override
  _ActivityResponseDetailsWidgetState createState() => _ActivityResponseDetailsWidgetState();
}

class _ActivityResponseDetailsWidgetState extends State<ActivityResponseDetailsWidget> {
  @override
  Widget build(BuildContext context) {    
    return AppScaffold(
      isAppBarShown: true,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.only(left: 10, right: 10, bottom: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            widget._child,
            WordListWidget(
              wordEntries: widget._activityResponse.activity.wordEntries,
              margin: const EdgeInsets.only(bottom: 30),
            ),
            ActivityAnswerAndReviewsPanel(activityResponse: widget._activityResponse),
          ],
        ),
      ),
    );
  }
}
