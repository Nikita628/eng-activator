class ApiErrorResponse {
  String message = '';
  Map<String, List<String>> errorsMap = Map<String, List<String>>();
  String details = '';

  ApiErrorResponse.fromJson(Map<String, dynamic> json) {
    message = json["message"] ?? "";
    details = json["details"] ?? "";
    // errorsMap = json["errorsMap"] ?? Map();
  }
}