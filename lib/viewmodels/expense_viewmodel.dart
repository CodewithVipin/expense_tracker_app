import 'package:expense_tracker/services/settings_service.dart';
import 'package:flutter/material.dart';

import '../models/expense_model.dart';
import '../services/expense_service.dart';
import '../utils/summary_type.dart';

class ExpenseViewModel extends ChangeNotifier {
  // ✅ SERVICE DEFINED
  final ExpenseService _service = ExpenseService();
  double _todayTotal = 0;
  double get todayTotal => _todayTotal;
  double _yesterdayTotal = 0;
  double get yesterdayTotal => _yesterdayTotal;
  double _monthTotal = 0;
  double get monthTotal => _monthTotal;
  double _monthlyBudget = 0;
  double get monthlyBudget => _monthlyBudget;

  bool get isMonthlyBudgetExceeded =>
      _monthlyBudget > 0 && monthTotal > _monthlyBudget;

  // --------------------
  // Daily Budget Logic
  // --------------------
  double dailyBudget = 500; // you can change this anytime

  bool get isDailyBudgetExceeded => todayTotal > dailyBudget;

  // STATE
  List<Expense> _expenses = [];
  double _totalExpense = 0;
  List<Map<String, dynamic>> _summary = [];

  // GETTERS
  List<Expense> get expenses => _expenses;
  double get totalExpense => _totalExpense;
  List<Map<String, dynamic>> get summary => _summary;

  // CONSTRUCTOR
  ExpenseViewModel() {
    loadExpenses();
    loadMonthlyBudget();
  }
  final SettingsService _settingsService = SettingsService();

  Future<void> loadMonthlyBudget() async {
    _monthlyBudget = await _settingsService.getMonthlyBudget();
    notifyListeners();
  }

  Future<void> updateMonthlyBudget(double value) async {
    _monthlyBudget = value;
    await _settingsService.saveMonthlyBudget(value);
    notifyListeners();
  }

  // LOAD ALL EXPENSES
  Future<void> loadExpenses() async {
    _expenses = await _service.getExpenses();
    _totalExpense = await _service.getTotalExpense();
    _todayTotal = await _service.getTodayTotal();
    _yesterdayTotal = await _service.getYesterdayTotal();
    _monthTotal = await _service.getThisMonthTotal();
    notifyListeners();
  }

  // ADD EXPENSE
  Future<void> addExpense(String title, double amount) async {
    await _service.addExpense(
      Expense(title: title, amount: amount, date: DateTime.now()),
    );
    await loadExpenses();
  }

  // DELETE EXPENSE
  Future<void> deleteExpense(int id) async {
    await _service.deleteExpense(id);
    await loadExpenses();
  }

  // 📊 LOAD SUMMARY (DAILY / MONTHLY / YEARLY)
  Future<void> loadSummary(SummaryType type) async {
    switch (type) {
      case SummaryType.daily:
        _summary = await _service.getDailySummary();
        break;

      case SummaryType.monthly:
        _summary = await _service.getMonthlySummary();
        break;

      case SummaryType.yearly:
        _summary = await _service.getYearlySummary();
        break;
    }
    notifyListeners();
  }
}
