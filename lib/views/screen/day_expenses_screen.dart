import 'package:expense_tracker/widgets/expense_item.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../viewmodels/expense_viewmodel.dart';

class DayExpensesScreen extends StatelessWidget {
  final DateTime date;

  const DayExpensesScreen({super.key, required this.date});

  @override
  Widget build(BuildContext context) {
    final expenseVM = context.watch<ExpenseViewModel>();

    // 🔹 Filter expenses for this day
    final dayExpenses = expenseVM.expenses.where((e) {
      return e.date.year == date.year &&
          e.date.month == date.month &&
          e.date.day == date.day;
    }).toList();

    // 🔹 Calculate total
    final total = dayExpenses.fold<double>(0, (sum, e) => sum + e.amount);

    return Scaffold(
      appBar: AppBar(title: Text(DateFormat('dd MMM yyyy').format(date))),

      body: Column(
        children: [
          // =======================
          // 🔹 DAY SUMMARY CARD
          // =======================
          Card(
            margin: const EdgeInsets.all(14),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const Icon(Icons.calendar_today, size: 28),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        DateFormat('EEEE').format(date),
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '₹ ${total.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const Divider(height: 1),

          // =======================
          // 🔹 EXPENSE LIST
          // =======================
          Expanded(
            child: dayExpenses.isEmpty
                ? const Center(
                    child: Text(
                      'No expenses for this day',
                      style: TextStyle(fontSize: 16),
                    ),
                  )
                : ListView.builder(
                    itemCount: dayExpenses.length,
                    itemBuilder: (context, index) {
                      return ExpenseItem(expense: dayExpenses[index]);
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
