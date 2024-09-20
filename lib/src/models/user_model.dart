import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:flutter_app/src/models/serializers.dart';

part 'user_model.g.dart';

abstract class UserModel implements Built<UserModel, UserModelBuilder> {
  String get uid;
  String? get email;
  DateTime? get createdTime;

  UserModel._();

  factory UserModel([void Function(UserModelBuilder) updates]) = _$UserModel;

  Map<String, dynamic> toJson() {
    return serializers.serializeWith(UserModel.serializer, this)
        as Map<String, dynamic>;
  }

  static UserModel? fromJson(Map<String, dynamic> json) {
    return serializers.deserializeWith(UserModel.serializer, json);
  }

  static Serializer<UserModel> get serializer => _$userModelSerializer;
}
