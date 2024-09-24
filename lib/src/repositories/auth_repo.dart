import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter_app/indexes/indexes_models.dart';
import 'package:flutter_app/indexes/indexes_packages.dart';
import 'package:flutter_app/indexes/indexes_services.dart';

abstract class BaseAuthRepository {
  Stream<auth.User?> get user;
  Future<String> signUpWithEmail(
      {required String email, required String password});
  Future<AuthResponse> logInWithEmail(
      {required String email, required String password});
  Future<void> signOut();
  Future<void> deleteAuthUser();
}

class AuthRepository extends BaseAuthRepository {
  final auth.FirebaseAuth _firebaseAuth;

  AuthRepository(
      {auth.FirebaseAuth? firebaseAuth, required UserRepository userRepository})
      : _firebaseAuth = firebaseAuth ?? auth.FirebaseAuth.instance;

  @override
  Stream<auth.User?> get user => _firebaseAuth.userChanges();

  @override
  Future<void> deleteAuthUser() async {
    final user = _firebaseAuth.currentUser;
    if (user != null) {
      await user.delete().onError((error, stackTrace) {
        print('Error deleting user: $error');
        throw Exception('Error deleting user: $error');
      });
    } else {
      print('Error deleting user: user is null');
      throw Exception('Error deleting user: user is null');
    }
  }

  @override
  Future<String> signUpWithEmail({
    required String email,
    required String password,
  }) async {
    final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    final authUser = userCredential.user;
    return authUser!.uid;
  }

  @override
  Future<AuthResponse> logInWithEmail({
    required String email,
    required String password,
  }) async {
    final authResult = await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    if (authResult.user != null) {
      return AuthResponse(success: true);
    } else {
      return AuthResponse(success: false);
    }
  }

  @override
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}
