import 'package:eng_activator_app/widgets/ui_elements/app_scaffold.dart';
import 'package:flutter/material.dart';

class AppHelpWidget extends StatelessWidget {
  static const screenUrl = '/app-help';

  const AppHelpWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      isAppBarShown: true,
      child: Container(
        height: MediaQuery.of(context).size.height - 80,
        child: Center(
          child: Text('Help', style: TextStyle(fontSize: 30)),
        ),
      ),
    );
  }
}
