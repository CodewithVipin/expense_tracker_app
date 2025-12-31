import '../database/app_database.dart';
import '../models/expense_model.dart';

class ExpenseService {
  final _db = AppDatabase();
  // 📅 DAILY SUMMARY
  Future<List<Map<String, dynamic>>> getDailySummary() async {
    final db = await _db.database;
    return await db.rawQuery('''
    SELECT date(date) AS period, SUM(amount) AS total
    FROM expenses
    GROUP BY period
    ORDER BY period DESC
  ''');
  }

  // 📆 MONTHLY SUMMARY
  Future<List<Map<String, dynamic>>> getMonthlySummary() async {
    final db = await _db.database;
    return await db.rawQuery('''
    SELECT strftime('%Y-%m', date) AS period, SUM(amount) AS total
    FROM expenses
    GROUP BY period
    ORDER BY period DESC
  ''');
  }

  // 🗓️ YEARLY SUMMARY
  Future<List<Map<String, dynamic>>> getYearlySummary() async {
    final db = await _db.database;
    return await db.rawQuery('''
    SELECT strftime('%Y', date) AS period, SUM(amount) AS total
    FROM expenses
    GROUP BY period
    ORDER BY period DESC
  ''');
  }

  Future<double> getThisMonthTotal() async {
    final db = await _db.database;

    final result = await db.rawQuery('''
    SELECT SUM(amount) AS total
    FROM expenses
    WHERE strftime('%Y-%m', date) = strftime('%Y-%m', 'now')
  ''');

    return result.first['total'] == null ? 0 : result.first['total'] as double;
  }

  Future<double> getYesterdayTotal() async {
    final db = await _db.database;

    final result = await db.rawQuery('''
    SELECT SUM(amount) AS total
    FROM expenses
    WHERE date(date) = date('now', '-1 day')
  ''');

    return result.first['total'] == null ? 0 : result.first['total'] as double;
  }

  Future<List<Expense>> getExpenses() async {
    final db = await _db.database;
    final result = await db.query('expenses', orderBy: 'date DESC');
    return result.map((e) => Expense.fromMap(e)).toList();
  }

  Future<void> addExpense(Expense expense) async {
    final db = await _db.database;
    await db.insert('expenses', expense.toMap());
  }

  Future<double> getTodayTotal() async {
    final db = await _db.database;

    final result = await db.rawQuery('''
    SELECT SUM(amount) AS total
    FROM expenses
    WHERE date(date) = date('now')
  ''');

    return result.first['total'] == null ? 0 : result.first['total'] as double;
  }

  Future<void> deleteExpense(int id) async {
    final db = await _db.database;
    await db.delete('expenses', where: 'id = ?', whereArgs: [id]);
  }

  Future<double> getTotalExpense() async {
    final db = await _db.database;
    final result = await db.rawQuery(
      'SELECT SUM(amount) AS total FROM expenses',
    );

    return result.first['total'] == null ? 0 : result.first['total'] as double;
  }
}
