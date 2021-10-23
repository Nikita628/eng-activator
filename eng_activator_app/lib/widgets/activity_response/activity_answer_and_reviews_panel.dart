import 'package:eng_activator_app/models/activity_response/activity_response.dart';
import 'package:eng_activator_app/models/activity_response/activity_response_review.dart';
import 'package:eng_activator_app/shared/services/event_hub.dart';
import 'package:eng_activator_app/shared/services/injector.dart';
import 'package:eng_activator_app/shared/services/mock_api.dart';
import 'package:eng_activator_app/shared/constants.dart';
import 'package:eng_activator_app/widgets/activity_response/activity_review.dart';
import 'package:eng_activator_app/widgets/ui_elements/overall_spinner.dart';
import 'package:eng_activator_app/widgets/ui_elements/score_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class ActivityAnswerAndReviewsPanel extends StatefulWidget {
  final ActivityResponse _activityResponse;

  const ActivityAnswerAndReviewsPanel({Key? key, required ActivityResponse activityResponse})
      : _activityResponse = activityResponse,
        super(key: key);

  @override
  _ActivityAnswerAndReviewsPanelState createState() => _ActivityAnswerAndReviewsPanelState();
}

class _ActivityAnswerAndReviewsPanelState extends State<ActivityAnswerAndReviewsPanel> {
  late bool _isAnswerExpanded = false;
  late bool _isReviewsExpanded = false;

  Widget _answerPanelBuilder(BuildContext context, bool isExpanded) {
    return ListTile(
      title: Text(
        'Answer',
        style: TextStyle(
          color: Color(AppColors.green),
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _reviewsPanelBuilder(BuildContext context, bool isExpanded) {
    return ListTile(
      title: Text(
        'Reviews',
        style: TextStyle(
          color: Color(AppColors.green),
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  void _expansionCallback(int index, bool isExpanded) {
    setState(() {
      if (index == 0) {
        _isAnswerExpanded = !isExpanded;
      } else if (index == 1) {
        _isReviewsExpanded = !isExpanded;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ExpansionPanelList(
      elevation: 0,
      expandedHeaderPadding: EdgeInsets.only(top: 0, bottom: 0),
      animationDuration: Duration(milliseconds: 800),
      expansionCallback: _expansionCallback,
      dividerColor: Colors.white,
      children: [
        ExpansionPanel(
          canTapOnHeader: true,
          isExpanded: _isAnswerExpanded,
          headerBuilder: _answerPanelBuilder,
          body: Container(
            width: double.infinity,
            padding: const EdgeInsets.only(left: 5, right: 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Divider(thickness: 2, color: Color(AppColors.green)),
                Text(
                  widget._activityResponse.answer,
                  style: TextStyle(
                    color: Color(AppColors.black),
                    fontSize: 16,
                    height: 1.8,
                    wordSpacing: 0.7,
                  ),
                ),
              ],
            ),
          ),
        ),
        ExpansionPanel(
          canTapOnHeader: true,
          isExpanded: _isReviewsExpanded,
          headerBuilder: _reviewsPanelBuilder,
          body: Container(
            padding: const EdgeInsets.only(left: 5, right: 5),
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ScoreBarWidget(score: 3.988),
                SizedBox(height: 25),
                _ReviewsBoxWidget(),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _ReviewsBoxWidget extends StatefulWidget {
  const _ReviewsBoxWidget({Key? key}) : super(key: key);

  @override
  _ReviewsBoxWidgetState createState() => _ReviewsBoxWidgetState();
}

class _ReviewsBoxWidgetState extends State<_ReviewsBoxWidget> {
  final ScrollController _scrollController = ScrollController();
  final MockApi _api = Injector.get<MockApi>();
  final EventHub _eventHub = Injector.get<EventHub>();
  late List<ActivityResponseReview> _reviews = [];
  late bool _isSpinnerShown = true;

  @override
  void initState() {
    _scrollController.addListener(_processScroll);

    _api.getActivityReviews().then((value) {
      if (mounted) {
        setState(() {
          _isSpinnerShown = false;
          _reviews.addAll(value);
        });
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    _scrollController.removeListener(_processScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _getReviews() {
    setState(() {
      _isSpinnerShown = true;
    });

    _api.getActivityReviews().then((value) {
      if (mounted) {
        setState(() {
          _isSpinnerShown = false;
          _reviews.addAll(value);
        });
      }
    });
  }

  void _processScroll() {
    var isScrolledToBottom = _scrollController.offset >= _scrollController.position.maxScrollExtent;
    var isScrolledToTop =
        _scrollController.position.userScrollDirection == ScrollDirection.forward && _scrollController.offset == 0;

    if (isScrolledToTop) {
      _eventHub.notify('scrollPageUp');
    } else if (isScrolledToBottom) {
      _getReviews();
    }

    // TODO if scrolled to bottom and trying to scroll more, try to update the reviews
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: 400),
      child: Stack(
        children: [
          Scrollbar(
            thickness: 0,
            controller: _scrollController,
            child: ListView(
              // TODO: use list builder later
              children: [
                ..._reviews.map((r) => ActivityReviewWidget(review: r, margin: EdgeInsets.only(bottom: 30))).toList(),
                SizedBox(height: 100),
              ],
              controller: _scrollController,
            ),
          ),
          _isSpinnerShown ? OverallSpinner() : SizedBox.shrink(),
        ],
      ),
    );
  }
}
