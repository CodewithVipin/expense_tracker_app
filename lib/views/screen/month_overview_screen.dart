// ignore_for_file: unnecessary_underscores, deprecated_member_use

import 'package:expense_tracker/views/screen/day_expenses_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../viewmodels/expense_viewmodel.dart';

class MonthOverviewScreen extends StatelessWidget {
  final int year;
  final int month;

  const MonthOverviewScreen({
    super.key,
    required this.year,
    required this.month,
  });

  @override
  Widget build(BuildContext context) {
    final expenseVM = context.watch<ExpenseViewModel>();
    final monthDate = DateTime(year, month);

    // 🔹 Group expenses by day (FOR SELECTED MONTH)
    final Map<DateTime, double> dailyTotals = {};

    for (final e in expenseVM.expenses) {
      if (e.date.year == year && e.date.month == month) {
        final dayKey = DateTime(e.date.year, e.date.month, e.date.day);
        dailyTotals[dayKey] = (dailyTotals[dayKey] ?? 0) + e.amount;
      }
    }

    // 🔹 Sort days (latest first)
    final days = dailyTotals.keys.toList()..sort((a, b) => b.compareTo(a));

    return Scaffold(
      appBar: AppBar(title: Text(DateFormat('MMMM yyyy').format(monthDate))),

      body: days.isEmpty
          ? const Center(
              child: Text(
                'No expenses this month',
                style: TextStyle(fontSize: 16),
              ),
            )
          : ListView.separated(
              itemCount: days.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final date = days[index];
                final amount = dailyTotals[date]!;

                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Theme.of(
                      context,
                    ).colorScheme.primary.withOpacity(0.1),
                    child: Text(
                      date.day.toString(),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  title: Text(DateFormat('EEEE').format(date)),
                  subtitle: Text(DateFormat('dd MMM yyyy').format(date)),
                  trailing: Text(
                    '₹ ${amount.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => DayExpensesScreen(date: date),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
