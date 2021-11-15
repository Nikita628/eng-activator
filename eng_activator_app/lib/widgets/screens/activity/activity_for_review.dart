import 'package:eng_activator_app/models/activity/picture_activity.dart';
import 'package:eng_activator_app/models/activity_response/activity_response_for_review.dart';
import 'package:eng_activator_app/models/activity/question_activity.dart';
import 'package:eng_activator_app/models/word_entry.dart';
import 'package:eng_activator_app/shared/enums.dart';
import 'package:eng_activator_app/shared/constants.dart';
import 'package:eng_activator_app/state/activity_response_provider.dart';
import 'package:eng_activator_app/widgets/activity_response/activity_review_form.dart';
import 'package:eng_activator_app/widgets/activity_picture_widget.dart';
import 'package:eng_activator_app/widgets/activity_question_widget.dart';
import 'package:eng_activator_app/widgets/ui_elements/app_scaffold.dart';
import 'package:eng_activator_app/widgets/ui_elements/exit_warning_on_pop.dart';
import 'package:eng_activator_app/widgets/word_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ActivityForReview extends StatefulWidget {
  static final String screenUrl = 'activity-for-review';

  const ActivityForReview({Key? key}) : super(key: key);

  @override
  _ActivityForReviewState createState() => _ActivityForReviewState();
}

class _ActivityForReviewState extends State<ActivityForReview> {
  late ActivityResponseForReview _activityResponse;
  QuestionActivity? _questionActivity;
  PictureActivity? _pictureActivity;
  List<WordEntry> _wordEntries = [];

  @override
  void initState() {
    _activityResponse = Provider.of<ActivityResponseProvider>(context, listen: false).activityResponseForReview
        as ActivityResponseForReview;

    _wordEntries = _activityResponse.activity.wordEntries;

    if (_activityResponse.activityTypeId == ActivityTypeEnum.Question) {
      _questionActivity = _activityResponse.activity as QuestionActivity;
    } else if (_activityResponse.activityTypeId == ActivityTypeEnum.Picture) {
      _pictureActivity = _activityResponse.activity as PictureActivity;
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ExitWarningOnPopWidget(
      child: AppScaffold(
        isAppBarShown: true,
        child: Container(
          padding: EdgeInsets.only(bottom: 30),
          child: Column(
            children: [
              if (_activityResponse.activityTypeId == ActivityTypeEnum.Question)
                ActivityQuestionWidget(
                  text: _questionActivity?.question as String,
                  margin: const EdgeInsets.only(top: 10, bottom: 10, left: 10, right: 10),
                ),
              if (_activityResponse.activityTypeId == ActivityTypeEnum.Picture)
                ActivityPictureWidget(
                  picUrl: _pictureActivity?.picUrl as String,
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
              ActivityReviewFormWidget(activityResponseId: _activityResponse.id),
            ],
          ),
        ),
      ),
    );
  }
}
