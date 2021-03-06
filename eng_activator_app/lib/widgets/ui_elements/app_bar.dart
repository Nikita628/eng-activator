import 'package:eng_activator_app/services/activity/activity_service.dart';
import 'package:eng_activator_app/shared/services/app_navigator.dart';
import 'package:eng_activator_app/shared/services/injector.dart';
import 'package:eng_activator_app/shared/constants.dart';
import 'package:eng_activator_app/state/activity_provider.dart';
import 'package:eng_activator_app/shared/state/current_url_provider.dart';
import 'package:eng_activator_app/state/activity_response_provider.dart';
import 'package:eng_activator_app/widgets/dictionary_bottom_sheet/dictionary_bottom_sheet.dart';
import 'package:eng_activator_app/widgets/screens/activity_response/activity_response_list.dart';
import 'package:eng_activator_app/widgets/screens/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AppBarWidget extends StatefulWidget implements PreferredSizeWidget {
  AppBarWidget({Key? key}) : super(key: key);

  @override
  _AppBarWidgetState createState() => _AppBarWidgetState();

  @override
  Size get preferredSize => Size.fromHeight(AppConstants.preferredAppBarHeight);
}

class _AppBarWidgetState extends State<AppBarWidget> {
  final _appNavigator = Injector.get<AppNavigator>();
  final _activityService = Injector.get<ActivityService>();

  PersistentBottomSheetController? _bottomSheetController;

  void _toggleDictionaryBottomSheet() {
    if (_bottomSheetController != null) {
      _bottomSheetController?.close();
      _bottomSheetController = null;
    } else {
      _bottomSheetController = Scaffold.of(context).showBottomSheet<void>((_) => DictionaryBottomSheet());
      _bottomSheetController?.closed.then((value) {
        _bottomSheetController = null;
      });
    }
  }

  void _navigateToCurrentActivity() {
    _activityService.navigateToCurrentActivity(context);
  }

  void _navigateBack() {
    var currentUrlProvider = Provider.of<CurrentUrlProvider>(context, listen: false);

    if (currentUrlProvider.isOnActivityResponseScreen()) {
      Provider.of<ActivityResponseProvider>(context, listen: false).isActivityResponseListOpenedFromBackButton = true;
      _appNavigator.replaceCurrentUrl(ActivityResponseListWidget.screenUrl, context);
    } else if (currentUrlProvider.isOnActivityScreen()) {
      _appNavigator.replaceCurrentUrl(MainScreenWidget.screenUrl, context);
    }
  }

  void _openDrawer() {
    Scaffold.of(context).openEndDrawer();
  }

  @override
  Widget build(BuildContext context) {
    var activityProvider = Provider.of<ActivityProvider>(context);
    var currentUrlProvider = Provider.of<CurrentUrlProvider>(context);
    var activity = activityProvider.getCurrentActivity();
    var isBackButtonShown = currentUrlProvider.isBackButtonShown();
    var isDictionaryButtonShown = currentUrlProvider.isDictionaryButtonShown();
    var isCurrentActivityButtonShown = currentUrlProvider.isCurrentActivityButtonShown();

    return AppBar(
      leading: IconButton(
        icon: const Icon(
          Icons.menu,
          color: Color(AppColors.green),
          size: 30,
        ),
        onPressed: _openDrawer,
      ),
      elevation: 3,
      backgroundColor: const Color(0xffffffff),
      shadowColor: const Color(AppColors.green),
      actions: [
        if (isBackButtonShown)
          IconButton(
            icon: const Icon(
              Icons.keyboard_backspace,
              color: Color(AppColors.green),
              size: 30,
            ),
            onPressed: _navigateBack,
          ),
        if (isDictionaryButtonShown)
          IconButton(
            icon: const Icon(
              Icons.menu_book_sharp,
              color: Color(AppColors.green),
              size: 30,
            ),
            onPressed: _toggleDictionaryBottomSheet,
          ),
        if (activity != null && isCurrentActivityButtonShown)
          IconButton(
            icon: const Icon(
              Icons.edit_outlined,
              color: Color(AppColors.green),
              size: 30,
            ),
            onPressed: _navigateToCurrentActivity,
          )
      ],
    );
  }
}
