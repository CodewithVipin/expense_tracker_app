import 'package:sqflite/sqflite.dart';
import '../database/app_database.dart';
import '../models/category_model.dart';

class CategoryService {
  final _db = AppDatabase();

  Future<List<Category>> getCategories() async {
    final db = await _db.database;
    final result = await db.query('categories');
    return result.map((e) => Category.fromMap(e)).toList();
  }

  Future<void> addCategory(String name) async {
    final db = await _db.database;
    await db.insert('categories', {
      'name': name,
    }, conflictAlgorithm: ConflictAlgorithm.ignore);
  }

  Future<void> updateCategory(int id, String newName) async {
    final db = await _db.database;
    await db.update(
      'categories',
      {'name': newName},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<bool> deleteCategory(int id, String name) async {
    final used = await isCategoryUsed(name);
    if (used) return false;

    final db = await _db.database;
    await db.delete('categories', where: 'id = ?', whereArgs: [id]);
    return true;
  }

  Future<bool> isCategoryUsed(String name) async {
    final db = await _db.database;

    final result = await db.rawQuery(
      'SELECT COUNT(*) FROM expenses WHERE category = ?',
      [name],
    );

    return Sqflite.firstIntValue(result)! > 0;
  }
}
