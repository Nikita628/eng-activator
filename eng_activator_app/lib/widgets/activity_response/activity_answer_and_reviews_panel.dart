import 'package:eng_activator_app/models/activity_response/activity_response_details.dart';
import 'package:eng_activator_app/models/activity_response_review/activity_response_review.dart';
import 'package:eng_activator_app/models/activity_response_review/activity_response_review_search_param.dart';
import 'package:eng_activator_app/services/api_clients/activity_response_review_api_client.dart';
import 'package:eng_activator_app/shared/enums.dart';
import 'package:eng_activator_app/shared/services/event_hub.dart';
import 'package:eng_activator_app/shared/services/injector.dart';
import 'package:eng_activator_app/shared/constants.dart';
import 'package:eng_activator_app/widgets/activity_response/activity_review.dart';
import 'package:eng_activator_app/widgets/ui_elements/overall_spinner.dart';
import 'package:eng_activator_app/widgets/ui_elements/score_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class ActivityAnswerAndReviewsPanel extends StatefulWidget {
  final ActivityResponseDetails _activityResponse;

  const ActivityAnswerAndReviewsPanel({Key? key, required ActivityResponseDetails activityResponse})
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
                ScoreBarWidget(score: widget._activityResponse.score),
                SizedBox(height: 25),
                _ReviewsBoxWidget(activityResponseId: widget._activityResponse.id),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _ReviewsBoxWidget extends StatefulWidget {
  final int _activityResponseId;

  _ReviewsBoxWidget({Key? key, required int activityResponseId})
      : _activityResponseId = activityResponseId,
        super(key: key);

  @override
  _ReviewsBoxWidgetState createState() => _ReviewsBoxWidgetState();
}

class _ReviewsBoxWidgetState extends State<_ReviewsBoxWidget> {
  final ScrollController _scrollController = ScrollController();
  final _activityResponseReviewApiClient = Injector.get<ActivityResponseReviewApiClient>();
  final EventHub _eventHub = Injector.get<EventHub>();
  late List<ActivityResponseReview> _reviews = [];
  WidgetStatusEnum _widgetStatus = WidgetStatusEnum.Loading;
  late ActivityResponseReviewSearchParam _currentSearchParam;
  bool _hasMoreItems = false;

  @override
  void initState() {
    _scrollController.addListener(_processScroll);

    _currentSearchParam = ActivityResponseReviewSearchParam(activityResponseId: widget._activityResponseId);
    _activityResponseReviewApiClient.search(_currentSearchParam, context).then((page) {
      if (mounted) {
        setState(() {
          _hasMoreItems = page.hasMoreItems;

          if (page.items.isNotEmpty) {
            _reviews.addAll(page.items);
            _widgetStatus = WidgetStatusEnum.Result;
          } else {
            _widgetStatus = WidgetStatusEnum.EmptyResult;
          }
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
  void dispose() {
    _scrollController.removeListener(_processScroll);
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _getReviews() async {
    setState(() {
      _widgetStatus = WidgetStatusEnum.Loading;
    });

    try {
      var page = await _activityResponseReviewApiClient.search(_currentSearchParam, context);

      if (mounted) {
        setState(() {
          _hasMoreItems = page.hasMoreItems;
          _reviews.addAll(page.items);
          _widgetStatus = WidgetStatusEnum.Result;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _widgetStatus = WidgetStatusEnum.Error;
        });
      }
    }
  }

  void _processScroll() {
    var isScrolledToBottom = _scrollController.offset >= _scrollController.position.maxScrollExtent;
    var isScrolledToTop =
        _scrollController.position.userScrollDirection == ScrollDirection.forward && _scrollController.offset == 0;

    if (isScrolledToTop) {
      _eventHub.notifyObservers(AppEvents.ScrollPageUp);
    } else if (isScrolledToBottom && _hasMoreItems) {
      _currentSearchParam.createdDateLessThan = _reviews.last.createdDate;
      _getReviews();
    } else if (isScrolledToBottom) {
      _eventHub.notifyObservers(AppEvents.ScrollPageDown);
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> stackChildren = [
      Scrollbar(
        thickness: 0,
        controller: _scrollController,
        child: ListView(
          children: [
            ..._reviews.map((r) => ActivityReviewWidget(review: r, margin: const EdgeInsets.only(bottom: 30))).toList(),
            SizedBox(height: 100),
          ],
          controller: _scrollController,
        ),
      )
    ];

    if (_widgetStatus == WidgetStatusEnum.Loading) {
      stackChildren.add(OverallSpinner());
    } else if (_widgetStatus == WidgetStatusEnum.Error) {
      stackChildren.add(Container(
        color: const Color.fromARGB(200, 255, 255, 255),
        width: double.infinity,
        child: const Center(child: Text("Something went wrong")),
      ));
    } else if (_widgetStatus == WidgetStatusEnum.EmptyResult) {
      stackChildren.add(Container(
        color: const Color.fromARGB(200, 255, 255, 255),
        width: double.infinity,
        child: const Center(child: Text("No items found")),
      ));
    }

    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: 400),
      child: Stack(
        children: stackChildren,
      ),
    );
  }
}
