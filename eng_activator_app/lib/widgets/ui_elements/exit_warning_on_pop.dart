import 'package:eng_activator_app/widgets/dialogs/exit_warning_dialog.dart';
import 'package:flutter/material.dart';

class ExitWarningOnPopWidget extends StatelessWidget {
  final Widget _child;

  const ExitWarningOnPopWidget({Key? key, required Widget child})
      : _child = child,
        super(key: key);

  Future<bool> _shouldExitApp(BuildContext context) async {
    var res = await showDialog<bool>(
        context: context,
        builder: (BuildContext context) {
          return ExitWarningDialog();
        });

    return res == true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: _child,
        onWillPop: () {
          return _shouldExitApp(context);
        });
  }
}
