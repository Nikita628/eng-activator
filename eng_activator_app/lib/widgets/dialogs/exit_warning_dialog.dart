import 'package:eng_activator_app/shared/constants.dart';
import 'package:eng_activator_app/state/activity_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ExitWarningDialog extends StatelessWidget {
  const ExitWarningDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<ActivityProvider>(context);
    var hasProgress = provider.currentActivityAnswer.get().isNotEmpty;

    return AlertDialog(
      title: Text('Do you want to exit Exenge?'),
      content: Text('Exenge will be closed.${hasProgress ? ' Your progress in the current assignment will be lost.' : ''}'),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: Text(
            'EXIT',
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
