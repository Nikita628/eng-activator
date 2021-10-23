import 'package:eng_activator_app/shared/constants.dart';
import 'package:eng_activator_app/widgets/ui_elements/rounded_button.dart';
import 'package:flutter/material.dart';

class ActivityHintDialog extends StatelessWidget {
  const ActivityHintDialog({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      contentPadding: const EdgeInsets.only(left: 10, right: 10, bottom: 10, top: 10),
      title: Row(
        children: [
          const Icon(Icons.check_circle_outline_outlined, color: Color(AppColors.green), size: 40),
          const SizedBox(width: 10),
          const Text('Remember'),
        ],
      ),
      children: [
        const Text(
          """Min max length, try to use as many words as possible, tap on a word, be creative.""",
          style: TextStyle(fontSize: 20, color: Color(AppColors.black)),
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            RoundedButton(
              bgColor: Color(AppColors.green),
              child: const Text('OK', style: TextStyle(fontSize: 16)),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ],
    );
  }
}