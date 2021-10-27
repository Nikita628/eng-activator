import 'package:eng_activator_app/models/activity/question_activity.dart';
import 'package:eng_activator_app/models/activity_response/question_activity_response.dart';
import 'package:eng_activator_app/shared/services/injector.dart';
import 'package:eng_activator_app/shared/services/mock_api.dart';
import 'package:eng_activator_app/widgets/activity_question_widget.dart';
import 'package:eng_activator_app/widgets/activity_response/activity_response_details.dart';
import 'package:eng_activator_app/widgets/ui_elements/empty_screen.dart';
import 'package:flutter/material.dart';

class QuestionActivityResponseWidget extends StatefulWidget {
  static final String screenUrl = '/question-activity-response';
  final int _questionActivityResponseId;

  QuestionActivityResponseWidget({required int questionActivityResponseId})
      : _questionActivityResponseId = questionActivityResponseId,
        super();

  @override
  _QuestionActivityResponseWidgetState createState() => _QuestionActivityResponseWidgetState();
}

class _QuestionActivityResponseWidgetState extends State<QuestionActivityResponseWidget> {
  final MockApi _api = Injector.get<MockApi>();
  late QuestionActivityResponse _response;
  late QuestionActivity _activity;
  late bool _isSpinner = true;

  @override
  void initState() {
    _api.getActivityResponses().then((value) {
      if (mounted) {
        setState(() {
          _isSpinner = false;
          _response = value[0] as QuestionActivityResponse;
          _activity = _response.activity as QuestionActivity;
        });
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
    // return _isSpinner
    //     ? EmptyScreenWidget()
    //     : ActivityResponseDetailsWidget(
    //         activityResponse: _response,
    //         child: ActivityQuestionWidget(
    //           text: _activity.question,
    //           margin: const EdgeInsets.only(bottom: 20, top: 20),
    //         ),
    //       );
  }
}
