import 'package:eng_activator_app/shared/constants.dart';
import 'package:eng_activator_app/widgets/ui_elements/app_scaffold.dart';
import 'package:flutter/material.dart';

class EmptyScreenWidget extends StatelessWidget {
  final Widget? _child;
  final bool _isAppBarShown;

  const EmptyScreenWidget({Key? key, Widget? child, bool isAppBarShown = true})
      : _child = child,
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
        child: _child,
      ),
    );
  }
}
