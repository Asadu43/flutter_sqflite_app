import 'package:flutter/material.dart';
import 'package:flutter_sqflite_app/service/CategoryService.dart';
import 'package:flutter_sqflite_app/service/Todos.dart';
import 'package:flutter_sqflite_app/service/todoService.dart';
import 'package:intl/intl.dart';

class TodoScreen extends StatefulWidget {
  @override
  _TodoScreenState createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  TextEditingController todoTitleTextEditingController = TextEditingController();
  TextEditingController todoDesTextEditingController = TextEditingController();
  TextEditingController todoDateTextEditingController = TextEditingController();

  var _selectCategories;
  var _categories = List<DropdownMenuItem>();

  _loadCategories() async {
    CategoryService categoryService = CategoryService();
    var category = await categoryService.readCategory();

    category.forEach((val) {
      setState(() {
        _categories.add(DropdownMenuItem(
          child: Text(val['name']),
          value: val['name'],
        ));
      });
    });
  }

  DateTime dateTime = DateTime.now();

  selectPickDate(BuildContext context) async {
    var _pickDate = await showDatePicker(
        context: context, initialDate: dateTime, firstDate: DateTime(2000), lastDate: DateTime(2100));
    if(_pickDate != null){
      setState(() {
        dateTime = _pickDate;
        todoDateTextEditingController.text  = DateFormat('yyyy-MM-dd').format(_pickDate);
      });
    }
  }


  @override
  void initState() {
    super.initState();
    _loadCategories();
  }
  GlobalKey<ScaffoldState> _globalKey =GlobalKey<ScaffoldState>();
  _showSnackBar(message){
    SnackBar snackBar = SnackBar(content: message);
    _globalKey.currentState.showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _globalKey,
      appBar: AppBar(
        title: Text('Todo Screen'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: [
            TextField(
              controller: todoTitleTextEditingController,
              decoration: InputDecoration(
                labelText: 'Title',
                hintText: 'Enter title',
              ),
            ),
            TextField(
              controller: todoDesTextEditingController,
              decoration: InputDecoration(
                labelText: 'Description',
                hintText: 'Enter description',
              ),
            ),
            TextField(
              controller: todoDateTextEditingController,
              decoration: InputDecoration(
                labelText: 'Date',
                hintText: 'Pick a Date',
                prefixIcon: InkWell(onTap: (){
                  selectPickDate(context);
                },child: Icon(Icons.calendar_today_outlined)),
              ),
            ),
            DropdownButtonFormField(
              items: _categories,
              value: _selectCategories,
              hint: Text('Categories'),
              onChanged: (value) {
                setState(() {
                  _selectCategories = value;
                });
              },
            ),
            SizedBox(
              height: 30.0,
            ),
            FlatButton(
              onPressed: () async{

                var todoObject = Todos();

                todoObject.title = todoTitleTextEditingController.text;
                todoObject.description = todoDesTextEditingController.text;
                todoObject.todoDate = todoDateTextEditingController.text;
                todoObject.isFinished = 0;
                todoObject.category = _selectCategories.toString();
                TodoService todoService = TodoService();
                var result = await todoService.saveTodo(todoObject);
                print('Result $result...............................');

                if(result > 0)
                  _showSnackBar(Text("Successfully Date Added"));
                todoTitleTextEditingController.clear();
                todoDesTextEditingController.clear();
                todoDateTextEditingController.clear();

              },
              child: Text('Save', style: TextStyle(color: Colors.white)),
              color: Colors.indigo,
            ),
          ],
        ),
      ),
    );
  }
}
