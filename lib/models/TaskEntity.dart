import 'package:cloud_firestore/cloud_firestore.dart';

class TaskEntity {
  String id;
  String title;
  String description;
  String date;

  TaskEntity(this.id, this.title, this.description, this.date);

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'date': date,
    };
  }

  static TaskEntity fromJson(Map<String, dynamic> json) {
    return TaskEntity(
      json['id'] as String,
      json['title'] as String,
      json['description'] as String,
      json['date'] as String,
    );
  }

  static TaskEntity fromSnapshot(DocumentSnapshot snap) {
    return TaskEntity(
      snap.documentID,
      snap.data['title'],
      snap.data['description'],
      snap.data['date'],
    );
  }

  Map<String, dynamic> toDocument() {
    return {
      'title': title,
      'description': description,
      'date': date,
    };
  }
}
