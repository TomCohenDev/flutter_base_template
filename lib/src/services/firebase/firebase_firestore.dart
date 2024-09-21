import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  static final FirebaseFirestore _firebaseFirestore =
      FirebaseFirestore.instance;

  static Stream<Map<String, dynamic>?> streamDoc(String docPath) {
    return _firebaseFirestore.doc(docPath).snapshots().map((snap) {
      if (!snap.exists) throw Exception('Document $docPath does not exist');
      final data = snap.data();
      if (data == null) throw Exception('Document $docPath data is null');
      return snap.data();
    }).handleError((error) {
      print('Error in streamDoc: $error');
      throw Exception('Error in streamDoc for $docPath: $error');
    });
  }

  static Stream<List<Map<String, dynamic>>> streamCollection(
      String collectionPath) {
    return _firebaseFirestore
        .collection(collectionPath)
        .snapshots()
        .map((querySnapshot) {
      return querySnapshot.docs.map((doc) => doc.data()).toList();
    }).handleError((error) {
      print('Error in streamCollection: $error');
      throw Exception('Error in streamDoc for $collectionPath: $error');
    });
  }

  static Future<List<Map<String, dynamic>>> getCollection(
      String collectionPath) async {
    try {
      final querySnapshot = await _firebaseFirestore
          .collection(collectionPath)
          .get()
          .onError((error, stackTrace) {
        print('Error in getCollection: $error');
        throw Exception('Error getting collection $collectionPath: $error');
      });
      return querySnapshot.docs.map((doc) => doc.data()).toList();
    } catch (e) {
      print('Error in getCollection: $e');
      throw Exception('Error getting collection $collectionPath: $e');
    }
  }

  static Future<Map<String, dynamic>?> getDoc(String docPath) async {
    try {
      final doc = await _firebaseFirestore.doc(docPath).get();
      if (!doc.exists) throw Exception('Document $docPath does not exist');
      final data = doc.data();
      if (data == null) throw Exception('Document $docPath data is null');
      return data;
    } catch (e) {
      print('Error in getDoc: $e');
      throw Exception('Error getting document $docPath: $e');
    }
  }

  static Future<void> createDoc(
      String docPath, Map<String, dynamic> data) async {
    try {
      if (await doesDocExist(docPath))
        throw Exception('Document $docPath already exists');
      final docRef = _firebaseFirestore.doc(docPath);
      await docRef.set(data);
    } catch (e) {
      print('Error in createDoc: $e');
      throw Exception('Error creating document $docPath: $e');
    }
  }

  static Future<void> updateDoc(
      String docPath, Map<String, dynamic> data) async {
    try {
      final docRef = _firebaseFirestore.doc(docPath);
      await docRef.update(data);
    } catch (e) {
      print('Error in updateDoc: $e');
      throw Exception('Error updating document $docPath: $e');
    }
  }

  static Future<void> deleteDoc(String docPath) async {
    try {
      final docRef = _firebaseFirestore.doc(docPath);
      await docRef.delete();
    } catch (e) {
      print('Error in deleteDoc: $e');
      throw Exception('Error deleting document $docPath: $e');
    }
  }

  static Future<bool> doesDocExist(String docPath) async {
    try {
      final docSnapshot = await _firebaseFirestore.doc(docPath).get();
      return docSnapshot.exists;
    } catch (e) {
      print('Error in doesDocExist: $e');
      throw Exception('Error checking existence of document $docPath: $e');
    }
  }
}
