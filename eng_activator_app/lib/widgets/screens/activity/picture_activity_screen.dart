import 'package:eng_activator_app/models/activity/picture_activity.dart';
import 'package:eng_activator_app/shared/services/app_navigator.dart';
import 'package:eng_activator_app/shared/services/injector.dart';
import 'package:eng_activator_app/state/activity_provider.dart';
import 'package:eng_activator_app/widgets/activity/activity.dart';
import 'package:eng_activator_app/widgets/activity_picture_widget.dart';
import 'package:eng_activator_app/widgets/dialogs/first_picture_activity_dialog.dart';
import 'package:eng_activator_app/widgets/dialogs/losing_progress_warning_dialog.dart';
import 'package:eng_activator_app/widgets/screens/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _firstPictureActivityKey = "eng-activator-first-pic-activity";

class PictureActivityScreen extends StatefulWidget {
  static const screenUrl = "/picture-activity-screen";

  const PictureActivityScreen({Key? key}) : super(key: key);

  @override
  _PictureActivityScreenState createState() => _PictureActivityScreenState();
}

class _PictureActivityScreenState extends State<PictureActivityScreen> {
  final _appNavigator = Injector.get<AppNavigator>();
  late ActivityProvider _activityProvider;

  void _rebuildState() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();

    _activityProvider = Provider.of<ActivityProvider>(context, listen: false);

    if (_activityProvider.generateNewActivityOnInitialization) {
      _activityProvider.setRandomPictureActivity();
    }

    SharedPreferences.getInstance().then((value) {
      if (!value.containsKey(_firstPictureActivityKey)) {
        _showFirstActivityDialog();
      }
    }).catchError((e) {});
  }

  Future<void> _showFirstActivityDialog() async {
    await showDialog<int>(
        context: context,
        builder: (BuildContext context) {
          return FirstPictureActivityDialog();
        });

    var sharedPrefs = await SharedPreferences.getInstance();
    sharedPrefs.setBool(_firstPictureActivityKey, true);
  }

  void _onNextPictureActivity() {
    if (_activityProvider.getCurrentActivityAnswer().length > 0) {
      showDialog(
        context: context,
        builder: (_) => LosingProgressWarningDialog(),
      ).then(
        (value) {
          if (value == true) {
            _moveToNextPictureActivity();
          }
        },
      );
    } else {
      _moveToNextPictureActivity();
    }
  }

  void _moveToNextPictureActivity() {
    if (_activityProvider.activityHistory.canMoveForward()) {
      _activityProvider.activityHistory.moveForward();
    } else {
      _activityProvider.setRandomPictureActivity();
    }

    _activityProvider.setCurrentActivityAnswer('');
    _rebuildState();
  }

  void _onPreviousPictureActivity() {
    if (_activityProvider.getCurrentActivityAnswer().length > 0) {
      showDialog(
        context: context,
        builder: (_) => LosingProgressWarningDialog(),
      ).then(
        (value) {
          if (value == true) {
            _moveToPrevieousPictureActivity();
          }
        },
      );
    } else {
      _moveToPrevieousPictureActivity();
    }
  }

  void _moveToPrevieousPictureActivity() {
    if (_activityProvider.activityHistory.canMoveBack()) {
      _activityProvider.setCurrentActivityAnswer('');
      _activityProvider.activityHistory.moveBack();
      _rebuildState();
    }
  }

  @override
  Widget build(BuildContext context) {
    var activityProvider = Provider.of<ActivityProvider>(context, listen: false);
    var currentActivity = activityProvider.getCurrentActivity() as PictureActivity;

    Widget displayedWidget = ActivityWidget(
      activity: currentActivity,
      onBack: _onPreviousPictureActivity,
      isOnBackDisabled: !activityProvider.activityHistory.canMoveBack(),
      onForward: _onNextPictureActivity,
      child: ActivityPictureWidget(
        picUrl: currentActivity.picUrl,
        margin: const EdgeInsets.only(top: 10, bottom: 25),
      ),
    );

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
