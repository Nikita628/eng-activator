import 'package:eng_activator_app/widgets/ui_elements/app_scaffold.dart';
import 'package:flutter/material.dart';

class AppTour extends StatelessWidget {
  static const screenUrl = '/app-tour';

  const AppTour({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      child: Container(
        height: MediaQuery.of(context).size.height - 80,
        child: Center(
          child: Text('App Tour', style: TextStyle(fontSize: 30)),
        ),
      ),
    );
  }
}
