import 'package:eng_activator_app/models/activity_response/activity_response.dart';
import 'package:eng_activator_app/shared/services/injector.dart';
import 'package:eng_activator_app/shared/services/mock_api.dart';
import 'package:eng_activator_app/shared/constants.dart';
import 'package:eng_activator_app/widgets/activity_response/activity_response_list_item.dart';
import 'package:eng_activator_app/widgets/ui_elements/app_scaffold.dart';
import 'package:eng_activator_app/widgets/ui_elements/app_spinner.dart';
import 'package:eng_activator_app/widgets/ui_elements/overall_spinner.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ActivityResponseListWidget extends StatefulWidget {
  static const String screenUrl = '/activity-responses';

  @override
  _ActivityResponseListWidgetState createState() => _ActivityResponseListWidgetState();
}

class _ActivityResponseListWidgetState extends State<ActivityResponseListWidget> {
  final MockApi _api = Injector.get<MockApi>();
  final ScrollController _scrollController = ScrollController();
  final List<ActivityResponse> _responses = [];
  bool _isOverallSpinner = true;
  bool _isPagingSpinner = false;
  DateTime? _dateFilter;

  @override
  void initState() {
    _scrollController.addListener(_processScroll);

    _api.getActivityResponses().then((value) {
      if (mounted) {
        setState(() {
          _isOverallSpinner = false;
          _responses.addAll(value);
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

  void _processScroll() {
    var isScrolledToBottom = _scrollController.offset >= (_scrollController.position.maxScrollExtent - 30);

    if (isScrolledToBottom) {
      setState(() {
        _isPagingSpinner = true;
      });

      _api.getActivityResponses().then((value) {
        if (mounted) {
          setState(() {
            _isPagingSpinner = false;
            _responses.addAll(value);
          });
        }
      });
    }
  }

  void _filterByDate() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2021),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Color(AppColors.green),
              onPrimary: Colors.black,
              onSurface: Color(AppColors.black),
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                primary: Color(AppColors.green),
              ),
            ),
          ),
          child: child!,
        );
      },
    ).then((value) {
      if (value != null) {
        setState(() {
          _dateFilter = value;
          _isOverallSpinner = true;
        });

        _api.getActivityResponses().then((value) {
          if (mounted) {
            setState(() {
              _isOverallSpinner = false;
              _responses.clear();
              _responses.addAll(value);
            });
          }
        });
      }
    });
  }

  void _resetDateFilter() {
    setState(() {
      _dateFilter = null;
      _isOverallSpinner = true;
    });

    _api.getActivityResponses().then((value) {
      if (mounted) {
        setState(() {
          _isOverallSpinner = false;
          _responses.clear();
          _responses.addAll(value);
        });
      }
    });
  }

  List<Widget> _buildDateFilter() {
    List<Widget> children = [
      IconButton(
        onPressed: _filterByDate,
        icon: Icon(
          Icons.calendar_today_outlined,
          color: Color(AppColors.green),
        ),
        iconSize: 35,
      ),
    ];

    if (_dateFilter != null) {
      children.add(GestureDetector(
        onTap: _filterByDate,
        child: Text(
          DateFormat().addPattern('MMMM d, yyyy').format(_dateFilter as DateTime),
          style: TextStyle(color: Color(AppColors.black), fontSize: 14),
        ),
      ));

      children.add(
        IconButton(
          onPressed: _resetDateFilter,
          icon: Icon(
            Icons.close,
            color: Color(AppColors.green),
          ),
          iconSize: 25,
        ),
      );
    } else {
      children.add(GestureDetector(
        onTap: _filterByDate,
        child: Text(
          "ALL TIME",
          style: TextStyle(color: Color(AppColors.grey), fontSize: 14),
        ),
      ));
    }

    return children;
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      isAppBarShown: true,
      child: Container(
        height: MediaQuery.of(context).size.height -
            AppConstants.preferredAppBarHeight -
            MediaQuery.of(context).padding.top,
        padding: const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(bottom: 10),
              child: Row(children: _buildDateFilter(), mainAxisAlignment: MainAxisAlignment.end),
            ),
            Expanded(
              child: _isOverallSpinner
                  ? OverallSpinner()
                  : ListView(
                      controller: _scrollController,
                      children: [
                        ..._responses.map((r) => ActivityResponseListItemWidget(response: r)).toList(),
                        SizedBox(height: 60, child: _isPagingSpinner ? Center(child: AppSpinner()) : null),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
