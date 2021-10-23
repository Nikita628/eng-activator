import 'package:eng_activator_app/services/activity/activity_validator.dart';
import 'package:eng_activator_app/shared/services/app_navigator.dart';
import 'package:eng_activator_app/shared/services/injector.dart';
import 'package:eng_activator_app/shared/constants.dart';
import 'package:eng_activator_app/widgets/screens/activity/current_activity.dart';
import 'package:eng_activator_app/widgets/ui_elements/rounded_button.dart';
import 'package:eng_activator_app/widgets/ui_elements/text_area.dart';
import 'package:flutter/material.dart';

class ActivityReviewFormWidget extends StatefulWidget {
  final EdgeInsets? _margin;

  const ActivityReviewFormWidget({Key? key, EdgeInsets? margin})
      : _margin = margin,
        super(key: key);

  @override
  _ActivityReviewFormWidgetState createState() => _ActivityReviewFormWidgetState();
}

class _ActivityReviewFormWidgetState extends State<ActivityReviewFormWidget> {
  final AppNavigator _appNavigator = Injector.get<AppNavigator>();
  final _formKey = GlobalKey<FormState>();
  final ActivityValidator _activityValidator = ActivityValidator();
  late String? _review = '';
  late double _score = 0;

  void _sendReview() {
    bool? isValid = _formKey.currentState?.validate();

    if (isValid == true) {
      _formKey.currentState?.save();
      // send review to API
      // on success, show dialog, redirect back to user's activity
      // allow user to submit their own activity on review
      print(_review);
      _appNavigator.replaceCurrentUrl(CurrentActivityWidget.screenUrl, context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: widget._margin,
      padding: const EdgeInsets.only(right: 10, left: 10),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            SliderTheme(
              data: SliderThemeData(
                trackHeight: 8,
                activeTickMarkColor: Color(AppColors.grey),
                inactiveTickMarkColor: Color(AppColors.grey),
                tickMarkShape: SliderTickMarkShape.noTickMark,
              ),
              child: Slider(
                value: _score,
                min: 0,
                max: 5,
                divisions: 10,
                label: _score.toStringAsFixed(1),
                activeColor: Color(AppColors.green),
                inactiveColor: Color(AppColors.grey),
                onChanged: (double value) {
                  setState(() {
                    _score = value;
                  });
                },
              ),
            ),
            SizedBox(height: 20),
            AppTextAreaWidget(
              validator: _activityValidator.validateRequiredAndSwearing,
              onSaved: (val) => _review = val,
              placeholder: 'Type your review here...',
            ),
            SizedBox(height: 15),
            RoundedButton(
              bgColor: Color(AppColors.green),
              padding: const EdgeInsets.only(top: 10, bottom: 10, right: 30, left: 30),
              child: Text(
                'SEND REVIEW',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              onPressed: _sendReview,
            ),
          ],
        ),
      ),
    );
  }
}
