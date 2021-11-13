import 'package:eng_activator_app/services/activity/activity_service.dart';
import 'package:eng_activator_app/shared/services/app_navigator.dart';
import 'package:eng_activator_app/shared/services/injector.dart';
import 'package:eng_activator_app/shared/constants.dart';
import 'package:eng_activator_app/shared/enums.dart';
import 'package:eng_activator_app/state/activity_provider.dart';
import 'package:eng_activator_app/state/activity_response_provider.dart';
import 'package:eng_activator_app/state/auth_provider.dart';
import 'package:eng_activator_app/widgets/screens/activity_response/activity_response_list.dart';
import 'package:eng_activator_app/widgets/screens/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AppDrawer extends StatefulWidget {
  AppDrawer({Key? key}) : super(key: key);

  @override
  _AppDrawerState createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  final ActivityService _activityService = Injector.get<ActivityService>();

  final AppNavigator _appNavigator = Injector.get<AppNavigator>();

  void _navigateToCurrentActivity() {
    _activityService.navigateToCurrentActivity(context);
  }

  void _navigateToNewRandomQuestion() {
    _activityService.navigateToNewRandomActivity(ActivityTypeEnum.Question, context);
  }

  void _navigateToNewRandomPicture() {
    _activityService.navigateToNewRandomActivity(ActivityTypeEnum.Picture, context);
  }

  void _navigateToMainMenu() {
    _appNavigator.replaceCurrentUrl(MainScreenWidget.screenUrl, context);
  }

  void _navigateToActivityResponsesList() {
    Provider.of<ActivityResponseProvider>(context, listen: false).isActivityResponseListOpenedFromBackButton = false;
    _appNavigator.replaceCurrentUrl(ActivityResponseListWidget.screenUrl, context);
  }

  void _logout() {
    var authProvider = Provider.of<AuthProvider>(context, listen: false);
    authProvider.logout(context);
  }

  @override
  Widget build(BuildContext context) {
    var activityProvider = Provider.of<ActivityProvider>(context);
    var activity = activityProvider.getCurrentActivity();

    return Drawer(
      child: ListView(
        padding: EdgeInsets.only(top: 40),
        children: [
          ListTile(
            leading: const Icon(
              Icons.home,
              color: Color(AppColors.green),
              size: 30,
            ),
            title: const Text('Menu'),
            onTap: _navigateToMainMenu,
          ),
          ListTile(
            leading: const Icon(
              Icons.rate_review,
              color: Color(AppColors.green),
              size: 30,
            ),
            title: const Text('My Activities'),
            onTap: _navigateToActivityResponsesList,
          ),
          if (activity != null)
            ListTile(
              leading: const Icon(
                Icons.edit,
                color: Color(AppColors.green),
                size: 30,
              ),
              title: const Text('Opened Activity'),
              onTap: _navigateToCurrentActivity,
            ),
          ListTile(
            leading: const Icon(
              Icons.arrow_forward,
              color: Color(AppColors.green),
              size: 30,
            ),
            title: const Text('Next Picture'),
            onTap: _navigateToNewRandomPicture,
          ),
          ListTile(
            leading: const Icon(
              Icons.fast_forward_outlined,
              color: Color(AppColors.green),
              size: 30,
            ),
            title: const Text('Next Question'),
            onTap: _navigateToNewRandomQuestion,
          ),
          ListTile(
            leading: const Icon(
              Icons.exit_to_app,
              color: Color(AppColors.green),
              size: 30,
            ),
            title: const Text('Logout'),
            onTap: _logout,
          ),
        ],
      ),
    );
  }
}
