import 'package:flutter_app/indexes/indexes_models.dart';
import 'package:flutter_app/indexes/indexes_packages.dart';

abstract class BaseHandshakeRepository {
  Future<HandshakeModel?> getHandshakeData();
}

class HandshakeRepository extends BaseHandshakeRepository {
  final FirebaseFirestore _firebaseFirestore;
  final isDev = false;

  HandshakeRepository({
    FirebaseFirestore? firebaseFirestore,
  }) : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;

  @override
  Future<HandshakeModel?> getHandshakeData() async {
    try {
      DocumentSnapshot snapshot = await _firebaseFirestore
          .collection('admin')
          .doc(isDev ? 'client-tools-dev' : 'client-tools')
          .get();
      PackageInfo packageInfo = await PackageInfo.fromPlatform();

      return HandshakeModel.fromFirestore(
          snapshot.data() as Map<String, dynamic>, packageInfo);
    } catch (e) {
      print('Error getting handshake data: $e');
      return null;
    }
  }
}
