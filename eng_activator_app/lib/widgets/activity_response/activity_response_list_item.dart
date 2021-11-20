import 'package:eng_activator_app/models/activity_response/activity_response_preview.dart';
import 'package:eng_activator_app/shared/enums.dart';
import 'package:eng_activator_app/shared/services/app_navigator.dart';
import 'package:eng_activator_app/shared/services/injector.dart';
import 'package:eng_activator_app/shared/constants.dart';
import 'package:eng_activator_app/state/activity_response_provider.dart';
import 'package:eng_activator_app/widgets/screens/activity_response/picture_activity_response.dart';
import 'package:eng_activator_app/widgets/screens/activity_response/question_activity_response.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ActivityResponseListItemWidget extends StatelessWidget {
  final AppNavigator _appNavigator = Injector.get<AppNavigator>();
  final ActivityResponsePreview _response;

  ActivityResponseListItemWidget({
    required ActivityResponsePreview response,
  }) : _response = response;

  Future<void> _navigateToDetails(BuildContext context) async {
    Provider.of<ActivityResponseProvider>(context, listen: false).activityResponseDetailsId = _response.id;

    if (_response.activityTypeId == ActivityTypeEnum.Question) {
      _appNavigator.replaceCurrentUrl(QuestionActivityResponseWidget.screenUrl, context);
    } else if (_response.activityTypeId == ActivityTypeEnum.Picture) {
      _appNavigator.replaceCurrentUrl(PictureActivityResponseWidget.screenUrl, context);
    }
  }

  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async => await _navigateToDetails(context),
      child: Card(
        elevation: 2,
        color: Color(AppColors.yellow),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        margin: const EdgeInsets.only(bottom: 10),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.only(left: 10, right: 15, top: 10, bottom: 10),
          child: Row(
            children: [
              Container(
                margin: const EdgeInsets.only(right: 10),
                child: Image.asset(
                  _response.activityTypeId == ActivityTypeEnum.Question
                      ? 'assets/images/main_quest.png'
                      : 'assets/images/main_img.png',
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
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            DateFormat().addPattern('MMMM d, ').add_Hm().format(_response.createdDate),
                            style: const TextStyle(
                              fontSize: 15,
                              color: Color(AppColors.black),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (_response.hasUnreadReviews)
                            const Icon(
                              Icons.message,
                              color: Color(AppColors.green),
                              size: 15,
                            ),
                        ],
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
