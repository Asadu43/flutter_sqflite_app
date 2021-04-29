import 'package:flutter/material.dart';
import 'package:flutter_sqflite_app/database/repository.dart';
import 'package:flutter_sqflite_app/service/Todos.dart';

class TodoService{

  Repository repository = Repository();

  saveTodo(Todos todos)async{
    return await repository.insertData('Todos', todos.todoMap());
  }

  readTodo() async{

    return await repository.readData('Todos');
  }

}