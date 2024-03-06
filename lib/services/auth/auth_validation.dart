class AppAuthenticationValidator {
  AppAuthenticationValidator._();

  static final RegExp _emailRegex = RegExp(
      r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$");

  static final RegExp _passwordRegex = RegExp(
      r"^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&,\-_=])[A-Za-z\d@$!%*?&,\-_=]+$");

  static String? validateEmail(String email) {
    if (email.isEmpty) {
      return 'Email must not be empty.';
    }
    if (!_emailRegex.hasMatch(email)) {
      return 'Email is invalid.';
    }
    return null;
  }

  static String? validatePassword(String password) {
    if (password.isEmpty) {
      return 'Password must not be empty.';
    }
    if (password.length < 6) {
      return 'Password must be at least 6 characters long.';
    }
    if (!_passwordRegex.hasMatch(password)) {
      return 'Password must contain at least one uppercase letter, one lowercase letter, one digit and one special character.';
    }
    return null;
  }

  static String? validateConfirmPassword(
      String password, String confirmPassword) {
    if (confirmPassword.isEmpty) {
      return 'Confirm password must not be empty.';
    }
    if (password != confirmPassword) {
      return 'Password does not match.';
    }
    return null;
  }
}
