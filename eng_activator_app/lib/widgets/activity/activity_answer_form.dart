import 'package:eng_activator_app/services/activity/activity_validator.dart';
import 'package:eng_activator_app/shared/services/injector.dart';
import 'package:eng_activator_app/shared/constants.dart';
import 'package:eng_activator_app/state/activity_provider.dart';
import 'package:eng_activator_app/widgets/dialogs/asking_for_review_dialog.dart';
import 'package:eng_activator_app/widgets/ui_elements/rounded_button.dart';
import 'package:eng_activator_app/widgets/ui_elements/text_area.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ActivityAnswerFormWidget extends StatefulWidget {
  final EdgeInsets? _margin;

  const ActivityAnswerFormWidget({Key? key, EdgeInsets? margin})
      : _margin = margin,
        super(key: key);

  @override
  _ActivityAnswerFormWidgetState createState() => _ActivityAnswerFormWidgetState();
}

class _ActivityAnswerFormWidgetState extends State<ActivityAnswerFormWidget> {
  final _formKey = GlobalKey<FormState>();
  final ActivityValidator _activityValidator = Injector.get<ActivityValidator>();
  String? _answer = '';

  void _onAnswerFormChanged(String text, ActivityProvider activityProvider) {
    activityProvider.setCurrentActivityAnswer(text);
  }

  void _sendOrAskForReview() {
    // if already reviewed someone's work, send
    // else show ask for review dialog
    bool? isValid = _formKey.currentState?.validate();

    if (isValid == true) {
      print(_answer);
      _formKey.currentState?.save();
      _showAskFoReviewDialog();
    }
  }

  Future<void> _showAskFoReviewDialog() async {
    await showDialog<int>(
        context: context,
        builder: (BuildContext context) {
          return AskingForReviewDialog();
        });
  }

  @override
  Widget build(BuildContext context) {
    var activityProvider = Provider.of<ActivityProvider>(context, listen: false);

    return Container(
      margin: widget._margin,
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            AppTextAreaWidget(
              value: activityProvider.getCurrentActivityAnswer(),
              onChanged: (text) => _onAnswerFormChanged(text, activityProvider),
              margin: const EdgeInsets.only(bottom: 15),
              validator: _activityValidator.validateRequiredAndSwearing,
              onSaved: (val) => _answer = val,
              placeholder: 'Type your answer here...',
            ),
            RoundedButton(
              bgColor: const Color(AppColors.green),
              padding: const EdgeInsets.only(top: 10, bottom: 10, right: 30, left: 30),
              child: const Text(
                'SEND ANSWER',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              onPressed: _sendOrAskForReview,
            ),
          ],
        ),
      ),
    );
  }
}
