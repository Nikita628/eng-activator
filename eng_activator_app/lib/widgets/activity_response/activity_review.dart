import 'package:eng_activator_app/models/activity_response/activity_response_review.dart';
import 'package:eng_activator_app/shared/constants.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ActivityReviewWidget extends StatelessWidget {
  final ActivityResponseReview _review;
  final EdgeInsets? _margin;

  const ActivityReviewWidget({Key? key, required ActivityResponseReview review, EdgeInsets? margin})
      : _review = review,
        _margin = margin,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: _margin,
      child: ListTile(
        contentPadding: EdgeInsets.only(left: 0, right: 0),
        title: Container(
          margin: EdgeInsets.only(bottom: 5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${DateFormat().addPattern('MMMM d, ').add_Hm().format(_review.createdDate)}, score ${_review.score}",
                style: TextStyle(
                  color: Color(AppColors.black),
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "By ${_review.createdBy.name}",
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
        subtitle: Text(
          _review.text,
          style: const TextStyle(
            color: Color(AppColors.black),
            fontSize: 16,
            height: 1.8,
            wordSpacing: 0.7,
          ),
        ),
      ),
    );
  }
}
