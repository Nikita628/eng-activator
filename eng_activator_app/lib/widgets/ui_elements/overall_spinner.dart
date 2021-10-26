import 'package:eng_activator_app/widgets/ui_elements/app_spinner.dart';
import 'package:flutter/material.dart';

class OverallSpinner extends StatelessWidget {
  const OverallSpinner({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color.fromARGB(200, 255, 255, 255),
      width: double.infinity,
      child: Center(
        child: AppSpinner(),
      ),
    );
  }
}
