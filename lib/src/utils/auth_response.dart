import 'package:firebase_auth/firebase_auth.dart' as auth;

class AuthResponse {
  final bool success;
  final String? errorMessage;
  final String? errorCode;

  AuthResponse({required this.success, this.errorMessage, this.errorCode});

  String errorMessageFormatter() {
    print(errorCode);

    print(errorMessage);

    // Example of custom formatting based on errorCode
    switch (errorCode) {
      case "invalid-email":
        return "The email address is badly formatted.";
      case "user-not-found":
        return "No user found with this email address.";
      case "email-already-in-use":
        return "The email address is already in use by another account.";
      case "wrong-password":
        return "The password is invalid.";
      case "unknown" || "null" || null:
        return "operation cancelled.";
      default:
        return "An unknown error occurred: $errorCode";
    }
  }
}

class SignUpResult {
  final auth.User? user;
  final String? errorMessage;
  final String? errorCode;

  SignUpResult({this.user, this.errorMessage, this.errorCode});
}
