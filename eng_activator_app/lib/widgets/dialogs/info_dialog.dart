import 'package:eng_activator_app/shared/constants.dart';
import 'package:flutter/material.dart';

class InfoDialog extends StatelessWidget {
  final String _info;

  const InfoDialog({required String info})
      : _info = info,
        super();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: SingleChildScrollView(child: Text(_info)),
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
