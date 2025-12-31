// ignore_for_file: deprecated_member_use, unnecessary_underscores

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../viewmodels/expense_viewmodel.dart';
import 'month_overview_screen.dart';

class YearOverviewScreen extends StatelessWidget {
  final int year;
  const YearOverviewScreen({super.key, required this.year});

  @override
  Widget build(BuildContext context) {
    final expenseVM = context.watch<ExpenseViewModel>();
    final now = DateTime.now();

    // 🔹 Map month -> total
    final Map<int, double> monthTotals = {};

    for (final e in expenseVM.expenses) {
      if (e.date.year == now.year) {
        monthTotals[e.date.month] = (monthTotals[e.date.month] ?? 0) + e.amount;
      }
    }

    // 🔹 Sort months descending (latest first)
    final months = monthTotals.keys.toList()..sort((a, b) => b.compareTo(a));

    return Scaffold(
      appBar: AppBar(title: Text(now.year.toString())),

      body: months.isEmpty
          ? const Center(
              child: Text(
                'No expenses this year',
                style: TextStyle(fontSize: 16),
              ),
            )
          : ListView.separated(
              itemCount: months.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final month = months[index];
                final total = monthTotals[month]!;

                final monthDate = DateTime(now.year, month);

                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Theme.of(
                      context,
                    ).colorScheme.primary.withOpacity(0.1),
                    child: Text(
                      DateFormat.MMM().format(monthDate),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  title: Text(DateFormat.MMMM().format(monthDate)),
                  subtitle: Text(now.year.toString()),
                  trailing: Text(
                    '₹ ${total.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            MonthOverviewScreen(year: now.year, month: month),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
