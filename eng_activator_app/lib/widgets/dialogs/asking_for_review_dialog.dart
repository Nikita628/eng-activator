import 'package:eng_activator_app/shared/constants.dart';
import 'package:eng_activator_app/shared/services/app_navigator.dart';
import 'package:eng_activator_app/shared/services/injector.dart';
import 'package:eng_activator_app/widgets/screens/activity/activity_for_review.dart';
import 'package:eng_activator_app/widgets/ui_elements/rounded_button.dart';
import 'package:flutter/material.dart';

class AskingForReviewDialog extends StatelessWidget {
  final AppNavigator _appNavigator = Injector.get<AppNavigator>();
  
  AskingForReviewDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      contentPadding: const EdgeInsets.only(left: 10, right: 10, bottom: 10, top: 10),
      title: const Icon(Icons.rate_review_outlined, color: Color(AppColors.green), size: 40),
      children: [
        Text(
          "To submit your work, you first have to review someone else\'s assignment.",
          style: const TextStyle(fontSize: 20, color: Color(AppColors.black)),
        ),
        SizedBox(height: 15),
        Text(
          'Do you want to review an assignment now?',
          style: const TextStyle(fontSize: 16, color: Color(AppColors.black)),
        ),
        SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            RoundedButton(
              bgColor: Color(AppColors.green),
              child: const Text('OK', style: TextStyle(fontSize: 16)),
              onPressed: () {
                _appNavigator.replaceCurrentUrl(ActivityForReview.screenUrl, context);
              },
            ),
            SizedBox(width: 10),
            RoundedButton(
              bgColor: Color(AppColors.grey),
              child: const Text('CANCEL', style: TextStyle(fontSize: 16)),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      ],
    );
  }
}
