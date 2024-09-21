import 'package:built_collection/built_collection.dart';
import 'package:built_value/serializer.dart';
import 'package:built_value/standard_json_plugin.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'user_model.dart';

part 'serializers.g.dart';

@SerializersFor([
  UserModel,
])
final Serializers serializers = (_$serializers.toBuilder()
      ..add(DateTimeSerializer())
      ..addPlugin(StandardJsonPlugin()))
    .build();

class DateTimeSerializer implements PrimitiveSerializer<DateTime> {
  @override
  final Iterable<Type> types = [DateTime];
  @override
  final String wireName = 'DateTime';

  @override
  Object serialize(Serializers serializers, DateTime dateTime,
      {FullType specifiedType = FullType.unspecified}) {
    // Convert DateTime to Timestamp when serializing
    return Timestamp.fromDate(dateTime);
  }

  @override
  DateTime deserialize(Serializers serializers, Object serialized,
      {FullType specifiedType = FullType.unspecified}) {
    if (serialized is Timestamp) {
      // Convert Timestamp to DateTime
      return serialized.toDate();
    } else if (serialized is DateTime) {
      return serialized;
    } else if (serialized is String) {
      // Handle string representations if necessary
      return DateTime.parse(serialized);
    } else {
      throw ArgumentError('Cannot deserialize $serialized to DateTime');
    }
  }
}
