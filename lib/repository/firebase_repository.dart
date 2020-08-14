import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_firebase/models/Task.dart';
import 'package:flutter_firebase/models/TaskEntity.dart';

class FirebaseRepository {
  final taskCollection = Firestore.instance.collection('tasks');

  Future<void> addNewTask(Task task) {
    return taskCollection.add(task.toEntity().toDocument());
  }

  Future<void> deleteTask(Task task) {
    return taskCollection.document(task.id).delete();
  }

  Stream<List<Task>> tasks() {
    return taskCollection.snapshots().map((snapshot) {
      return snapshot.documents
          .map((doc) => Task.fromEntity(TaskEntity.fromSnapshot(doc)))
          .toList();
    });
  }

  Future<void> updateTask(Task update) {
    return taskCollection
        .document(update.id)
        .updateData(update.toEntity().toDocument());
    // var result;
    // DocumentReference documentTask =
    //     Firestore.instance.document('tasks/${update.id}');
    // result = Firestore.instance.runTransaction((transaction) async {
    //   DocumentSnapshot task = await transaction.get(documentTask);
    //   if (task.exists) {
    //     await transaction.update(
    //       documentTask,
    //       <String, dynamic>{
    //         'name': update.title,
    //         'description': update.description,
    //         'date': update.date,
    //       },
    //     );
    //   }
    // });
    // return result;
  }
}
