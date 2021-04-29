import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseConnection{

  setDatabase() async{
     var directory = await getApplicationDocumentsDirectory();
     var path = join(directory.path, "db_todolist");
     var database = await openDatabase(path, version: 1,onCreate: onCreateDatabase);

     return database;
  }
  onCreateDatabase(Database database, int version) async{
    await database.execute('CREATE TABLE category(id INTEGER PRIMARY KEY,name TEXT,description TEXT)');

    await database.execute('CREATE TABLE Todos(id INTEGER PRIMARY KEY,title TEXT,description TEXT,todoDate TEXT,category TEXT,isFinished INTEGER)');

  }
}