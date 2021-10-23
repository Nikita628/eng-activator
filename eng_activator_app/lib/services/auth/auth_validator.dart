class AuthValidator {
  String? validateName(String? val) {
    String? error;

    if (val == null || val.isEmpty) {
      error = 'Name is required';
    } else if (val.length > 50) {
      error = 'Name is too long';
    } else if (val.length < 2) {
      error = 'Name is too short';
    }

    return error;
  }

  String? validateEmail(String? val) {
    RegExp validEmailRegExp = RegExp(r".+@.+\..+");

    String? error;

    if (val == null || val.isEmpty) {
      error = 'Email is required';
    } else if (!validEmailRegExp.hasMatch(val)) {
      error = 'Email has invalid format';
    }

    return error;
  }

  String? validatePassword(String? val) {
    String? error;

    if (val == null || val.isEmpty) {
      error = 'Password is required';
    } else if (val.length < 6) {
      error = 'Password is too short';
    }

    return error;
  }

  String? validatePasswordConfirmation(String? password, String? confirmation) {
    String? error;

    if (confirmation == null || confirmation.isEmpty) {
      error = 'Password confirmation is required';
    } else if (confirmation != password) {
      error = 'Confirmation does not match password';
    }

    return error;
  }

  String? validateEmailOnLogin(String? val) {
    String? error;

    if (val == null || val.isEmpty) {
      error = 'Email is required';
    } 

    return error;
  }

  String? validatePasswordOnLogin(String? val) {
    String? error;

    if (val == null || val.isEmpty) {
      error = 'Password is required';
    }

    return error;
  }
}
