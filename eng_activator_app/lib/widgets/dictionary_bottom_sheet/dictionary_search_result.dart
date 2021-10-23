import 'package:eng_activator_app/models/dictionary/dictionary_response.dart';
import 'package:eng_activator_app/shared/enums.dart';
import 'package:eng_activator_app/widgets/dictionary_bottom_sheet/dictionary_entry_widget.dart';
import 'package:eng_activator_app/widgets/dictionary_bottom_sheet/dictionary_recommendations.dart';
import 'package:eng_activator_app/widgets/ui_elements/app_spinner.dart';
import 'package:flutter/material.dart';

class DictionarySearchResult extends StatelessWidget {
  final DictionaryResponse _dictionaryResponse;
  final WidgetStatusEnum _widgetStatus;

  const DictionarySearchResult({
    required DictionaryResponse dictionaryResponse,
    required WidgetStatusEnum widgetStatus,
  })  : _dictionaryResponse = dictionaryResponse,
        _widgetStatus = widgetStatus,
        super();

  @override
  Widget build(BuildContext context) {
    Widget widgetForDisplaying = SizedBox.shrink();

    if (_widgetStatus == WidgetStatusEnum.Loading) {
      widgetForDisplaying = Container(
        child: Center(child: AppSpinner()),
        margin: EdgeInsets.only(top: 10),
      );
    } else if (_widgetStatus == WidgetStatusEnum.EmptyResult) {
      widgetForDisplaying = Container(
        child: const Center(child: Text("Nothing found")),
        margin: const EdgeInsets.only(top: 10),
      );
    } else if (_widgetStatus == WidgetStatusEnum.Result && _dictionaryResponse.recommendations.isNotEmpty) {
      widgetForDisplaying = DictionaryRecommendations(recommendations: _dictionaryResponse.recommendations);
    } else if (_widgetStatus == WidgetStatusEnum.Result && _dictionaryResponse.dictionaryEntries.isNotEmpty) {
      widgetForDisplaying = DictionaryEntryWidget(entry: _dictionaryResponse.dictionaryEntries.first);
    } else if (_widgetStatus == WidgetStatusEnum.Error) {
      widgetForDisplaying = Container(
        child: const Center(child: Text("Something went wrong")),
        margin: const EdgeInsets.only(top: 10),
      );
    }

    return widgetForDisplaying;
  }
}