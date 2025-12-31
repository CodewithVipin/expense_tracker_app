import 'package:expense_tracker/widgets/expense_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../viewmodels/expense_viewmodel.dart';

class TodayExpensesScreen extends StatelessWidget {
  const TodayExpensesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final expenseVM = context.watch<ExpenseViewModel>();

    // 🔹 Filter today's expenses
    final now = DateTime.now();
    final todayExpenses = expenseVM.expenses.where((e) {
      return e.date.year == now.year &&
          e.date.month == now.month &&
          e.date.day == now.day;
    }).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Today’s Expenses')),

      body: todayExpenses.isEmpty
          ? const Center(
              child: Text(
                'No expenses added today',
                style: TextStyle(fontSize: 16),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.only(bottom: 16),
              itemCount: todayExpenses.length,
              itemBuilder: (context, index) {
                return ExpenseItem(expense: todayExpenses[index]);
              },
            ),
    );
  }
}
