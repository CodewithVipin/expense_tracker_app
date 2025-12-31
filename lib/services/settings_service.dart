import 'package:sqflite/sqflite.dart';

import '../database/app_database.dart';

class SettingsService {
  final _db = AppDatabase();

  Future<void> saveLastCategory(String value) async {
    final db = await _db.database;
    await db.insert('settings', {
      'key': 'last_category',
      'value': value,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<double> getMonthlyBudget() async {
    final db = await _db.database;
    final result = await db.query(
      'settings',
      where: 'key = ?',
      whereArgs: ['monthly_budget'],
    );

    if (result.isEmpty) return 0;
    return double.tryParse(result.first['value'] as String) ?? 0;
  }

  Future<void> saveMonthlyBudget(double amount) async {
    final db = await _db.database;
    await db.insert('settings', {
      'key': 'monthly_budget',
      'value': amount.toString(),
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<String?> getLastCategory() async {
    final db = await _db.database;
    final result = await db.query(
      'settings',
      where: 'key = ?',
      whereArgs: ['last_category'],
    );

    return result.isEmpty ? null : result.first['value'] as String;
  }
}
