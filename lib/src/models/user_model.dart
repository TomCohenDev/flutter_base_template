import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:flutter_app/src/models/serializers.dart';

part 'user_model.g.dart';

abstract class UserModel implements Built<UserModel, UserModelBuilder> {
  String get uid;
  String get email;
  @BuiltValueField(wireName: 'created_time')
  DateTime get createdTime;
  @BuiltValueField(wireName: 'last_session_time')
  DateTime get lastSessionTime;

  UserModel._();

  factory UserModel([void Function(UserModelBuilder) updates]) = _$UserModel;
  static final Set<String> expectedFields = {
    'uid',
    'email',
    'created_time',
    'last_session_time'
  };

  Map<String, dynamic> toJson() {
    print('Serializing UserModel: $this');
    return serializers.serializeWith(UserModel.serializer, this)
        as Map<String, dynamic>;
  }

  static UserModel fromJson(Map<String, dynamic> json) {
    print('Deserializing UserModel: $json');
    return deserializeJsonToModelWith<UserModel>(
        json, expectedFields, serializer);
  }

  UserModel copyWith({
    String? uid,
    String? email,
    DateTime? createdTime,
    DateTime? lastSessionTime,
  }) {
    return UserModel((b) {
      b
        ..uid = uid ?? this.uid
        ..email = email ?? this.email
        ..createdTime = createdTime ?? this.createdTime
        ..lastSessionTime = lastSessionTime ?? this.lastSessionTime;
    });
  }

  static Serializer<UserModel> get serializer => _$userModelSerializer;
}
