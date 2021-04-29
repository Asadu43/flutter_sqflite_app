
import 'package:flutter_sqflite_app/database/database_connection.dart';
import 'package:flutter_sqflite_app/service/Todos.dart';
import 'package:sqflite/sqflite.dart';

class Repository{

  DatabaseConnection _databaseConnection;

  Repository(){
    _databaseConnection = DatabaseConnection();
}

static Database _database;
  Future<Database> get database async{
    if(_database != null) return _database;
     _database = await _databaseConnection.setDatabase();
     return _database;

  }
   insertData(table, data) async{
    print('inserting: $data.................................');
    var connection = await database;
    return await connection.insert(table, data);
   }
  readData(table) async{
    var connection = await database;
    return await connection.query(table);
  }

  Future<List<Map<String, dynamic>>> readDataById(table,itemId) async{
    var connection = await database;
    return await connection.query(table,where: 'id=?',whereArgs: [itemId]);
  }

  Future<int> updateData(table ,Map<String, dynamic> data) async {
    var connection = await database;
    int id = data['id'];
    data.remove('id');
    return await connection.update(table, data ,where:'id=$id');
  }

  deleteData(table , itemId) async{
    var connection = await database;
    return await connection.rawDelete('DELETE FROM $table WHERE id = $itemId');
  }

}