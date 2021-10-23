import 'package:eng_activator_app/shared/services/app_navigator.dart';
import 'package:eng_activator_app/shared/services/injector.dart';
import 'package:eng_activator_app/state/auth_provider.dart';
import 'package:eng_activator_app/widgets/screens/auth/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';

class AuthGuard extends StatelessWidget {
  final AppNavigator _appNavigator = Injector.get<AppNavigator>();
  final Widget _child;

  AuthGuard({required Widget child})
      : _child = child,
        super();

  @override
  Widget build(BuildContext context) {
    var authProvider = Provider.of<AuthProvider>(context);

    if (!authProvider.isUserAuthenticated()) {
      SchedulerBinding.instance?.addPostFrameCallback((timeStamp) {
        _appNavigator.replaceCurrentUrl(LoginScreenWidget.screenUrl, context);
      });
    }

    return _child;
  }
}
