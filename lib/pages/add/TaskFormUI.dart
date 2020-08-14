import 'package:flutter/material.dart';
import 'package:flutter_firebase/models/Task.dart';
import 'package:intl/intl.dart';

class TaskFormUI extends StatefulWidget {
  final Task task;
  TaskFormUI({this.task});

  @override
  _TaskFormUIState createState() => _TaskFormUIState();
}

class _TaskFormUIState extends State<TaskFormUI> {
  final TextEditingController _title = TextEditingController();
  final TextEditingController _description = TextEditingController();
  final TextEditingController _date = TextEditingController();
  DateTime date = DateTime.now().add(Duration(days: 1));

  @override
  void initState() {
    super.initState();
    if (widget.task != null) {
      _title.text = widget.task.title;
      _description.text = widget.task.description;
      date = DateFormat('dd MMMM yyyy').parse(widget.task.date);
      _date.text = widget.task.date;
    } else {
      _date.text = DateFormat('dd MMMM yyyy').format(date);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.task != null ? "Edit Task" : "Create Task"),
      ),
      body: Container(
        height: double.maxFinite,
        width: double.maxFinite,
        color: Colors.white,
        padding: EdgeInsets.all(15),
        child: ListView(
          children: <Widget>[
            TextField(
              controller: _title,
              decoration: InputDecoration(hintText: "Task Name"),
            ),
            TextField(
              controller: _description,
              decoration: InputDecoration(
                hintText: "Task Description",
              ),
              maxLines: 3,
            ),
            TextField(
              controller: _date,
              decoration: InputDecoration(
                labelText: 'Date',
                suffixIcon: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Icon(Icons.today),
                  ],
                ),
              ),
              style: TextStyle(fontSize: 18.0),
              readOnly: true,
              onTap: () async {
                DateTime today = DateTime.now();
                DateTime datePicker = await showDatePicker(
                  context: context,
                  initialDate: date,
                  firstDate: today,
                  lastDate: DateTime(2021),
                );
                if (datePicker != null) {
                  date = datePicker;
                  _date.text = DateFormat('dd MMMM yyyy').format(date);
                }
              },
            ),
            FlatButton(
              onPressed: () {
                Task task = Task(
                  id: widget.task != null ? widget.task.id : null,
                  title: _title.value.text,
                  description: _description.value.text,
                  date: _date.value.text,
                );
                Navigator.pop(context, task);
              },
              child: Text("Simpan"),
            )
          ],
        ),
      ),
    );
  }
}
