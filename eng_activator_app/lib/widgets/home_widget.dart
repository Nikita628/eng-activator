import 'package:eng_activator_app/state/auth_provider.dart';
import 'package:eng_activator_app/widgets/screens/auth/login.dart';
import 'package:eng_activator_app/widgets/screens/main_screen.dart';
import 'package:eng_activator_app/widgets/ui_elements/auth_provider_consumer.dart';
import 'package:eng_activator_app/widgets/ui_elements/empty_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeWidget extends StatelessWidget {
  const HomeWidget() : super();

  @override
  Widget build(BuildContext context) {
    var authProvider = Provider.of<AuthProvider>(context, listen: false);

    return FutureBuilder(
      future: authProvider.tryAutoLogin(),
      builder: (ctx, futureResultSnapshot) {
        if (futureResultSnapshot.connectionState == ConnectionState.waiting) {
          return EmptyScreenWidget(isSpinner: true, isAppBarShown: false);
        } else if (futureResultSnapshot.data == true) {
          return AuthGuard(child: MainScreenWidget());
        } else {
          return LoginScreenWidget();
        }
      },
    );
  }
}
