import 'package:eng_activator_app/models/dictionary/dictionary_response.dart';
import 'package:eng_activator_app/models/dictionary/dictionary_search_param.dart';
import 'package:eng_activator_app/shared/constants.dart';
import 'package:eng_activator_app/shared/functions.dart';
import 'package:eng_activator_app/state/auth_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';

class DictionaryApiClient {
  final Uri _searchUrl = Uri.http(AppConstants.getApiUrl(), '/api/dictionary/search');

  Future<DictionaryResponse> search(DictionarySearchParam param, BuildContext context) async {
    var token = Provider.of<AuthProvider>(context, listen: false).getToken();

    var response = await http.post(_searchUrl, body: json.encode(param), headers: createRequestHeaders(token));

    if (response.statusCode == 200) {
      Map<String, dynamic> map = jsonDecode(response.body);
      return DictionaryResponse.fromJson(map);
    } else {
      throw createApiException(response.body);
    }
  }
}
