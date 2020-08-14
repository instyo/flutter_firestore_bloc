import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_firebase/models/Task.dart';
import 'package:flutter_firebase/pages/add/TaskFormUI.dart';
import 'package:flutter_firebase/pages/home/home.bloc.dart';
import 'package:flutter_firebase/repository/firebase_repository.dart';

class HomeUI extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    FirebaseRepository firebaseRepository = FirebaseRepository();
    return BlocProvider(
      create: (context) =>
          TasksBloc(repository: firebaseRepository)..add(LoadTasks()),
      child: HomeBody(),
    );
  }
}

class HomeBody extends StatefulWidget {
  @override
  _HomeBodyState createState() => _HomeBodyState();
}

class _HomeBodyState extends State<HomeBody> {
  TasksBloc bloc;

  @override
  void initState() {
    super.initState();
    bloc = BlocProvider.of<TasksBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.create),
              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TaskFormUI(),
                  ),
                );
                if (result != null) {
                  bloc.add(AddTask(task: result));
                }
              })
        ],
      ),
      body: Container(
          height: double.maxFinite,
          width: double.maxFinite,
          color: Colors.white,
          child: BlocBuilder<TasksBloc, TaskState>(
            builder: (context, state) {
              if (state is TasksLoading) {
                return Center(
                  child: CupertinoActivityIndicator(),
                );
              } else if (state is TasksLoaded) {
                final tasks = state.tasks;
                return tasks.length > 0
                    ? ListView.builder(
                        itemCount: tasks.length,
                        itemBuilder: (context, index) {
                          final task = tasks[index];
                          return ListTile(
                            onTap: () async {
                              final result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => TaskFormUI(
                                    task: task,
                                  ),
                                ),
                              ) as Task;
                              if (result != null) {
                                print(result.toEntity().toJson());
                                bloc.add(UpdateTask(task: result));
                              }
                            },
                            onLongPress: () async {
                              bloc.add(DeleteTask(task: task));
                            },
                            title: Text("${task.title}"),
                            subtitle: Text("${task.description}"),
                          );
                        },
                      )
                    : Center(
                        child: Text("No Task Created!"),
                      );
              } else {
                return Container();
              }
            },
          )),
    );
  }
}
