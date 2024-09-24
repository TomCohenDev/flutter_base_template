import 'package:flutter_app/indexes/indexes_blocs.dart';
import 'package:flutter_app/indexes/indexes_core.dart';
import 'package:flutter_app/indexes/indexes_models.dart';
import 'package:flutter_app/src/services/service_locator.dart';

class AuthUtils {
  static UserModel? get currentUser {
    // Check if AuthBloc is registered
    if (getIt.isRegistered<AuthBloc>()) {
      final AuthBloc authBloc = getIt<AuthBloc>();
      if (authBloc.state is Authenticated) {
        final authenticatedState = authBloc.state as Authenticated;
        UserModel userData = authenticatedState.userModel;
        return userData;
      } else {
        print("User is not authenticated. Cannot access user model.");
      }
    } else {
      print("AuthBloc is not registered. Cannot access user model.");
    }
    return null;
  }

  static String? get currentUserId {
    return currentUser?.uid;
  }
}
