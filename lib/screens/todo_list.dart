import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:todo_crud/screens/add_todo_page.dart';
import 'package:http/http.dart' as http;

class TodoList extends StatefulWidget {
  const TodoList({super.key});

  @override
  State<TodoList> createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  bool isLoading = true;
  var todoList = [];
  @override
  void initState() {
    super.initState();
    fetchTodoList();
  }

  Future<void> fetchTodoList() async {
    final url = Uri.parse("http://localhost:3000/tasks");
    final uri = await http.get(url);
    if (uri.statusCode == 200) {
      final response = jsonDecode(uri.body);
      setState(() {
        todoList = response;
      });
    } else {
      print("Some thing went wrong");
    }
    setState(() {
      isLoading = false;
    });
  }

  Future<void> deleteById(int id) async {
    print(id);
    final uri = Uri.parse("http://localhost:3000/tasks/$id");
    final response = await http.delete(uri);
    if (response.statusCode == 200) {
      showSuccessMessage("Record Deleted");
      final filtered =
          todoList.where((element) => element['id'] != id).toList();
      setState(() {
        todoList = filtered;
      });
    }
  }

  void showSuccessMessage(String message) {
    final snackBar = SnackBar(
      content: Text(
        message,
      ),
      backgroundColor: Colors.greenAccent.shade400,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void navigateToAddTodo() {
    final route = MaterialPageRoute(builder: (context) => AddTodo());
    Navigator.push(context, route);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Todo List"),
      ),
      body: Visibility(
        visible: isLoading,
        child: Center(
          child: CircularProgressIndicator(),
        ),
        replacement: RefreshIndicator(
          onRefresh: fetchTodoList,
          child: ListView.builder(
            itemBuilder: (context, index) {
              final id = todoList[index]['id'];

              return ListTile(
                leading: CircleAvatar(child: Text('${todoList[index]['id']}')),
                title: Text(
                  '${todoList[index]['title']}',
                ),
                subtitle: Text('${todoList[index]['desc']}'),
                trailing: PopupMenuButton(
                  onSelected: (value) {
                    if (value == 'edit') {
                    } else if (value == 'delete') {
                      deleteById(id);
                      // print(id);
                    }
                  },
                  itemBuilder: (context) {
                    return [
                      PopupMenuItem(child: Text('Edit'), value: 'edit'),
                      PopupMenuItem(
                        child: Text('Delete'),
                        value: 'delete',
                      )
                    ];
                  },
                ),
              );
            },
            itemCount: todoList.length,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: navigateToAddTodo, label: Text("Add Todo")),
    );
  }
}
