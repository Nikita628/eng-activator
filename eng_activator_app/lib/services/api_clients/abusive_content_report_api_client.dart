import 'package:eng_activator_app/models/abusive_content_report.dart';
import 'package:eng_activator_app/services/api_clients/base_api_client.dart';
import 'package:eng_activator_app/shared/constants.dart';
import 'package:eng_activator_app/state/auth_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'dart:convert';
import 'package:provider/provider.dart';

class AbusiveContentReportApiClient extends BaseApiClient {
  final Uri _urlForCreate = Uri.https(AppConstants.getApiUrl(), '/api/abusive-content-report/create');

  Future<void> create(AbusiveContentReport dto, BuildContext context) async {
    var token = Provider.of<AuthProvider>(context, listen: false).getToken();

    Response response = await executeHttp(() {
      return http.post(_urlForCreate, body: jsonEncode(dto), headers: createRequestHeaders(token));
    }, context);

    if (response.statusCode != 200) {
      throw createApiException(response.body);
    }
  }
}
