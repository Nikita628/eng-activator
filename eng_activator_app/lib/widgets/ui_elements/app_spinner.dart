import 'package:eng_activator_app/shared/constants.dart';
import 'package:flutter/material.dart';

class AppSpinner extends StatelessWidget {
  const AppSpinner({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxHeight: 40, maxWidth: 40),
      child: const CircularProgressIndicator(
        strokeWidth: 5,
        color: Color(AppColors.green),
      ),
    );
  }
}
