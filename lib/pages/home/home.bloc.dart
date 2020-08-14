import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_firebase/models/Task.dart';
import 'package:flutter_firebase/repository/firebase_repository.dart';

class TaskEvent {}

class TaskState {}

// event

class LoadTasks extends TaskEvent {}

class AddTask extends TaskEvent {
  Task task;

  AddTask({this.task});
}

class UpdateTask extends TaskEvent {
  Task task;

  UpdateTask({this.task});
}

class DeleteTask extends TaskEvent {
  Task task;

  DeleteTask({this.task});
}

class TasksUpdated extends TaskEvent {
  List<Task> tasks;

  TasksUpdated({this.tasks});
}

// state

class TasksLoading extends TaskState {}

class TasksLoaded extends TaskState {
  List<Task> tasks;

  TasksLoaded({this.tasks});
}

class TasksNotLoaded extends TaskState {}

// bloc

class TasksBloc extends Bloc<TaskEvent, TaskState> {
  final FirebaseRepository _repository;
  StreamSubscription _tasksSubscription;

  TasksBloc({@required FirebaseRepository repository})
      : assert(repository != null),
        _repository = repository,
        super(TasksLoading());

  @override
  Stream<TaskState> mapEventToState(TaskEvent event) async* {
    if (event is LoadTasks) {
      yield* _mapLoadTasksToState();
    } else if (event is AddTask) {
      yield* _mapAddTaskToState(event);
    } else if (event is UpdateTask) {
      yield* _mapUpdateTaskToState(event);
    } else if (event is DeleteTask) {
      yield* _mapDeleteTaskToState(event);
    } else if (event is TasksUpdated) {
      yield* _mapTasksUpdateToState(event);
    }
  }

  Stream<TaskState> _mapLoadTasksToState() async* {
    _tasksSubscription?.cancel();
    _tasksSubscription = _repository.tasks().listen(
          (tasks) => add(TasksUpdated(tasks: tasks)),
        );
  }

  Stream<TaskState> _mapAddTaskToState(AddTask event) async* {
    _repository.addNewTask(event.task);
  }

  Stream<TaskState> _mapUpdateTaskToState(UpdateTask event) async* {
    _repository.updateTask(event.task);
  }

  Stream<TaskState> _mapDeleteTaskToState(DeleteTask event) async* {
    _repository.deleteTask(event.task);
  }

  Stream<TaskState> _mapTasksUpdateToState(TasksUpdated event) async* {
    yield TasksLoaded(tasks: event.tasks);
  }

  @override
  Future<void> close() {
    _tasksSubscription?.cancel();
    return super.close();
  }
}
