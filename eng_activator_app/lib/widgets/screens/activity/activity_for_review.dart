import 'package:eng_activator_app/models/activity_response/activity_response.dart';
import 'package:eng_activator_app/models/activity/picture_activity.dart';
import 'package:eng_activator_app/models/activity_response/picture_activity_response.dart';
import 'package:eng_activator_app/models/activity/question_activity.dart';
import 'package:eng_activator_app/models/activity_response/question_activity_response.dart';
import 'package:eng_activator_app/models/word_entry.dart';
import 'package:eng_activator_app/shared/services/injector.dart';
import 'package:eng_activator_app/shared/services/mock_api.dart';
import 'package:eng_activator_app/shared/services/storage.dart';
import 'package:eng_activator_app/shared/constants.dart';
import 'package:eng_activator_app/widgets/activity_response/activity_review_form.dart';
import 'package:eng_activator_app/widgets/activity_picture_widget.dart';
import 'package:eng_activator_app/widgets/activity_question_widget.dart';
import 'package:eng_activator_app/widgets/ui_elements/app_scaffold.dart';
import 'package:eng_activator_app/widgets/ui_elements/empty_screen.dart';
import 'package:eng_activator_app/widgets/word_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ActivityForReview extends StatefulWidget {
  static final String screenUrl = 'activity-for-review';

  const ActivityForReview({Key? key}) : super(key: key);

  @override
  _ActivityForReviewState createState() => _ActivityForReviewState();
}

class _ActivityForReviewState extends State<ActivityForReview> {
  final MockApi _api = Injector.get<MockApi>();
  final AppStorage _appStorage = Injector.get<AppStorage>();
  late ActivityResponse _activityResponse;
  late QuestionActivity _questionActivity;
  late PictureActivity _pictureActivity;
  late List<WordEntry> _wordEntries;
  late bool _isOverallSpinner = true;

  @override
  void initState() {
    _api.getActivityResponses().then((value) {
      if (mounted) {
        setState(() {
          _isOverallSpinner = false;
          _activityResponse = value[_appStorage.getRandomInt(value.length)];
          _wordEntries = _activityResponse.activity.wordEntries;

          if (_activityResponse is QuestionActivityResponse) {
            _questionActivity = _activityResponse.activity as QuestionActivity;
          } else if (_activityResponse is PictureActivityResponse) {
            _pictureActivity = _activityResponse.activity as PictureActivity;
          }
        });
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (_isOverallSpinner) {
      return EmptyScreenWidget(isSpinner: true);
    }

    return AppScaffold(
      isAppBarShown: true,
      child: Container(
        padding: EdgeInsets.only(bottom: 30),
        child: Column(
          children: [
            _activityResponse is QuestionActivityResponse
                ? ActivityQuestionWidget(
                    text: _questionActivity.question,
                    margin: const EdgeInsets.only(top: 10, bottom: 10, left: 10, right: 10),
                  )
                : ActivityPictureWidget(
                    picUrl: _pictureActivity.picUrl,
                    margin: const EdgeInsets.only(top: 10, bottom: 10, left: 10, right: 10),
                  ),
            WordListWidget(
              wordEntries: _wordEntries,
              margin: const EdgeInsets.only(top: 10, bottom: 30, left: 10, right: 10),
            ),
            Container(
              padding: const EdgeInsets.only(left: 10, right: 10),
              width: double.infinity,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    'Answer',
                    style: TextStyle(
                      fontSize: 20,
                      color: Color(AppColors.green),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 15),
                  Text(
                    "By ${_activityResponse.createdBy.name}",
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(AppColors.grey),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 20, thickness: 3, indent: 10, endIndent: 10, color: Color(AppColors.green)),
            Container(
              padding: const EdgeInsets.only(left: 10, right: 10),
              margin: const EdgeInsets.only(bottom: 15),
              width: double.infinity,
              child: Text(
                _activityResponse.answer,
                softWrap: true,
                style: TextStyle(
                  fontSize: 16,
                  color: Color(AppColors.black),
                  height: 1.7,
                ),
              ),
            ),
            ActivityReviewFormWidget(),
          ],
        ),
      ),
    );
  }
}
