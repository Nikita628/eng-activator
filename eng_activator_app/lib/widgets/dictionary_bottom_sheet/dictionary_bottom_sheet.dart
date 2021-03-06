import 'package:eng_activator_app/models/dictionary/dictionary_response.dart';
import 'package:eng_activator_app/models/dictionary/dictionary_search_param.dart';
import 'package:eng_activator_app/services/api_clients/dictionary_api_client.dart';
import 'package:eng_activator_app/shared/enums.dart';
import 'package:eng_activator_app/shared/services/injector.dart';
import 'package:eng_activator_app/shared/constants.dart';
import 'package:eng_activator_app/widgets/dictionary_bottom_sheet/dictionary_search_result.dart';
import 'package:eng_activator_app/widgets/dictionary_bottom_sheet/dictionary_search_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class DictionaryBottomSheet extends StatefulWidget {
  const DictionaryBottomSheet({Key? key}) : super(key: key);

  @override
  _DictionaryBottomSheetState createState() => _DictionaryBottomSheetState();
}

class _DictionaryBottomSheetState extends State<DictionaryBottomSheet> {
  final _scrollController = ScrollController();
  final _dictionaryApiClient = Injector.get<DictionaryApiClient>();

  var _dictionaryResponse = DictionaryResponse(dictionaryEntries: [], recommendations: []);
  var _widgetStatus = WidgetStatusEnum.Empty;

  void _setWidgetStatus(WidgetStatusEnum status) {
    if (mounted) {
      setState(() {
        _widgetStatus = status;
      });
    }
  }

  void _searchDictionary(String searchTerm) async {
    if (searchTerm.isEmpty) {
      return;
    }

    _setWidgetStatus(WidgetStatusEnum.Loading);

    try {
      var dictionaryResponse = await _dictionaryApiClient.search(DictionarySearchParam(searchTerm), context);
      var status = WidgetStatusEnum.Result;

      if (dictionaryResponse.dictionaryEntries.isEmpty && dictionaryResponse.recommendations.isEmpty) {
        status = WidgetStatusEnum.EmptyResult;
      }

      if (mounted) {
        setState(() {
          _dictionaryResponse = dictionaryResponse;
          _widgetStatus = status;
        });
      }

      _updateScrollPosition();
    } catch (e) {
      _setWidgetStatus(WidgetStatusEnum.Error);
    }
  }

  void _updateScrollPosition() {
    SchedulerBinding.instance?.addPostFrameCallback((timeStamp) {
      if (_scrollController.hasClients && _scrollController.position.maxScrollExtent > 0) {
        _scrollController.jumpTo(0.01);
      }
    });
  }

  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxHeight: 300),
      width: double.infinity,
      decoration: const BoxDecoration(color: Colors.white, boxShadow: [
        BoxShadow(color: Color(AppColors.grey), blurRadius: 2, spreadRadius: 1),
      ]),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            onPressed: () {},
            padding: EdgeInsets.all(0),
            visualDensity: VisualDensity.compact,
            icon: Icon(
              Icons.arrow_drop_down,
              size: 30,
              color: Color(AppColors.black),
            ),
          ),
          Container(
            child: DictionarySearchTextField(onSearchIconClick: _searchDictionary),
            margin: EdgeInsets.only(bottom: 10, right: 5, left: 5),
          ),
          _widgetStatus != WidgetStatusEnum.Empty
              ? Flexible(
                  child: Scrollbar(
                    controller: _scrollController,
                    isAlwaysShown: true,
                    child: ListView(
                      controller: _scrollController,
                      shrinkWrap: true,
                      physics: const ScrollPhysics(),
                      padding: const EdgeInsets.only(bottom: 15, left: 10, right: 10),
                      children: [
                        DictionarySearchResult(
                          dictionaryResponse: _dictionaryResponse,
                          widgetStatus: _widgetStatus,
                        ),
                      ],
                    ),
                  ),
                )
              : SizedBox.shrink(),
        ],
      ),
    );
  }
}
