import 'package:eng_activator_app/shared/constants.dart';
import 'package:eng_activator_app/widgets/ui_elements/app_scaffold.dart';
import 'package:eng_activator_app/widgets/ui_elements/overall_spinner.dart';
import 'package:flutter/material.dart';

class EmptyScreenWidget extends StatelessWidget {
  final bool _isSpinner;
  final bool _isAppBarShown;

  const EmptyScreenWidget({Key? key, bool isSpinner = false, bool isAppBarShown = true})
      : _isSpinner = isSpinner,
        _isAppBarShown = isAppBarShown,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      isAppBarShown: _isAppBarShown,
      child: Container(
        height: MediaQuery.of(context).size.height -
            AppConstants.preferredAppBarHeight -
            MediaQuery.of(context).padding.top,
        child: _isSpinner ? Center(child: OverallSpinner()) : SizedBox.shrink(),
      ),
    );
  }
}
