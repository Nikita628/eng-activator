import 'package:eng_activator_app/models/activity_response/activity_response_details.dart';
import 'package:eng_activator_app/models/activity_response/activity_response_for_create.dart';
import 'package:eng_activator_app/models/activity_response/activity_response_for_review.dart';
import 'package:eng_activator_app/models/activity_response/activity_response_preview.dart';
import 'package:eng_activator_app/models/activity_response/activity_response_search_param.dart';
import 'package:eng_activator_app/models/api/api_keyset_page_response.dart';
import 'package:eng_activator_app/services/api_clients/base_api_client.dart';
import 'package:eng_activator_app/shared/constants.dart';
import 'package:eng_activator_app/state/auth_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'dart:convert';
import 'package:provider/provider.dart';

class ActivityResponseApiClient extends BaseApiClient {
  final Uri _searchPreviewUrl = Uri.https(AppConstants.getApiUrl(), '/api/activity-response/search-preview');
  final Uri _getForReviewUrl = Uri.https(AppConstants.getApiUrl(), '/api/activity-response/review');
  final Uri _createUrl = Uri.https(AppConstants.getApiUrl(), '/api/activity-response/create');
  final String _getDetailsUrl = '/api/activity-response/details/';

  Future<KeysetPageResponse<ActivityResponsePreview>> searchPreviews(
      ActivityResponseSearchParam param, BuildContext context) async {
    var token = Provider.of<AuthProvider>(context, listen: false).getToken();

    Response response = await executeHttp(() {
      return http.post(_searchPreviewUrl, body: json.encode(param), headers: createRequestHeaders(token));
    }, context);

    if (response.statusCode == 200) {
      Map<String, dynamic> map = jsonDecode(response.body);
      return KeysetPageResponse.fromJson(map, (i) => ActivityResponsePreview.fromJson(i));
    } else {
      throw createApiException(response.body);
    }
  }

  Future<ActivityResponseDetails> getDetails(int id, BuildContext context) async {
    var token = Provider.of<AuthProvider>(context, listen: false).getToken();
    var url = Uri.https(AppConstants.getApiUrl(), _getDetailsUrl + id.toString());

    Response response = await executeHttp(() {
      return http.get(url, headers: createRequestHeaders(token));
    }, context);

    if (response.statusCode == 200) {
      Map<String, dynamic> map = jsonDecode(response.body);
      return ActivityResponseDetails.fromJson(map);
    } else {
      throw createApiException(response.body);
    }
  }

  Future<ActivityResponseForReview?> getForReview(BuildContext context) async {
    var token = Provider.of<AuthProvider>(context, listen: false).getToken();

    Response response = await executeHttp(() {
      return http.get(_getForReviewUrl, headers: createRequestHeaders(token));
    }, context);

    if (response.statusCode == 200) {
      Map<String, dynamic> map = jsonDecode(response.body);
      return ActivityResponseForReview.fromJson(map);
    } else if (response.statusCode == 404) {
      return null;
    } else {
      throw createApiException(response.body);
    }
  }

  Future<int> create(ActivityResponseForCreate dto, BuildContext context) async {
    var token = Provider.of<AuthProvider>(context, listen: false).getToken();

    Response response = await executeHttp(() {
      return http.post(_createUrl, body: jsonEncode(dto), headers: createRequestHeaders(token));
    }, context);

    if (response.statusCode == 200) {
      int id = jsonDecode(response.body);
      return id;
    } else {
      throw createApiException(response.body);
    }
  }
}
