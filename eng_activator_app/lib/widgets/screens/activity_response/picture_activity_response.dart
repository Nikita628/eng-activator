import 'package:eng_activator_app/models/activity/picture_activity.dart';
import 'package:eng_activator_app/models/activity_response/activity_response_details.dart';
import 'package:eng_activator_app/services/api_clients/activity_response_api_client.dart';
import 'package:eng_activator_app/shared/enums.dart';
import 'package:eng_activator_app/shared/services/injector.dart';
import 'package:eng_activator_app/widgets/activity_picture_widget.dart';
import 'package:eng_activator_app/widgets/activity_response/activity_response_details.dart';
import 'package:eng_activator_app/widgets/ui_elements/empty_screen.dart';
import 'package:eng_activator_app/widgets/ui_elements/overall_spinner.dart';
import 'package:flutter/material.dart';

class PictureActivityResponseWidget extends StatefulWidget {
  static final String screenUrl = '/picture-activity-response';
  final int _pictureActivityResponseId;

  PictureActivityResponseWidget({required int pictureActivityResponseId})
      : _pictureActivityResponseId = pictureActivityResponseId,
        super();

  @override
  _PictureActivityResponseWidgetState createState() => _PictureActivityResponseWidgetState();
}

class _PictureActivityResponseWidgetState extends State<PictureActivityResponseWidget> {
  final _activityResponseApiClient = Injector.get<ActivityResponseApiClient>();
  late ActivityResponseDetails _response;
  late PictureActivity _activity;
  WidgetStatusEnum _widgetStatus = WidgetStatusEnum.Loading;

  @override
  void initState() {
    _activityResponseApiClient.getDetails(widget._pictureActivityResponseId, context).then((details) {
      if (mounted) {
        setState(() {
          _response = details;
          _widgetStatus = WidgetStatusEnum.Result;
          _activity = _response.activity as PictureActivity;
        });
      }
    }).catchError((e) {
      if (mounted) {
        setState(() {
          _widgetStatus = WidgetStatusEnum.Error;
        });
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget displayedWidget = EmptyScreenWidget();

    if (_widgetStatus == WidgetStatusEnum.Result) {
      displayedWidget = ActivityResponseDetailsWidget(
        activityResponse: _response,
        child: ActivityPictureWidget(
          picUrl: _activity.picUrl,
          margin: const EdgeInsets.only(bottom: 20, top: 20),
        ),
      );
    } else if (_widgetStatus == WidgetStatusEnum.Loading) {
      displayedWidget = EmptyScreenWidget(child: OverallSpinner());
    } else if (_widgetStatus == WidgetStatusEnum.Error) {
      displayedWidget = EmptyScreenWidget(
        child: Center(
          child: Text("Something went wrong"),
        ),
      );
    }

    return displayedWidget;
  }
}
