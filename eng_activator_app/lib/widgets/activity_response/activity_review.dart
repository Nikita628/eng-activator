import 'package:eng_activator_app/models/activity_response_review/activity_response_review.dart';
import 'package:eng_activator_app/services/api_clients/activity_response_review_api_client.dart';
import 'package:eng_activator_app/shared/constants.dart';
import 'package:eng_activator_app/shared/services/injector.dart';
import 'package:eng_activator_app/state/activity_response_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ActivityReviewWidget extends StatefulWidget {
  final ActivityResponseReview _review;
  final EdgeInsets? _margin;

  const ActivityReviewWidget({Key? key, required ActivityResponseReview review, EdgeInsets? margin})
      : _review = review,
        _margin = margin,
        super(key: key);

  @override
  _ActivityReviewWidgetState createState() => _ActivityReviewWidgetState();
}

class _ActivityReviewWidgetState extends State<ActivityReviewWidget> {
  final ActivityResponseReviewApiClient _activityResponseReviewApiClient =
      Injector.get<ActivityResponseReviewApiClient>();
  late ActivityResponseProvider _activityResponseProvider;

  @override
  void initState() {
    _activityResponseProvider = Provider.of<ActivityResponseProvider>(context, listen: false);
    super.initState();
  }

  void _setIsViewed() {
    if (mounted) {
      setState(() {
        widget._review.isViewed = true;
      });
    }
  }

  Future<void> _markAsViewed() async {
    if (widget._review.isViewed) {
      return;
    }

    try {
      _setIsViewed();

      var response = await _activityResponseReviewApiClient.markViewed(widget._review.id, context);

      if (!response.activityResponseHasUnreadReviews) {
        var preview = _activityResponseProvider.previews
            .singleWhere((element) => element.id == widget._review.activityResponseId);

        preview.hasUnreadReviews = false;
      }
    } catch (e) {
      _setIsViewed();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: widget._margin,
      child: ListTile(
        contentPadding: EdgeInsets.only(left: 0, right: 0),
        title: Container(
          margin: EdgeInsets.only(bottom: 5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${DateFormat().addPattern('MMMM d, ').add_Hm().format(widget._review.createdDate)}, score ${widget._review.score}",
                style: TextStyle(
                  color: Color(AppColors.black),
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "By ${widget._review.createdBy.name}, Review ID: ${widget._review.id}",
                style: const TextStyle(
                  color: Color(AppColors.grey),
                  fontSize: 14,
                  fontStyle: FontStyle.italic,
                ),
              ),
              Divider(
                height: 10,
                thickness: 1,
                color: Colors.grey[300],
                endIndent: 100,
              ),
            ],
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget._review.text,
              style: const TextStyle(
                color: Color(AppColors.black),
                fontSize: 16,
                height: 1.8,
                wordSpacing: 0.7,
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  onPressed: _markAsViewed,
                  icon: Icon(
                    widget._review.isViewed ? Icons.remove_red_eye : Icons.remove_red_eye_outlined,
                    color: Color(widget._review.isViewed ? AppColors.grey : AppColors.green),
                  ),
                ),
                Text(widget._review.isViewed ? "Read" : "Not Read"),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
