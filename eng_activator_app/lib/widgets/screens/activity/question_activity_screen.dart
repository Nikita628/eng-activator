import 'package:eng_activator_app/models/activity/question_activity.dart';
import 'package:eng_activator_app/shared/enums.dart';
import 'package:eng_activator_app/shared/services/app_navigator.dart';
import 'package:eng_activator_app/shared/services/injector.dart';
import 'package:eng_activator_app/state/activity_provider.dart';
import 'package:eng_activator_app/widgets/activity/activity.dart';
import 'package:eng_activator_app/widgets/activity_question_widget.dart';
import 'package:eng_activator_app/widgets/dialogs/first_question_activity_dialog.dart';
import 'package:eng_activator_app/widgets/screens/main_screen.dart';
import 'package:eng_activator_app/widgets/ui_elements/empty_screen.dart';
import 'package:eng_activator_app/widgets/ui_elements/overall_spinner.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _firstQuestionActivityKey = "eng-activator-first-question-activity";

class QuestionActivityScreen extends StatefulWidget {
  static const screenUrl = "/question-activity-screen";

  const QuestionActivityScreen({Key? key}) : super(key: key);

  @override
  _QuestionActivityScreenState createState() => _QuestionActivityScreenState();
}

class _QuestionActivityScreenState extends State<QuestionActivityScreen> {
  final _appNavigator = Injector.get<AppNavigator>();
  var _widgetStatus = WidgetStatusEnum.Default;
  late ActivityProvider _activityProvider;

  void _setWidgetStatus(WidgetStatusEnum status) {
    if (mounted) {
      setState(() {
        _widgetStatus = status;
      });
    }
  }

  @override
  void initState() {
    super.initState();

    _activityProvider = Provider.of<ActivityProvider>(context, listen: false);

    if (_activityProvider.generateNewActivityOnInitialization) {
      _activityProvider.setRandomQuestionActivity();
    }

    SharedPreferences.getInstance().then((value) {
      if (!value.containsKey(_firstQuestionActivityKey)) {
        _showFirstActivityDialog();
      }
    }).catchError((e) {});
  }

  Future<void> _showFirstActivityDialog() async {
    await showDialog<int>(
        context: context,
        builder: (BuildContext context) {
          return FirstQuestionActivityDialog();
        });

    var sharedPrefs = await SharedPreferences.getInstance();
    sharedPrefs.setBool(_firstQuestionActivityKey, true);
  }

  Future<void> _onNextQuestionActivity() async {
    _setWidgetStatus(WidgetStatusEnum.Loading);

    if (_activityProvider.activityHistory.canMoveForward()) {
      _activityProvider.activityHistory.moveForward();
    } else {
      _activityProvider.setRandomQuestionActivity();
    }

    await Future.delayed(Duration(milliseconds: 500));
    _setWidgetStatus(WidgetStatusEnum.Default);
  }

  Future<void> _onPreviousQuestionActivity() async {
    if (_activityProvider.activityHistory.canMoveBack()) {
      _setWidgetStatus(WidgetStatusEnum.Loading);
      _activityProvider.activityHistory.moveBack();
      await Future.delayed(Duration(milliseconds: 500));
      _setWidgetStatus(WidgetStatusEnum.Default);
    }
  }

  @override
  Widget build(BuildContext context) {
    var activityProvider = Provider.of<ActivityProvider>(context);
    var currentActivity = activityProvider.getCurrentActivity() as QuestionActivity;

    Widget displayedWidget = EmptyScreenWidget();

    if (_widgetStatus == WidgetStatusEnum.Loading) {
      displayedWidget = EmptyScreenWidget(child: OverallSpinner());
    } else {
      displayedWidget = ActivityWidget(
        activity: currentActivity,
        onBack: _onPreviousQuestionActivity,
        onForward: _onNextQuestionActivity,
        isOnBackDisabled: !activityProvider.activityHistory.canMoveBack(),
        child: ActivityQuestionWidget(
          text: currentActivity.question,
          margin: const EdgeInsets.only(top: 10, bottom: 25),
        ),
      );
    }

    return WillPopScope(
      child: displayedWidget,
      onWillPop: () async {
        Future.delayed(Duration.zero).then((value) {
          _appNavigator.replaceCurrentUrl(MainScreenWidget.screenUrl, context);
        });

        return false;
      },
    );
  }
}
