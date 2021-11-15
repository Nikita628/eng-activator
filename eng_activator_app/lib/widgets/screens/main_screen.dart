import 'package:eng_activator_app/services/activity/activity_service.dart';
import 'package:eng_activator_app/shared/services/injector.dart';
import 'package:eng_activator_app/shared/constants.dart';
import 'package:eng_activator_app/shared/enums.dart';
import 'package:eng_activator_app/widgets/ui_elements/app_scaffold.dart';
import 'package:eng_activator_app/widgets/ui_elements/exit_warning_on_pop.dart';
import 'package:eng_activator_app/widgets/ui_elements/rounded_button.dart';
import 'package:flutter/material.dart';

class MainScreenWidget extends StatefulWidget {
  static const String screenUrl = '/main-screen';

  @override
  State<StatefulWidget> createState() {
    return _MainScreenState();
  }
}

class _MainScreenState extends State {
  final ActivityService _activityService = Injector.get<ActivityService>();
  ActivityTypeEnum? _activityType;

  _MainScreenState();

  void _selectActivityType(ActivityTypeEnum activityType) {
    if (mounted) {
      setState(() {
        _activityType = activityType;
      });
    }
  }

  void _navigateToNewRandomActivity() {
    if (_activityType != null) {
      _activityService.navigateToNewRandomActivity(_activityType as ActivityTypeEnum, context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ExitWarningOnPopWidget(
      child: AppScaffold(
        isAppBarShown: true,
        child: Container(
          height: MediaQuery.of(context).size.height -
              AppConstants.preferredAppBarHeight -
              MediaQuery.of(context).padding.top,
          child: Column(
            children: [
              Image.asset(
                'assets/images/exenge.png',
                fit: BoxFit.contain,
                width: 200,
                height: 200,
              ),
              SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  GestureDetector(
                    child: Image.asset(
                      'assets/images/main_quest.png',
                      width: 90,
                      height: 90,
                      color: _activityType == ActivityTypeEnum.Question ? Color(AppColors.green) : Colors.grey[400],
                    ),
                    onTap: () => _selectActivityType(ActivityTypeEnum.Question),
                  ),
                  Container(
                    child: const Text(
                      'OR',
                      style: TextStyle(fontSize: 30, color: Color(AppColors.grey)),
                    ),
                  ),
                  GestureDetector(
                    child: Image.asset(
                      'assets/images/main_img.png',
                      width: 90,
                      height: 90,
                      color: _activityType == ActivityTypeEnum.Picture ? Color(AppColors.green) : Colors.grey[400],
                    ),
                    onTap: () => _selectActivityType(ActivityTypeEnum.Picture),
                  ),
                ],
              ),
              RoundedButton(
                child: const Text(
                  'LET\'S START',
                  style: TextStyle(fontSize: 25, color: Color(AppColors.grey)),
                ),
                bgColor: _activityType != null ? Color(AppColors.yellow) : Colors.grey[200],
                margin: const EdgeInsets.only(top: 60),
                onPressed: _navigateToNewRandomActivity,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
