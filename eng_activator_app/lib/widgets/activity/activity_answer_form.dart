import 'package:eng_activator_app/models/activity/activity.dart';
import 'package:eng_activator_app/models/activity/question_activity.dart';
import 'package:eng_activator_app/models/activity_response/activity_response_for_create.dart';
import 'package:eng_activator_app/models/activity_response/activity_response_for_review.dart';
import 'package:eng_activator_app/services/activity/activity_validator.dart';
import 'package:eng_activator_app/services/api_clients/activity_response_api_client.dart';
import 'package:eng_activator_app/shared/enums.dart';
import 'package:eng_activator_app/shared/services/app_navigator.dart';
import 'package:eng_activator_app/shared/services/injector.dart';
import 'package:eng_activator_app/shared/constants.dart';
import 'package:eng_activator_app/state/activity_provider.dart';
import 'package:eng_activator_app/state/activity_response_provider.dart';
import 'package:eng_activator_app/widgets/dialogs/activity_for_review_not_found_dialog.dart';
import 'package:eng_activator_app/widgets/dialogs/asking_for_review_dialog.dart';
import 'package:eng_activator_app/widgets/screens/activity/activity_for_review.dart';
import 'package:eng_activator_app/widgets/screens/activity_response/activity_response_list.dart';
import 'package:eng_activator_app/widgets/ui_elements/app_spinner.dart';
import 'package:eng_activator_app/widgets/ui_elements/rounded_button.dart';
import 'package:eng_activator_app/widgets/ui_elements/text_area.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ActivityAnswerFormWidget extends StatefulWidget {
  final EdgeInsets? _margin;

  const ActivityAnswerFormWidget({Key? key, EdgeInsets? margin})
      : _margin = margin,
        super(key: key);

  @override
  _ActivityAnswerFormWidgetState createState() => _ActivityAnswerFormWidgetState();
}

class _ActivityAnswerFormWidgetState extends State<ActivityAnswerFormWidget> {
  final _formKey = GlobalKey<FormState>();
  final _appNavigator = Injector.get<AppNavigator>();
  final _activityValidator = Injector.get<ActivityValidator>();
  final _activityResponseApiClient = Injector.get<ActivityResponseApiClient>();
  var _buttonStatus = WidgetStatusEnum.Default;
  late ActivityProvider _activityProvider;

  @override
  void initState() {
    super.initState();
    _activityProvider = Provider.of<ActivityProvider>(context, listen: false);
  }

  void _setButtonStatus(WidgetStatusEnum status) {
    if (mounted) {
      setState(() {
        _buttonStatus = status;
      });
    }
  }

  void _onAnswerFormChanged(String text) {
    _activityProvider.setCurrentActivityAnswer(text);
    _activityProvider.notifyListenersAboutChange();
  }

  Future<void> _sendOrAskForReview() async {
    bool? isValid = _formKey.currentState?.validate();

    if (isValid != true) {
      return;
    }

    _formKey.currentState?.save();

    _setButtonStatus(WidgetStatusEnum.Loading);

    try {
      var activityResponseForReview = await _activityResponseApiClient.getForReview(context);

      if (activityResponseForReview == null) {
        await _showActivityForReviewNotFoundDialog();
      } else {
        await _showAskingForReviewDialog(activityResponseForReview);
      }

      _setButtonStatus(WidgetStatusEnum.Default);
    } catch (e) {
      _setButtonStatus(WidgetStatusEnum.Default);
    }
  }

  Future<void> _showAskingForReviewDialog(ActivityResponseForReview activityResponseForReview) async {
    Provider.of<ActivityResponseProvider>(context, listen: false).activityResponseForReview = activityResponseForReview;

    var response = await showDialog<bool>(
        context: context,
        builder: (BuildContext context) {
          return AskingForReviewDialog();
        });
    
    if (response == true) {
      _appNavigator.replaceCurrentUrl(ActivityForReview.screenUrl, context);
    }
  }

  Future<void> _showActivityForReviewNotFoundDialog() async {
    var shouldSendNow = await showDialog<bool>(
        context: context,
        builder: (BuildContext context) {
          return ActivityForReviewNotFoundDialog();
        });

    if (shouldSendNow == true) {
      await _sendActivityResponse();
      Provider.of<ActivityResponseProvider>(context, listen: false).isActivityResponseListOpenedFromBackButton = false;
      _appNavigator.replaceCurrentUrl(ActivityResponseListWidget.screenUrl, context);
    }
  }

  Future<void> _sendActivityResponse() async {
    var activityProvider = Provider.of<ActivityProvider>(context, listen: false);
    var currentActivity = activityProvider.getCurrentActivity();
    var activityType = currentActivity is QuestionActivity ? ActivityTypeEnum.Question : ActivityTypeEnum.Picture;
    var activityResponse = ActivityResponseForCreate(
      answer: activityProvider.getCurrentActivityAnswer(),
      activity: currentActivity as Activity,
      activityTypeId: activityType,
    );

    await _activityResponseApiClient.create(activityResponse, context);

    activityProvider.resetState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: widget._margin,
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            AppTextAreaWidget(
              value: _activityProvider.getCurrentActivityAnswer(),
              onChanged: _onAnswerFormChanged,
              margin: const EdgeInsets.only(bottom: 15),
              validator: _activityValidator.validateRequiredAndSwearing,
              onSaved: (val) => {},
              placeholder: 'Type your answer here...',
            ),
            RoundedButton(
              bgColor: const Color(AppColors.green),
              padding: const EdgeInsets.only(top: 10, bottom: 10, right: 30, left: 30),
              child: _buttonStatus == WidgetStatusEnum.Loading
                  ? AppSpinner()
                  : const Text(
                      'SEND ANSWER',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
              onPressed: _sendOrAskForReview,
              disabled: _buttonStatus == WidgetStatusEnum.Loading,
            ),
          ],
        ),
      ),
    );
  }
}
