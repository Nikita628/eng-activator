import 'package:eng_activator_app/models/api/api_error_response.dart';

class ApiResponseException implements Exception {
  ApiErrorResponse errorResponse;
  ApiResponseException(this.errorResponse);
}
