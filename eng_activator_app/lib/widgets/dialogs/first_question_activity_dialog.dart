import 'package:eng_activator_app/shared/constants.dart';
import 'package:eng_activator_app/widgets/ui_elements/rounded_button.dart';
import 'package:flutter/material.dart';

class FirstQuestionActivityDialog extends StatelessWidget {
  const FirstQuestionActivityDialog({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      contentPadding: const EdgeInsets.only(left: 10, right: 10, bottom: 10, top: 10),
      title: Row(
        children: [
          const Icon(Icons.help, color: Color(AppColors.green), size: 20),
          const SizedBox(width: 10),
          Flexible(
            child: const Text(
              "You've created your first question activity!",
              style: TextStyle(fontSize: 18, color: Color(AppColors.black)),
            ),
          ),
        ],
      ),
      children: [
        const SizedBox(height: 15),
        const Text(
          "Here is what you have to do:",
          style: const TextStyle(fontSize: 14, color: Color(AppColors.black), fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        const Text(
          "Answer the given question in a creative way.",
          style: const TextStyle(fontSize: 14, color: Color(AppColors.black)),
        ),
        const SizedBox(height: 5),
        const Text(
          "Use as many words from the green box as possible.",
          style: const TextStyle(fontSize: 14, color: Color(AppColors.black)),
        ),
        const SizedBox(height: 5),
        const Text(
          "You can tap on each word to see its meaning.",
          style: const TextStyle(fontSize: 14, color: Color(AppColors.black)),
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            RoundedButton(
              bgColor: Color(AppColors.green),
              child: const Text('GOT IT !', style: TextStyle(fontSize: 16)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ],
    );
  }
}