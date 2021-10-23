import 'package:eng_activator_app/services/activity/activity_service.dart';
import 'package:eng_activator_app/shared/services/app_navigator.dart';
import 'package:eng_activator_app/shared/services/injector.dart';
import 'package:eng_activator_app/shared/constants.dart';
import 'package:eng_activator_app/shared/enums.dart';
import 'package:eng_activator_app/state/activity_provider.dart';
import 'package:eng_activator_app/state/auth_provider.dart';
import 'package:eng_activator_app/widgets/screens/activity/current_activity.dart';
import 'package:eng_activator_app/widgets/screens/activity_response/activity_response_list.dart';
import 'package:eng_activator_app/widgets/screens/help.dart';
import 'package:eng_activator_app/widgets/screens/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AppDrawer extends StatelessWidget {
  final ActivityService _activityService = Injector.get<ActivityService>();
  final AppNavigator _appNavigator = Injector.get<AppNavigator>();

  AppDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var authProvider = Provider.of<AuthProvider>(context, listen: false);
    var activityProvider = Provider.of<ActivityProvider>(context);
    var activity = activityProvider.getCurrentActivity();

    return Drawer(
      child: ListView(
        padding: EdgeInsets.only(top: 40),
        children: [
          ListTile(
            leading: Icon(
              Icons.home,
              color: Color(AppColors.green),
              size: 30,
            ),
            title: const Text('Home'),
            onTap: () => _appNavigator.replaceCurrentUrl(MainScreenWidget.screenUrl, context),
          ),
          ListTile(
            leading: Icon(
              Icons.rate_review,
              color: Color(AppColors.green),
              size: 30,
            ),
            title: Text('My Activities'),
            onTap: () => _appNavigator.replaceCurrentUrl(ActivityResponseListWidget.screenUrl, context),
          ),
          activity != null
              ? ListTile(
                  leading: Icon(
                    Icons.edit,
                    color: Color(AppColors.green),
                    size: 30,
                  ),
                  title: Text('Opened Activity'),
                  onTap: () => _appNavigator.replaceCurrentUrl(CurrentActivityWidget.screenUrl, context),
                )
              : const SizedBox.shrink(),
          ListTile(
            leading: Icon(
              Icons.arrow_forward,
              color: Color(AppColors.green),
              size: 30,
            ),
            title: Text('Next Picture'),
            onTap: () => _activityService.navigateToNewRandomActivity(ActivityTypeEnum.Picture, context),
          ),
          ListTile(
            leading: Icon(
              Icons.fast_forward_outlined,
              color: Color(AppColors.green),
              size: 30,
            ),
            title: Text('Next Question'),
            onTap: () => _activityService.navigateToNewRandomActivity(ActivityTypeEnum.Question, context),
          ),
          ListTile(
            leading: Icon(
              Icons.help_outline,
              color: Color(AppColors.green),
              size: 30,
            ),
            title: Text('Help'),
            onTap: () => _appNavigator.replaceCurrentUrl(AppHelpWidget.screenUrl, context),
          ),
          ListTile(
            leading: Icon(
              Icons.exit_to_app,
              color: Color(AppColors.green),
              size: 30,
            ),
            title: Text('Logout'),
            onTap: () {
              authProvider.removeAuthData();
            }
          ),
        ],
      ),
    );
  }
}
