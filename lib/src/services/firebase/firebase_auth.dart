import 'package:flutter_app/indexes/indexes_models.dart';
import 'package:flutter_app/indexes/indexes_packages.dart';

class FirebaseAuthService {
  static final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<UserCredential> signUpWithEmail({
    required String email,
    required String password,
  }) async {
    return await _firebaseAuth
        .createUserWithEmailAndPassword(
          email: email,
          password: password,
        )
        .catchError((onError) => print(onError.message));
  }
}
