import 'package:flutter/material.dart';
import 'package:flutter_sqflite_app/Helpers/DrawerNavigation.dart';
import 'package:flutter_sqflite_app/Screens/TodoScreen.dart';
import 'package:flutter_sqflite_app/service/Todos.dart';
import 'package:flutter_sqflite_app/service/todoService.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TodoService todoService = TodoService();
  List<Todos> todoList = List<Todos>();

  getAllData() async {
    var todoData = await todoService.readTodo();
    todoData.forEach((value) {
      setState(() {
        Todos todos = Todos();
        todos.id = value['id'];
        todos.title = value['title'];
        todos.description = value['description'];
        todos.category = value['category'];
        todos.todoDate = value['todoDate'];
        todos.isFinished = value['isFinished'];

        todoList.add(todos);
      });
    });
  }

  @override
  void initState() {
    super.initState();
    getAllData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Demo App Sqflite"),
      ),
      body: ListView.builder(
        itemCount: todoList.length,
        itemBuilder: (context, index) {
          return Card(
            elevation: 8,
            child: ListTile(
              title: Text(todoList[index].title),
              subtitle: Text(todoList[index].category),
              trailing: Text(todoList[index].todoDate),
            ),
          );
        },
      ),
      drawer: DrawerNavigation(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => TodoScreen()));
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
