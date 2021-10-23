import 'package:eng_activator_app/shared/constants.dart';
import 'package:flutter/material.dart';

class LosingProgressWarningDialog extends StatelessWidget {
  const LosingProgressWarningDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Are you sure?'),
      content: Text('Your progress in the current assignment will be lost.'),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: Text(
            'OK',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(AppColors.green),
            ),
          ),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(
            'CANCEL',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(AppColors.green),
            ),
          ),
        ),
      ],
    );
  }
}
