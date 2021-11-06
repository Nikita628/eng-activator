import 'package:eng_activator_app/shared/constants.dart';
import 'package:eng_activator_app/widgets/ui_elements/rounded_button.dart';
import 'package:flutter/material.dart';

class ActivityForReviewNotFoundDialog extends StatelessWidget {  
  ActivityForReviewNotFoundDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      contentPadding: const EdgeInsets.only(left: 10, right: 10, bottom: 10, top: 10),
      title: const Icon(Icons.rate_review_outlined, color: Color(AppColors.green), size: 40),
      children: [
        Text(
          "There is no activities to review at the moment. You can send your activity.",
          style: const TextStyle(fontSize: 20, color: Color(AppColors.black)),
        ),
        SizedBox(height: 15),
        Text(
          'Do you want to send your activity?',
          style: const TextStyle(fontSize: 16, color: Color(AppColors.black)),
        ),
        SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            RoundedButton(
              bgColor: Color(AppColors.green),
              child: const Text('OK', style: TextStyle(fontSize: 16)),
              onPressed: () => Navigator.pop(context, true),
            ),
            SizedBox(width: 10),
            RoundedButton(
              bgColor: Color(AppColors.grey),
              child: const Text('CANCEL', style: TextStyle(fontSize: 16)),
              onPressed: () => Navigator.pop(context, false),
            ),
          ],
        ),
      ],
    );
  }
}
