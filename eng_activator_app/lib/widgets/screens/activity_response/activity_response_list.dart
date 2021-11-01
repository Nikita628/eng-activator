import 'package:eng_activator_app/models/activity_response/activity_response_preview.dart';
import 'package:eng_activator_app/models/activity_response/activity_response_search_param.dart';
import 'package:eng_activator_app/services/api_clients/activity_response_api_client.dart';
import 'package:eng_activator_app/shared/enums.dart';
import 'package:eng_activator_app/shared/services/injector.dart';
import 'package:eng_activator_app/shared/constants.dart';
import 'package:eng_activator_app/state/activity_response_provider.dart';
import 'package:eng_activator_app/widgets/activity_response/activity_response_list_item.dart';
import 'package:eng_activator_app/widgets/ui_elements/app_scaffold.dart';
import 'package:eng_activator_app/widgets/ui_elements/app_spinner.dart';
import 'package:eng_activator_app/widgets/ui_elements/overall_spinner.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ActivityResponseListWidget extends StatefulWidget {
  static const String screenUrl = '/activity-responses';
  final bool _isOpenedFromBackButton;

  ActivityResponseListWidget({required bool isOpenedFromBackButton})
      : _isOpenedFromBackButton = isOpenedFromBackButton,
        super();

  @override
  _ActivityResponseListWidgetState createState() => _ActivityResponseListWidgetState();
}

class _ActivityResponseListWidgetState extends State<ActivityResponseListWidget> {
  final ActivityResponseApiClient _activityResponseApiClient = Injector.get<ActivityResponseApiClient>();
  final ScrollController _scrollController = ScrollController();
  WidgetStatusEnum _overallStatus = WidgetStatusEnum.Loading;
  WidgetStatusEnum _pagingStatus = WidgetStatusEnum.Default;
  late ActivityResponseProvider _activityResponseProvider;

  @override
  void initState() {
    _scrollController.addListener(_scrollListener);
    _activityResponseProvider = Provider.of<ActivityResponseProvider>(context, listen: false);

    if (widget._isOpenedFromBackButton) {
      _overallStatus = WidgetStatusEnum.Result;
      WidgetsBinding.instance
          ?.addPostFrameCallback((_) => _scrollController.jumpTo(_activityResponseProvider.scrollPosition));
    } else {
      _activityResponseProvider.resetState();
      _searchActivityPreviews(_activityResponseProvider.currentSearchParam);
    }

    super.initState();
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _scrollListener() async {
    if (_pagingStatus == WidgetStatusEnum.Loading) {
      return;
    }
    
    _activityResponseProvider.scrollPosition = _scrollController.offset;
    var isScrolledToBottom = _scrollController.offset >= (_scrollController.position.maxScrollExtent - 30);

    if (isScrolledToBottom) {
      setState(() {
        _pagingStatus = WidgetStatusEnum.Loading;
      });

      _activityResponseProvider.currentSearchParam.lastUpdatedDateLessThan =
          _activityResponseProvider.previews.last.lastUpdatedDateUtc;

      try {
        var pageResponse =
            await _activityResponseApiClient.searchPreviews(_activityResponseProvider.currentSearchParam, context);

        if (mounted) {
          setState(() {
            _activityResponseProvider.previews.addAll(pageResponse.items);
            _pagingStatus = WidgetStatusEnum.Default;
          });
        }
      } catch (e) {
        if (mounted) {
          setState(() {
            _pagingStatus = WidgetStatusEnum.Default;
          });
        }
      }
    }
  }

  Future<void> _filterByDate() async {
    var dateFilter = await showDatePicker(
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
    );

    if (dateFilter != null) {
      setState(() {
        _activityResponseProvider.currentSearchParam.createdDateEquals = dateFilter;
        _activityResponseProvider.currentSearchParam.pageNumber = 1;
        _activityResponseProvider.currentSearchParam.pageSize = 10;
        _overallStatus = WidgetStatusEnum.Loading;
      });

      await _searchActivityPreviews(_activityResponseProvider.currentSearchParam);
    }
  }

  Future<void> _resetDateFilter() async {
    setState(() {
      _activityResponseProvider.currentSearchParam = ActivityResponseSearchParam();
      _overallStatus = WidgetStatusEnum.Loading;
    });

    await _searchActivityPreviews(_activityResponseProvider.currentSearchParam);
  }

  Future<void> _searchActivityPreviews(ActivityResponseSearchParam param) async {
    try {
      var pageResponse = await _activityResponseApiClient.searchPreviews(param, context);

      if (mounted) {
        setState(() {
          if (pageResponse.items.isEmpty) {
            _overallStatus = WidgetStatusEnum.EmptyResult;
          } else {
            _activityResponseProvider.previews.clear();
            _activityResponseProvider.previews.addAll(pageResponse.items);
            _overallStatus = WidgetStatusEnum.Result;
          }
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _overallStatus = WidgetStatusEnum.Error;
        });
      }
    }
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
                child: _DateFilter(
                  onFilterTap: _filterByDate,
                  onResetFilter: _resetDateFilter,
                  filter: _activityResponseProvider.currentSearchParam.createdDateEquals,
                )),
            Expanded(
                child: _ActivityPreviewList(
              overallStatus: _overallStatus,
              pagingStatus: _pagingStatus,
              scrollController: _scrollController,
              previews: _activityResponseProvider.previews,
            )),
          ],
        ),
      ),
    );
  }
}

