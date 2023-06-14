import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:todo_crud/screens/todo_list.dart';

class AddTodo extends StatefulWidget {
  final Map? todo;
  const AddTodo({super.key, this.todo});

  @override
  State<AddTodo> createState() => _AddTodoState();
}

class _AddTodoState extends State<AddTodo> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descController = TextEditingController();

  bool isEdit = false;

  @override
  void initState() {
    super.initState();

    final todo = widget.todo;
    if (todo != null) {
      isEdit = true;
      final title = todo['title'];
      final desc = todo['desc'];
      titleController.text = title;
      descController.text = desc;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? "Edit Todo" : "Add Todo"),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: titleController,
              decoration: InputDecoration(hintText: "Add Task"),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: descController,
              decoration: InputDecoration(
                hintText: "Enter Discruption",
              ),
              minLines: 3,
              maxLines: 8,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
                onPressed: isEdit ? updateTodo : addTodo,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text(isEdit ? "Update" : "Create"),
                )),
          )
        ],
      ),
    );
  }

  Future<void> updateTodo() async {
    final todo = widget.todo;
    // final id = todo;
    if (todo != null) {
      final id = todo['id'];
      final obj = {"title": titleController.text, "desc": descController.text};
      print(obj);
      final uri = Uri.parse("http://localhost:3000/tasks/$id");
      final response = await http.put(uri,
          body: jsonEncode(obj), headers: {'Content-Type': 'application/json'});
      if (response.statusCode == 200) {
        showSuccessMessage("Data updated");
      } else {
        showErrorMessage("Updating Failed");
      }
    }
  }

  void addTodo() async {
    final url = Uri.parse("http://localhost:3000/tasks");
    final obj = {"title": titleController.text, "desc": descController.text};
    final response = await http.post(url,
        body: jsonEncode(obj), headers: {'Content-Type': "application/json"});
    if (response.statusCode == 201) {
      titleController.text = '';
      descController.text = '';
      showSuccessMessage("Todo Created");
      // print("Todo Created.");
      // final route = MaterialPageRoute(builder: (context) => TodoList());
      // Navigator.push(context, route);
    } else {
      showErrorMessage("Some thing wrong");
    }
  }

  void showErrorMessage(String message) {
    final snackBar = SnackBar(
      content: Text(message),
      backgroundColor: Colors.red,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void showSuccessMessage(String message) {
    final snackBar = SnackBar(
      content: Text(message),
      backgroundColor: Colors.green,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
