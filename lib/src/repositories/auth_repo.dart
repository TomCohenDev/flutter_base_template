import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter_app/indexes/indexes_models.dart';
import 'package:flutter_app/indexes/indexes_packages.dart';
import 'package:flutter_app/indexes/indexes_services.dart';

abstract class BaseAuthRepository {
  Stream<auth.User?> get user;
  Future<SignUpResult> signUpWithEmail({
    required UserModel userModel,
    required String password,
  });
  Future<AuthResponse> logInWithEmail({
    required String email,
    required String password,
  });

  Future<void> signOut();
  Future<void> forgotPassword(String email);
  String? getUserProvider();
}

class AuthRepository extends BaseAuthRepository {
  final auth.FirebaseAuth _firebaseAuth;
  final UserRepository _userRepository;

  AuthRepository(
      {auth.FirebaseAuth? firebaseAuth, required UserRepository userRepository})
      : _firebaseAuth = firebaseAuth ?? auth.FirebaseAuth.instance,
        _userRepository = userRepository;

  @override
  Future<void> forgotPassword(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } on auth.FirebaseAuthException catch (e) {
      print("Error sending password reset email: ${e.message}");
      // Optionally, handle error by showing UI feedback
    }
  }

  @override
  Future<SignUpResult> signUpWithEmail({
    required UserModel userModel,
    required String password,
  }) async {
    try {
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: userModel.email!,
        password: password,
      );

      final authUser = userCredential.user;

      await _userRepository.createUser(
        userModel.copyWith(
          uid: authUser!.uid,
          created_time: DateTime.now(),
          email: userModel.email,
        ),
      );
// revampedtester@revamped.com
// 123456
      return SignUpResult(user: authUser);
    } on auth.FirebaseAuthException catch (e) {
      print("FirebaseAuthException: ${e.toString()}");
      return SignUpResult(errorMessage: e.message, errorCode: e.code);
    } on PlatformException catch (e) {
      print("PlatformException: ${e.toString()}");
      return SignUpResult(errorMessage: e.message, errorCode: e.code);
    } catch (e) {
      print("Unknown Exception: ${e.toString()}");
      return SignUpResult(errorMessage: e.toString());
    }
  }

  @override
  Future<AuthResponse> logInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final authResult = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (authResult.user != null) {
        return AuthResponse(success: true);
      } else {
        return AuthResponse(success: false);
      }
    } on auth.FirebaseAuthException catch (e) {
      print(e.toString());

      return AuthResponse(
          success: false, errorMessage: e.message, errorCode: e.code);
    }
  }

  @override
  Stream<auth.User?> get user => _firebaseAuth.userChanges();

  @override
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  String generateNonce([int length = 32]) {
    const charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    return List.generate(length, (_) => charset[random.nextInt(charset.length)])
        .join();
  }

  @override
  String? getUserProvider() {
    var user = _firebaseAuth.currentUser;
    var providerId = user?.providerData[0]
        .providerId; // Assuming the first provider is the main one

    return providerId;
  }
}
