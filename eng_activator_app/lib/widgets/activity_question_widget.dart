import 'package:eng_activator_app/shared/constants.dart';
import 'package:eng_activator_app/widgets/ui_elements/rounded_box.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ActivityQuestionWidget extends StatelessWidget {
  final String _questionText;
  final EdgeInsets? _margin;

  ActivityQuestionWidget({required String text, EdgeInsets? margin})
      : _questionText = text,
        _margin = margin;

  @override
  Widget build(BuildContext context) {
    return RoundedBox(
      bgColor: Color(AppColors.yellow),
      margin: _margin,
      padding: const EdgeInsets.only(top: 20, bottom: 20, left: 5, right: 5),
      child: Text(
        _questionText,
        style: TextStyle(
          fontSize: 25,
          color: Colors.grey[700],
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
