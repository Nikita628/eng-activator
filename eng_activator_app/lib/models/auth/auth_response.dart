import 'package:eng_activator_app/models/user.dart';

class AuthResponse {
  late String token;
  late User user;
  late DateTime? tokenExpirationDate;

  AuthResponse.fromJson(Map<String, dynamic> json) {
    token = json["token"] ?? "";
    user = User.fromJson(json["user"]);
    tokenExpirationDate = json["tokenExpirationDate"] != null ? DateTime.parse(json["tokenExpirationDate"]) : null;
  }
}