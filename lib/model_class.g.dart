// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'model_class.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Task _$TaskFromJson(Map<String, dynamic> json) => Task(
  title: json['title'] as String,
  description: json['description'] as String,
  date: json['date'] as String,
  time: json['time'] as String,
  docid: json['docid'] as String,
  isCompleted: json['isCompleted'] as bool? ?? false,
);

Map<String, dynamic> _$TaskToJson(Task instance) => <String, dynamic>{
  'title': instance.title,
  'description': instance.description,
  'date': instance.date,
  'time': instance.time,
  'docid': instance.docid,
  'isCompleted': instance.isCompleted,
};
