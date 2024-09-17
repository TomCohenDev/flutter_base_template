import 'package:flutter_app/indexes/indexes_packages.dart';

class Validators {
  static String? emailValidator(String? email) =>
      email != null && !EmailValidator.validate(email)
          ? 'Enter a valid email'
          : null;

  static String? passwordValidator(String? password) =>
      password != null && password.length < 6
          ? 'Password minimum length 6 charecters'
          : null;

  static String? ConfirmPasswordValidator(
          String? password, String? confirmPassword) =>
      confirmPassword != null && password != confirmPassword
          ? 'Passwords do not match'
          : null;
}
