import 'package:eng_activator_app/models/activity_response/activity_response_review.dart';
import 'package:eng_activator_app/models/activity_response/activity_response_review_search_param.dart';
import 'package:eng_activator_app/models/api_page_response.dart';
import 'package:eng_activator_app/shared/constants.dart';
import 'package:eng_activator_app/shared/functions.dart';
import 'package:eng_activator_app/state/auth_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';

class ActivityResponseReviewApiClient {
  final Uri _searchPreviewUrl = Uri.https(AppConstants.apiUrl, '/api/activity-response-review/search');

  Future<ApiPageResponse<ActivityResponseReview>> search(ActivityResponseReviewSearchParam param, BuildContext context) async {
    var token = Provider.of<AuthProvider>(context, listen: false).getToken();
    
    var response = await http.post(_searchPreviewUrl, body: json.encode(param), headers: createRequestHeaders(token));

    if (response.statusCode == 200) {
      Map<String, dynamic> map = jsonDecode(response.body);
      return ApiPageResponse.fromJson(map, (i) => ActivityResponseReview.fromJson(i));
    } else {
      throw createApiException(response.body);
    }
  }
}
