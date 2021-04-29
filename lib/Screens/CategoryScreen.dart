import 'package:flutter/material.dart';
import 'package:flutter_sqflite_app/service/Category.dart';
import 'package:flutter_sqflite_app/service/CategoryService.dart';

class CategoryScreen extends StatefulWidget {
  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  TextEditingController nameTextEditingController = TextEditingController();
  TextEditingController decTextEditingController = TextEditingController();
  TextEditingController editNameTextEditingController = TextEditingController();
  TextEditingController editDecTextEditingController = TextEditingController();
  var _category = Category();

  List<Map<String, dynamic>> category;
  var categoryService = CategoryService();

  List<Category> _categoryList = List<Category>();

  getAllData() async {
    // categoryList = List<Category>();
    var categories = await categoryService.readCategory();
    categories.forEach((category) {
      setState(() {
        var categoryModel = Category();
        categoryModel.id = category['id'];
        categoryModel.name = category['name'];
        categoryModel.description = category['description'];
        _categoryList.add(categoryModel);
      });
    });
  }

  editCategoryById(BuildContext context, categoryId) async {

    category = await categoryService.readCategoryId(categoryId);
    print('read: ${category[0]}');
    setState(() {
      editNameTextEditingController.text = category[0]['name'] ?? 'no name';
      editDecTextEditingController.text =
          category[0]['description'] ?? 'no description';
    });

    _editShowDialog(context);
  }

  _showDialog(BuildContext context) {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return AlertDialog(
          title: Text("Categories Form"),
          actions: [
            FlatButton(
              onPressed: () {
                Navigator.pop(context);
              },
              color: Colors.red,
              child: Text("CANCEL"),
            ),
            FlatButton(
                onPressed: () async {
                  // _category.name = nameTextEditingController.text;
                  // _category.description = decTextEditingController.text;
                  Category cat = Category();
                  cat.name = nameTextEditingController.text;
                  cat.description = decTextEditingController.text;
                  var result = await categoryService.saveCategory(cat);
                  print(result);

                  if(result > 0)
                    Navigator.pop(context);
                  _categoryList = [];
                  getAllData();
                  _showSnackBar(Text('Save Successfully'));

                  nameTextEditingController.clear();
                  decTextEditingController.clear();
                },
                color: Colors.indigo,
                child: Text("SAVE")),
          ],
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: nameTextEditingController,
                  decoration: InputDecoration(
                    labelText: "Category",
                    hintText: "write a category",
                  ),
                ),
                TextField(
                  controller: decTextEditingController,
                  decoration: InputDecoration(
                    labelText: "Description",
                    hintText: "write a description",
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  _editShowDialog(BuildContext context) {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return AlertDialog(
          title: Text("Edit Categories Form"),
          actions: [
            FlatButton(
              onPressed: () {
                Navigator.pop(context);
              },
              color: Colors.red,
              child: Text("CANCEL"),
            ),
            FlatButton(
                onPressed: () async {
                  _category.id = category[0]['id'];
                  _category.name = editNameTextEditingController.text;
                  _category.description = editDecTextEditingController.text;
                  var result = await categoryService.updateCategory(_category);
                  print(result);
                  if(result > 0) {
                    Navigator.pop(context);
                    _categoryList = [];
                    getAllData();
                    _showSnackBar(Text('Updated Successfully'));
                  }
                },
                color: Colors.indigo,
                child: Text("Update")),
          ],
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: editNameTextEditingController,
                  decoration: InputDecoration(
                    labelText: "Category",
                    hintText: "write a category",
                  ),
                ),
                TextField(
                  controller: editDecTextEditingController,
                  decoration: InputDecoration(
                    labelText: "Description",
                    hintText: "write a description",
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  _deleteShowDialog(BuildContext context, categoryId) {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return AlertDialog(
          title: Text("Are you sure you want to delete this?"),
          actions: [
            FlatButton(
              onPressed: () {
                Navigator.pop(context);
              },
              color: Colors.green,
              child: Text("CANCEL"),
            ),
            FlatButton(
                onPressed: () async {

                  var result = await categoryService.deleteCategory(categoryId);
                  print(result);
                  if(result > 0) {
                    Navigator.pop(context);
                    _categoryList = [];
                    getAllData();
                    _showSnackBar(Text('Delete Successfully'));
                  }
                },
                color: Colors.red,
                child: Text("Delete")),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    getAllData();
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
        title: Text("Categories"),
      ),
      body: ListView.builder(
        itemCount: _categoryList.length,
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              leading: IconButton(
                icon: Icon(Icons.edit),
                onPressed: () {
                  editCategoryById(context, _categoryList[index].id);
                },
              ),
              trailing: IconButton(
                icon: Icon(
                  Icons.delete,
                  color: Colors.red,
                ), onPressed: () {
                  _deleteShowDialog(context, _categoryList[index].id);
              },
              ),
              title: Text(_categoryList[index].name),
              subtitle: Text(_categoryList[index].description),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showDialog(context);
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