class _ActivityPreviewList extends StatelessWidget {
  final ScrollController _scrollController;
  final WidgetStatusEnum _overallStatus;
  final WidgetStatusEnum _pagingStatus;
  final List<ActivityResponsePreview> _previews;

  _ActivityPreviewList({
    required WidgetStatusEnum overallStatus,
    required WidgetStatusEnum pagingStatus,
    required ScrollController scrollController,
    required List<ActivityResponsePreview> previews,
  })  : _overallStatus = overallStatus,
        _pagingStatus = pagingStatus,
        _scrollController = scrollController,
        _previews = previews,
        super();

  @override
  Widget build(BuildContext context) {
    Widget widget = SizedBox.shrink();

    if (_overallStatus == WidgetStatusEnum.Loading) {
      widget = OverallSpinner();
    } else if (_overallStatus == WidgetStatusEnum.EmptyResult) {
      widget = Center(child: Text("No items found"));
    } else if (_overallStatus == WidgetStatusEnum.Result) {
      widget = ListView(
        controller: _scrollController,
        children: [
          ..._previews.map((r) => ActivityResponseListItemWidget(response: r)).toList(),
          SizedBox(height: 60, child: _pagingStatus == WidgetStatusEnum.Loading ? Center(child: AppSpinner()) : null),
        ],
      );
    } else if (_overallStatus == WidgetStatusEnum.Error) {
      widget = Center(child: Text("Something went wrong"));
    }

    return widget;
  }
}

class _DateFilter extends StatelessWidget {
  final DateTime? _filter;
  final void Function() _onFilterTap;
  final void Function() _onResetFilter;

  _DateFilter({
    DateTime? filter,
    required void Function() onFilterTap,
    required void Function() onResetFilter,
  })  : _filter = filter,
        _onFilterTap = onFilterTap,
        _onResetFilter = onResetFilter,
        super();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        IconButton(
          onPressed: _onFilterTap,
          icon: Icon(
            Icons.calendar_today_outlined,
            color: Color(AppColors.green),
          ),
          iconSize: 35,
        ),
        _filter != null
            ? GestureDetector(
                onTap: _onFilterTap,
                child: Text(
                  DateFormat().addPattern('MMMM d, yyyy').format(_filter as DateTime),
                  style: TextStyle(color: Color(AppColors.black), fontSize: 14),
                ),
              )
            : SizedBox.shrink(),
        _filter != null
            ? IconButton(
                onPressed: _onResetFilter,
                icon: Icon(
                  Icons.close,
                  color: Color(AppColors.green),
                ),
                iconSize: 25,
              )
            : SizedBox.shrink(),
        _filter == null
            ? GestureDetector(
                onTap: _onFilterTap,
                child: Text(
                  "ALL TIME",
                  style: TextStyle(color: Color(AppColors.grey), fontSize: 14),
                ),
              )
            : SizedBox.shrink(),
      ],
    );
  }
}
