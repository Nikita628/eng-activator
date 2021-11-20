import 'package:eng_activator_app/models/activity/activity.dart';
import 'package:eng_activator_app/models/activity/question_activity.dart';
import 'package:eng_activator_app/models/activity_response/activity_response_for_create.dart';
import 'package:eng_activator_app/models/activity_response_review/activity_response_review_for_create.dart';
import 'package:eng_activator_app/services/activity/activity_validator.dart';
import 'package:eng_activator_app/services/api_clients/activity_response_api_client.dart';
import 'package:eng_activator_app/services/api_clients/activity_response_review_api_client.dart';
import 'package:eng_activator_app/shared/enums.dart';
import 'package:eng_activator_app/shared/services/app_navigator.dart';
import 'package:eng_activator_app/shared/services/injector.dart';
import 'package:eng_activator_app/shared/constants.dart';
import 'package:eng_activator_app/state/activity_provider.dart';
import 'package:eng_activator_app/state/activity_response_provider.dart';
import 'package:eng_activator_app/widgets/screens/activity_response/activity_response_list.dart';
import 'package:eng_activator_app/widgets/ui_elements/app_spinner.dart';
import 'package:eng_activator_app/widgets/ui_elements/rounded_button.dart';
import 'package:eng_activator_app/widgets/ui_elements/text_area.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ActivityReviewFormWidget extends StatefulWidget {
  final EdgeInsets? _margin;
  final int _activityResponseId;

  const ActivityReviewFormWidget({Key? key, EdgeInsets? margin, required activityResponseId})
      : _margin = margin,
        _activityResponseId = activityResponseId,
        super(key: key);

  @override
  _ActivityReviewFormWidgetState createState() => _ActivityReviewFormWidgetState();
}

class _ActivityReviewFormWidgetState extends State<ActivityReviewFormWidget> {
  final _appNavigator = Injector.get<AppNavigator>();
  final _activityResponseApiClient = Injector.get<ActivityResponseApiClient>();
  final _activityResponseReviewApiClient = Injector.get<ActivityResponseReviewApiClient>();
  final _formKey = GlobalKey<FormState>();
  final _activityValidator = ActivityValidator();
  String _review = '';
  double _score = 0;
  WidgetStatusEnum _buttonStatus = WidgetStatusEnum.Default;

  void _setButtonStatus(WidgetStatusEnum status) {
    if (mounted) {
      setState(() {
        _buttonStatus = status;
      });
    }
  }

  Future<void> _sendReview() async {
    bool? isValid = _formKey.currentState?.validate();

    if (isValid != true) {
      return;
    }

    _formKey.currentState?.save();

    _setButtonStatus(WidgetStatusEnum.Loading);

    var dto = ActivityResponseReviewForCreate(
      text: _review,
      activityResponseId: widget._activityResponseId,
      score: _score,
    );

    try {
      await _activityResponseReviewApiClient.create(dto, context);
      await _sendActivityResponse();
      Provider.of<ActivityResponseProvider>(context, listen: false).isActivityResponseListOpenedFromBackButton = false;
      _appNavigator.replaceCurrentUrl(ActivityResponseListWidget.screenUrl, context);
    } catch (e) {
      _setButtonStatus(WidgetStatusEnum.Default);
    }
  }

  Future<void> _sendActivityResponse() async {
    var activityProvider = Provider.of<ActivityProvider>(context, listen: false);
    var currentActivity = activityProvider.getCurrentActivity();
    var activityType = currentActivity is QuestionActivity ? ActivityTypeEnum.Question : ActivityTypeEnum.Picture;
    var activityResponse = ActivityResponseForCreate(
      answer: activityProvider.currentActivityAnswer.get(),
      activity: currentActivity as Activity,
      activityTypeId: activityType,
    );

    await _activityResponseApiClient.create(activityResponse, context);

    activityProvider.resetState();
  }

  void _onReviewTextChanged(String text) {
    _review = text;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: widget._margin,
      padding: const EdgeInsets.only(right: 10, left: 10),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            const SizedBox(height: 10),
            CircleAvatar(
              backgroundColor: Color(AppColors.yellow),
              radius: 30,
              child: Text(
                _score.toStringAsFixed(2),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Color(AppColors.green),
                ),
              ),
            ),
            const SizedBox(height: 10),
            SliderTheme(
              data: SliderThemeData(
                trackHeight: 8,
                activeTickMarkColor: Color(AppColors.grey),
                inactiveTickMarkColor: Color(AppColors.grey),
                tickMarkShape: SliderTickMarkShape.noTickMark,
              ),
              child: Slider(
                value: _score,
                min: 0,
                max: 5,
                divisions: 10,
                label: _score.toStringAsFixed(1),
                activeColor: Color(AppColors.green),
                inactiveColor: Color(AppColors.grey),
                onChanged: (double value) {
                  setState(() {
                    _score = value;
                  });
                },
              ),
            ),
            const SizedBox(height: 20),
            AppTextAreaWidget(
              validator: _activityValidator.validateRequiredAndSwearing,
              onSaved: (val) => _review = val ?? '',
              placeholder: 'Type your review here...',
              onChanged: _onReviewTextChanged,
              value: _review,
            ),
            const SizedBox(height: 15),
            RoundedButton(
              disabled: _buttonStatus == WidgetStatusEnum.Loading,
              bgColor: Color(AppColors.green),
              padding: const EdgeInsets.only(top: 10, bottom: 10, right: 30, left: 30),
              child: _buttonStatus == WidgetStatusEnum.Loading
                  ? AppSpinner()
                  : Text(
                      'SEND REVIEW',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
              onPressed: _sendReview,
            ),
          ],
        ),
      ),
    );
  }
}
