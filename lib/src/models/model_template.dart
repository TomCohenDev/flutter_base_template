// import 'package:built_value/built_value.dart';
// import 'package:built_value/serializer.dart';
// import 'package:flutter_app/src/models/serializers.dart';

// part 'model_template.g.dart';

// abstract class TemplateModel
//     implements Built<TemplateModel, TemplateModelBuilder> {
//   String get uid;
//   String get email;
//   @BuiltValueField(wireName: 'created_time')
//   DateTime get createdTime;
//   @BuiltValueField(wireName: 'last_session_time')
//   DateTime get lastSessionTime;
//   String? get name;

//   TemplateModel._();

//   factory TemplateModel([void Function(TemplateModelBuilder) updates]) =
//       _$TemplateModel;
//   static final Set<String> expectedFields = {
//     'uid',
//     'email',
//     'created_time',
//     'last_session_time',
//     'name'
//   };

//   Map<String, dynamic> toJson() {
//     print('Serializing TemplateModel: $this');
//     return serializers.serializeWith(TemplateModel.serializer, this)
//         as Map<String, dynamic>;
//   }

//   static TemplateModel fromJson(Map<String, dynamic> json) {
//     print('Deserializing TemplateModel: $json');
//     return deserializeJsonToModelWith<TemplateModel>(
//         json, expectedFields, serializer);
//   }

//   TemplateModel copyWith({
//     String? uid,
//     String? email,
//     DateTime? createdTime,
//     DateTime? lastSessionTime,
//     String? name,
//   }) {
//     return TemplateModel((b) {
//       b
//         ..uid = uid ?? this.uid
//         ..email = email ?? this.email
//         ..createdTime = createdTime ?? this.createdTime
//         ..lastSessionTime = lastSessionTime ?? this.lastSessionTime
//         ..name = name ?? this.name;
//     });
//   }

//   static Serializer<TemplateModel> get serializer => _$templateModelSerializer;
// }

// run this command to generate the necessary files:
// flutter pub run build_runner build --delete-conflicting-outputs
