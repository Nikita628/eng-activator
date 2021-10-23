class LoginDto {
  late String email;
  late String password;

  Map<String, dynamic> toJson() {
    return {
      "email": email,
      "password": password,
    };
  }
}
