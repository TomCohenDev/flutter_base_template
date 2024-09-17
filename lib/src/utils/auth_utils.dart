import 'package:flutter_app/indexes/indexes_blocs.dart';
import 'package:flutter_app/indexes/indexes_models.dart';
import 'package:flutter_app/indexes/indexes_packages.dart';

class AuthUtils {
  static UserModel get currentUser {
    final GetIt getIt = GetIt.instance;

    // Check if AuthBloc is registered
    if (getIt.isRegistered<AuthBloc>()) {
      final AuthBloc authBloc = getIt<AuthBloc>();

      if (authBloc.state.status == AuthStatus.authenticated) {
        UserModel? userModel = authBloc.state.userModel;
        if (userModel != null) {
          return authBloc.state.userModel!;
        } else {
          print(
              "User model is null. The user might not be fully authenticated or the user data is not available.");
        }
      } else {
        print("User is not authenticated. Cannot access user model.");
      }
      // Your existing logic here...
    }
    return UserModel();
  }

  static String? get currentUserId {
    return (currentUser.uid);
  }

  static bool isDummy() {
    return (currentUser.email == 'revampedtester@revamped.com');
  }

  static void cacheTermsCheckbox() {
    GetStorage storage = GetStorage();
    storage.write("user_accepted_terms_${AuthUtils.currentUserId}", true);
  }

  static bool? readCacheTermsCheckbox() {
    GetStorage storage = GetStorage();
    return storage.read("user_accepted_terms_${AuthUtils.currentUserId}");
  }

  static void cacheBirthDate(DateTime birthDate) {
    GetStorage storage = GetStorage();
    storage.write(
        "user_birth_date_${AuthUtils.currentUserId}", birthDate.toString());
  }

  static String? readCacheBirthDate() {
    GetStorage storage = GetStorage();
    return storage.read("user_birth_date_${AuthUtils.currentUserId}");
  }

  static void cacheHeight(height) {
    GetStorage storage = GetStorage();
    storage.write("user_height_${AuthUtils.currentUserId}", height.toString());
  }

  static String? readCacheHeight() {
    GetStorage storage = GetStorage();
    return storage.read("user_height_${AuthUtils.currentUserId}");
  }

  static void cachePrefersedUnits(unit) {
    GetStorage storage = GetStorage();
    storage.write(
        "user_preferred_units_${AuthUtils.currentUserId}", unit.toString());
  }

  static String? readCachePrefersedUnits() {
    GetStorage storage = GetStorage();
    return storage.read("user_preferred_units_${AuthUtils.currentUserId}");
  }
}
