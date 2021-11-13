import 'package:eng_activator_app/shared/constants.dart';
import 'package:eng_activator_app/widgets/ui_elements/rounded_button.dart';
import 'package:flutter/material.dart';

class ActivityGenerationButtons extends StatelessWidget {
  final Function()? _onForward;
  final Function()? _onBack;
  final bool _isOnBackDisabled;
  final EdgeInsets? _margin;

  const ActivityGenerationButtons({
    Key? key,
    Function()? onForward,
    Function()? onBack,
    EdgeInsets? margin,
    bool isOnBackDisabled = false,
  })  : _onForward = onForward,
        _onBack = onBack,
        _margin = margin,
        _isOnBackDisabled = isOnBackDisabled,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: _margin,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          RoundedButton(
            child: const Icon(Icons.settings_backup_restore_rounded, size: 35, color: Color(AppColors.green)),
            onPressed: _onBack,
            bgColor: Color(AppColors.yellow),
            disabled: _isOnBackDisabled,
          ),
          RoundedButton(
            child: const Icon(Icons.forward_outlined, size: 35, color: Color(AppColors.green)),
            onPressed: _onForward,
            bgColor: Color(AppColors.yellow),
          )
        ],
      ),
    );
  }
}
