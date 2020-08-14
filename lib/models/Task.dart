import 'package:flutter_firebase/models/TaskEntity.dart';

class Task {
  String id;
  String title;
  String description;
  String date;

  Task({this.id, this.title, this.description, this.date});

  TaskEntity toEntity() {
    return TaskEntity(id, title, description, date);
  }

  static Task fromEntity(TaskEntity entity) {
    return Task(
      id: entity.id,
      title: entity.title,
      description: entity.description,
      date: entity.date,
    );
  }
}
