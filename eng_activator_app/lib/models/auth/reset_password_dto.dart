class ResetPasswordDto {
  late String email;

  Map<String, dynamic> toJson() {
    return {
      "email": email,
    };
  }
}
