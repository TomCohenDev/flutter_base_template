import 'package:flutter_app/indexes/indexes_packages.dart';

class UserModel extends Equatable {
  final String? uid;
  final String? email;
  final DateTime? createdTime;
  const UserModel({
    this.uid,
    this.email,
    this.createdTime,
  });

  UserModel copyWith({
    String? uid,
    String? email,
    DateTime? createdTime,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      createdTime: createdTime ?? this.createdTime,
    );
  }

  factory UserModel.fromJson(DocumentSnapshot snap) {
    final data = snap.data() as Map<String, dynamic>?;
    if (data == null) return UserModel();
    return UserModel(
      uid: snap.id,
      email: data['email'],
      createdTime: (data['created_time'] as Timestamp).toDate(),
    );
  }

  Map<String, Object?> toJson() {
    return {
      'email': email,
      'created_time': createdTime,
    };
  }

  @override
  List<Object?> get props => [
        uid,
        email,
        createdTime,
      ];
}
