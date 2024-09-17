import 'package:flutter_app/indexes/indexes_models.dart';
import 'package:flutter_app/indexes/indexes_packages.dart';

abstract class BaseUserRepository {
  Stream<UserModel?> getUser(String uid);
  Future<void> createUser(UserModel user);
  Future<void> updateUser(UserModel user);
  Future<void> deleteUser(UserModel user);
}

class UserRepository extends BaseUserRepository {
  final FirebaseFirestore _firebaseFirestore;

  UserRepository({
    FirebaseFirestore? firebaseFirestore,
  }) : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;

  @override
  Stream<UserModel?> getUser(String uid) {
    print('getting user data from firestore');
    return _firebaseFirestore
        .collection('users')
        .doc(uid)
        .snapshots()
        .map((snap) {
      if (snap.data() != null) {
        return UserModel.fromJson(snap);
      } else {
        return null;
      }
    });
  }

  @override
  Future<void> createUser(UserModel user) async {
    bool userExists =
        (await _firebaseFirestore.collection('users').doc(user.uid).get())
            .exists;
    if (userExists) {
      return;
    }
    print('creating new user');

    final userWithToken = user.copyWith();
    return await _firebaseFirestore
        .collection('users')
        .doc(user.uid)
        .set(userWithToken.toDocument());
  }

  @override
  Future<void> updateUser(UserModel user) async {
    return await _firebaseFirestore
        .collection('users')
        .doc(user.uid)
        .update(user.toDocument())
        .then((value) => print('user doc updated'));
  }

  @override
  Future<void> deleteUser(UserModel user) async {
    print('deleting user');
    return await _firebaseFirestore
        .collection('users')
        .doc(user.uid)
        .delete()
        .then((value) => print('User deleted'))
        .catchError((error) => print('Failed to delete user: $error'));
  }
}
