import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:todo_crud/screens/todo_list.dart';

class AddTodo extends StatefulWidget {
  const AddTodo({super.key});

  @override
  State<AddTodo> createState() => _AddTodoState();
}

class _AddTodoState extends State<AddTodo> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Todo"),
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
            child: ElevatedButton(onPressed: addTodo, child: Text("Submit")),
          )
        ],
      ),
    );
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
      print("Some thing wrong");
    }
  }

  void showSuccessMessage(String message) {
    final snackBar = SnackBar(
      content: Text(message),
      backgroundColor: Colors.green,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
