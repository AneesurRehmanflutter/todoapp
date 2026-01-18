import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'model_class.g.dart';
@JsonSerializable()
class Task {
  final String title;
  final String description;
  final String date;
  final String time;
  final String docid;
  bool isCompleted;

  Task(
      { required this.title, required this.description, required this.date, required this.time, required this.docid, this.isCompleted=false});
  factory Task.fromJson(Map<String, dynamic> json) => _$TaskFromJson(json);

  Map<String, dynamic> toJson() => _$TaskToJson(this);
}