import 'package:eng_activator_app/models/activity_response/activity_response.dart';
import 'package:eng_activator_app/models/activity_response/picture_activity_response.dart';
import 'package:eng_activator_app/models/activity_response/question_activity_response.dart';
import 'package:eng_activator_app/shared/services/app_navigator.dart';
import 'package:eng_activator_app/shared/services/injector.dart';
import 'package:eng_activator_app/shared/constants.dart';
import 'package:eng_activator_app/widgets/screens/activity_response/picture_activity_response.dart';
import 'package:eng_activator_app/widgets/screens/activity_response/question_activity_response.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ActivityResponseListItemWidget extends StatelessWidget {
  final AppNavigator _appNavigator = Injector.get<AppNavigator>();
  final ActivityResponse _response;

  ActivityResponseListItemWidget({
    required ActivityResponse response,
  }) : _response = response;

  void _navigateToDetails(BuildContext context) {

    if (_response is QuestionActivityResponse) {
      _appNavigator.pushOnTopCurrentUrl(QuestionActivityResponseWidget.screenUrl, context);
    } else if (_response is PictureActivityResponse) {
      _appNavigator.pushOnTopCurrentUrl(PictureActivityResponseWidget.screenUrl, context);
    }
  }

  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _navigateToDetails(context),
      child: Card(
        elevation: 2,
        color: Color(AppColors.yellow),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        margin: EdgeInsets.only(bottom: 10),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.only(left: 10, right: 15, top: 10, bottom: 10),
          child: Row(
            children: [
              Container(
                margin: const EdgeInsets.only(right: 15),
                child: Image.asset(
                  _response is QuestionActivityResponse ? 'assets/images/main_quest.png' : 'assets/images/main_img.png',
                  width: 60,
                  height: 60,
                  color: Color(AppColors.green),
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      child: Text(
                        DateFormat().addPattern('MMMM d, ').add_Hm().format(_response.createdDate),
                        style: const TextStyle(
                          fontSize: 15,
                          color: Color(AppColors.black),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      child: Text(
                        _response.answer,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black54,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
