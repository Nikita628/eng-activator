class SignupDto {
  late String name;
  late String email;
  late String password;
  late String passwordConfirmation;

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "email": email,
      "password": password,
      "passwordConfirmation": passwordConfirmation,
    };
  }
}
