// create a function that return json from a firestore document

import 'package:cloud_firestore/cloud_firestore.dart';

Map<String, dynamic> jsonFromFirestore(DocumentSnapshot doc) {
  return doc.data() as Map<String, dynamic>;
}
