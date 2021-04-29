import 'package:flutter_sqflite_app/database/repository.dart';
import 'package:flutter_sqflite_app/service/Category.dart';

class CategoryService {
  Repository repository;

  CategoryService() {
    repository = Repository();
  }

  saveCategory(Category category) async {
    return await repository.insertData('category', category.categoryMap());
  }
  readCategory()async{
     return await repository.readData('category');
  }

  Future<List<Map<String, dynamic>>> readCategoryId(categoryId) async {
    return await repository.readDataById('category', categoryId);
  }

  Future<int> updateCategory(Category category) async {
    print('update: ${category.categoryMap()}...........................................');
    return await repository.updateData('category',category.categoryMap());
  }

  deleteCategory(categoryId) async {

    return await repository.deleteData('category', categoryId);
  }
}
