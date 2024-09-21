// firestore_service.dart

import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  static final FirebaseFirestore _firebaseFirestore =
      FirebaseFirestore.instance;

  static Stream<Map<String, dynamic>?> streamDoc(String docPath) {
    return _firebaseFirestore.doc(docPath).snapshots().map((snap) {
      if (snap.data() != null) {
        return snap.data();
      } else {
        return null;
      }
    });
  }

  static Stream<List<Map<String, dynamic>>> streamCollection(
      String collectionPath) {
    return _firebaseFirestore
        .collection(collectionPath)
        .snapshots()
        .map((querySnapshot) {
      return querySnapshot.docs.map((doc) => doc.data()).toList();
    });
  }

  static Future<List<Map<String, dynamic>>> getCollection(
      String collectionPath) async {
    final querySnapshot =
        await _firebaseFirestore.collection(collectionPath).get();
    return querySnapshot.docs.map((doc) => doc.data()).toList();
  }

  static Future<Map<String, dynamic>?> getDoc(String docPath) async {
    try {
      final doc = await _firebaseFirestore.doc(docPath).get();
      if (doc.exists && doc.data() != null) {
        return doc.data()!;
      } else {
        return null;
      }
    } catch (e) {
      throw Exception('Error getting document $docPath: $e');
    }
  }

  static Future<void> createDoc(
      String docPath, Map<String, dynamic> data) async {
    try {
      if (await doesDocExist(docPath)) return;
      final docRef = _firebaseFirestore.doc(docPath);
      await docRef.set(data);
    } catch (e) {
      throw Exception('Error creating document $docPath: $e');
    }
  }

  static Future<void> updateDoc(
      String docPath, Map<String, dynamic> data) async {
    try {
      final docRef = _firebaseFirestore.doc(docPath);
      await docRef.update(data);
    } catch (e) {
      throw Exception('Error updating document $docPath: $e');
    }
  }

  static Future<void> deleteDoc(String docPath) async {
    try {
      final docRef = _firebaseFirestore.doc(docPath);
      await docRef.delete();
    } catch (e) {
      throw Exception('Error deleting document $docPath: $e');
    }
  }

  static Future<bool> doesDocExist(String docPath) async {
    try {
      return (await _firebaseFirestore.doc(docPath).get()).exists;
    } catch (e) {
      throw Exception('Error checking existence of document $docPath: $e');
    }
  }
}
