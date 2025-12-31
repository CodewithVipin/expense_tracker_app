import 'package:flutter/material.dart';

import '../models/expense_model.dart';
import '../services/expense_service.dart';
import '../services/settings_service.dart';

class ExpenseViewModel extends ChangeNotifier {
  final ExpenseService _service = ExpenseService();
  final SettingsService _settingsService = SettingsService();

  // =========================
  // 🔹 EXPENSE LIST
  // =========================
  List<Expense> _expenses = [];
  List<Expense> get expenses => _expenses;

  // =========================
  // 🔹 MONTHLY BUDGET
  // =========================
  double _monthlyBudget = 0;
  double get monthlyBudget => _monthlyBudget;

  /// Load budget from DB (call once on startup)
  Future<void> loadMonthlyBudget() async {
    final budget = await _settingsService.getMonthlyBudget();
    debugPrint('📥 Loaded budget from DB: $budget');
    _monthlyBudget = budget;
    notifyListeners();
  }

  /// Update + persist budget
  Future<void> updateMonthlyBudget(double value) async {
    debugPrint('💾 Saving budget: $value');
    _monthlyBudget = value;
    await _settingsService.saveMonthlyBudget(value);
    notifyListeners();
  }

  // =========================
  // 🔹 LOAD EXPENSES
  // =========================
  Future<void> loadExpenses() async {
    _expenses = await _service.getExpenses();
    notifyListeners();
  }

  // =========================
  // 🔹 ADD EXPENSE (BACK DATE SUPPORT)
  // =========================
  Future<void> addExpense(
    String category,
    double amount, {
    required DateTime date,
  }) async {
    final expense = Expense(category: category, amount: amount, date: date);

    await _service.addExpense(expense);
    await loadExpenses();
  }

  // =========================
  // 🔹 DELETE EXPENSE
  // =========================
  Future<void> deleteExpense(int id) async {
    await _service.deleteExpense(id);
    await loadExpenses();
  }

  // =========================
  // 🔹 TOTAL CALCULATIONS
  // =========================
  double get todayTotal {
    final now = DateTime.now();
    return _expenses
        .where(
          (e) =>
              e.date.year == now.year &&
              e.date.month == now.month &&
              e.date.day == now.day,
        )
        .fold(0, (sum, e) => sum + e.amount);
  }

  double get yesterdayTotal {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return _expenses
        .where(
          (e) =>
              e.date.year == yesterday.year &&
              e.date.month == yesterday.month &&
              e.date.day == yesterday.day,
        )
        .fold(0, (sum, e) => sum + e.amount);
  }

  double get monthTotal {
    final now = DateTime.now();
    return _expenses
        .where((e) => e.date.year == now.year && e.date.month == now.month)
        .fold(0, (sum, e) => sum + e.amount);
  }

  double get yearTotal {
    final now = DateTime.now();
    return _expenses
        .where((e) => e.date.year == now.year)
        .fold(0, (sum, e) => sum + e.amount);
  }

  // =========================
  // 🔹 BUDGET WARNING
  // =========================
  bool get isMonthlyBudgetExceeded {
    if (_monthlyBudget <= 0) return false;
    return monthTotal > _monthlyBudget;
  }
}
