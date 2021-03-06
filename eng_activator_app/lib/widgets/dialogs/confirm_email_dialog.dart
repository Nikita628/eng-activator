import 'package:eng_activator_app/shared/constants.dart';
import 'package:flutter/material.dart';

class ConfirmEmailDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Text(
          "We've sent an email to provided address. Please follow the instructions from the email to complete your registration. If you didn't receive the email, check your spam folder."),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text(
            'OK',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(AppColors.green),
            ),
          ),
        ),
      ],
    );
  }
}
