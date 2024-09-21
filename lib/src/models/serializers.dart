import 'package:flutter_app/indexes/indexes_packages.dart';
import 'package:flutter_app/indexes/indexes_services.dart';
import 'user_model.dart';

part 'serializers.g.dart';

@SerializersFor([
  UserModel,
])
final Serializers serializers = (_$serializers.toBuilder()
      ..add(DateTimeSerializer())
      ..addPlugin(StandardJsonPlugin()))
    .build();

void validateJsonForModel(
    Map<String, dynamic> json, Set<String> expectedFields) {
  final jsonKeys = json.keys.toSet();
  final missingFields = expectedFields.difference(jsonKeys);
  if (missingFields.isNotEmpty) {
    throw DeserializationException(
      'Missing required fields: ${missingFields.join(', ')}',
    );
  }
  final extraFields = jsonKeys.difference(expectedFields);
  if (extraFields.isNotEmpty) {
    throw DeserializationException(
      'Unexpected fields: ${extraFields.join(', ')}',
    );
  }
}

T deserializeJsonToModelWith<T>(
  Map<String, dynamic> json,
  Set<String> expectedFields,
  Serializer<T> serializer,
) {
  try {
    validateJsonForModel(json, expectedFields);
    final model = serializers.deserializeWith(serializer, json);
    if (model == null)
      throw DeserializationException('Deserialization returned null');
    return model;
  } catch (error) {
    throw DeserializationException(
        'Error deserializing ${T.toString()}: $error');
  }
}

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
