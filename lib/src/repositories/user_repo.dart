import 'package:flutter_app/indexes/indexes_models.dart';
import 'package:flutter_app/indexes/indexes_packages.dart';
import 'package:flutter_app/indexes/indexes_services.dart';

abstract class BaseUserRepository {
  Future<void> createUser(UserModel user);
  Future<UserModel?> getUser(String uid);
  Future<void> updateUser(UserModel user);
  Future<void> deleteUser(String uid);
  Stream<UserModel?> userStream(String uid);
}

class UserRepository extends BaseUserRepository {
  final String collectionPath = 'users/';

  UserRepository();

  @override
  Stream<UserModel?> userStream(String uid) {
    print('getting user stream from firestore');
    final docPath = collectionPath + uid;
    final docStream = FirestoreService.getDocAsStream(docPath);
    return docStream.map((doc) => doc != null ? UserModel.fromJson(doc) : null);
  }

  @override
  Future<UserModel?> getUser(String uid) async {
    print('getting user data from firestore');
    final docPath = collectionPath + uid;
    final data = await FirestoreService.getDoc(docPath);
    return data != null ? UserModel.fromJson(data) : null;
  }

  @override
  Future<void> createUser(UserModel user) async {
    print('creating user');
    final docPath = collectionPath + user.uid;
    return await FirestoreService.createDoc(docPath, user.toJson());
  }

  @override
  Future<void> updateUser(UserModel user) async {
    print('updating user');
    final docPath = collectionPath + user.uid;
    return await FirestoreService.updateDoc(docPath, user.toJson());
  }

  @override
  Future<void> deleteUser(String uid) async {
    print('deleting user');
    final docPath = collectionPath + uid;
    return await FirestoreService.deleteDoc(docPath);
  }
}
