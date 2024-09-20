// firestore_service.dart

import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  static final FirebaseFirestore _firebaseFirestore =
      FirebaseFirestore.instance;

  static Map<String, dynamic> docToJson(DocumentSnapshot doc) {
    return doc.data() as Map<String, dynamic>;
  }

  static Stream<Map<String, dynamic>?> getDocAsStream(String docPath) {
    return _firebaseFirestore.doc(docPath).snapshots().map((snap) {
      if (snap.data() != null) {
        return _convertTimestamps(snap.data() as Map<String, dynamic>);
      } else {
        return null;
      }
    });
  }

  static Stream<List<Map<String, dynamic>>> getCollectionAsStream(
      String collectionPath) {
    return _firebaseFirestore
        .collection(collectionPath)
        .snapshots()
        .map((querySnapshot) {
      return querySnapshot.docs
          .map((doc) => _convertTimestamps(doc.data()))
          .toList();
    });
  }

  static Future<List<Map<String, dynamic>>> getCollectionAsList(
      String collectionPath) async {
    final querySnapshot =
        await _firebaseFirestore.collection(collectionPath).get();
    return querySnapshot.docs
        .map((doc) => _convertTimestamps(doc.data()))
        .toList();
  }

  static Future<Map<String, dynamic>?> getDoc(String docPath) async {
    try {
      final doc = await _firebaseFirestore.doc(docPath).get();
      if (doc.exists && doc.data() != null) {
        return _convertTimestamps(doc.data()!);
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
      await docRef.set(_convertDateTimes(data));
    } catch (e) {
      throw Exception('Error creating document $docPath: $e');
    }
  }

  static Future<void> updateDoc(
      String docPath, Map<String, dynamic> data) async {
    try {
      final docRef = _firebaseFirestore.doc(docPath);
      await docRef.update(_convertDateTimes(data));
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

  // Helper method to convert Timestamps in data to DateTime
  static Map<String, dynamic> _convertTimestamps(Map<String, dynamic> data) {
    data.forEach((key, value) {
      if (value is Timestamp) {
        data[key] = value.toDate();
      } else if (value is Map) {
        data[key] = _convertTimestamps(value as Map<String, dynamic>);
      }
    });
    return data;
  }

  // Helper method to convert DateTimes in data to Timestamps
  static Map<String, dynamic> _convertDateTimes(Map<String, dynamic> data) {
    data.forEach((key, value) {
      if (value is DateTime) {
        data[key] = Timestamp.fromDate(value);
      } else if (value is Map) {
        data[key] = _convertDateTimes(value as Map<String, dynamic>);
      }
    });
    return data;
  }
}
