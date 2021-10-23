import 'package:eng_activator_app/models/activity/picture_activity.dart';
import 'package:eng_activator_app/models/activity_response/picture_activity_response.dart';
import 'package:eng_activator_app/shared/services/injector.dart';
import 'package:eng_activator_app/shared/services/mock_api.dart';
import 'package:eng_activator_app/widgets/activity_picture_widget.dart';
import 'package:eng_activator_app/widgets/activity_response/activity_response_details.dart';
import 'package:eng_activator_app/widgets/ui_elements/empty_screen.dart';
import 'package:flutter/material.dart';

class PictureActivityResponseWidget extends StatefulWidget {
  static final String screenUrl = '/picture-activity-response';

  const PictureActivityResponseWidget({Key? key}) : super(key: key);

  @override
  _PictureActivityResponseWidgetState createState() => _PictureActivityResponseWidgetState();
}

class _PictureActivityResponseWidgetState extends State<PictureActivityResponseWidget> {
  final MockApi _api = Injector.get<MockApi>();
  late PictureActivityResponse _response;
  late PictureActivity _activity;
  late bool _isSpinner = true;

  @override
  void initState() {
    if (mounted) {
      _api.getActivityResponses().then((value) {
        if (mounted) {
          setState(() {
            _isSpinner = false;
            _response = value[1] as PictureActivityResponse;
            _activity = _response.activity as PictureActivity;
          });
        }
      });
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _isSpinner
        ? EmptyScreenWidget(isSpinner: true)
        : ActivityResponseDetailsWidget(
            activityResponse: _response,
            child: ActivityPictureWidget(
              picUrl: _activity.picUrl,
              margin: const EdgeInsets.only(bottom: 20, top: 20),
            ),
          );
  }
}
