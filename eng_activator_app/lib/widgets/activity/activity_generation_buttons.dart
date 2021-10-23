import 'package:eng_activator_app/shared/constants.dart';
import 'package:eng_activator_app/shared/enums.dart';
import 'package:eng_activator_app/widgets/ui_elements/rounded_button.dart';
import 'package:flutter/material.dart';

class ActivityGenerationButtons extends StatelessWidget {
  final Function(ActivityTypeEnum t)? _onPressed;
  final EdgeInsets? _margin;

  const ActivityGenerationButtons({Key? key, Function(ActivityTypeEnum t)? onPressed, EdgeInsets? margin})
      : _onPressed = onPressed,
        _margin = margin,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: _margin,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          RoundedButton(
            child: Image.asset(
              'assets/images/image.png',
              width: 50,
              height: 40,
              color: Colors.black38,
            ),
            onPressed: () {
              if (_onPressed != null) {
                (_onPressed as Function)(ActivityTypeEnum.Picture);
              }
            },
            bgColor: Color(AppColors.yellow),
          ),
          RoundedButton(
            child: Image.asset(
              'assets/images/quest.png',
              width: 50,
              height: 40,
              color: Colors.black38,
            ),
            onPressed: () {
              if (_onPressed != null) {
                (_onPressed as Function)(ActivityTypeEnum.Question);
              }
            },
            bgColor: Color(AppColors.yellow),
          )
        ],
      ),
    );
  }
}
