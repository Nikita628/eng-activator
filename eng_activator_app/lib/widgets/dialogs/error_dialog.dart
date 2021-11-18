import 'package:eng_activator_app/shared/constants.dart';
import 'package:flutter/material.dart';

class ErrorDialog extends StatelessWidget {
  final String _error;

  const ErrorDialog({required String error})
      : _error = error,
        super();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: SingleChildScrollView(child: Text(_error)),
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
