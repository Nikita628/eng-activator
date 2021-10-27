import 'package:eng_activator_app/models/activity_response/activity_response_details.dart';
import 'package:eng_activator_app/models/activity_response/activity_response_preview.dart';
import 'package:eng_activator_app/models/activity_response/activity_response_search_param.dart';
import 'package:eng_activator_app/models/api_page_response.dart';
import 'package:eng_activator_app/shared/constants.dart';
import 'package:eng_activator_app/shared/functions.dart';
import 'package:eng_activator_app/state/auth_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';

class ActivityResponseApiClient {
  final Uri _searchPreviewUrl = Uri.https(AppConstants.apiUrl, '/api/activity-response/search-preview');
  final String _getDetailsUrl = '/api/activity-response/details/';

  Future<ApiPageResponse<ActivityResponsePreview>> searchPreviews(ActivityResponseSearchParam param, BuildContext context) async {
    var token = Provider.of<AuthProvider>(context, listen: false).getToken();
    
    var response = await http.post(_searchPreviewUrl, body: json.encode(param), headers: createRequestHeaders(token));

    if (response.statusCode == 200) {
      Map<String, dynamic> map = jsonDecode(response.body);
      return ApiPageResponse.fromJson(map, (i) => ActivityResponsePreview.fromJson(i));
    } else {
      throw createApiException(response.body);
    }
  }

  Future<ActivityResponseDetails> getDetails(int id, BuildContext context) async {
    var token = Provider.of<AuthProvider>(context, listen: false).getToken();
    var url = Uri.https(AppConstants.apiUrl, _getDetailsUrl + id.toString());

    var response = await http.get(url, headers: createRequestHeaders(token));

    if (response.statusCode == 200) {
      Map<String, dynamic> map = jsonDecode(response.body);
      return ActivityResponseDetails.fromJson(map);
    } else {
      throw createApiException(response.body);
    }
  }
}
