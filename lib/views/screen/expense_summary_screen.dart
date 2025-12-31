import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../viewmodels/expense_viewmodel.dart';

class ExpenseSummaryScreen extends StatelessWidget {
  const ExpenseSummaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ExpenseViewModel>();

    return Scaffold(
      appBar: AppBar(title: const Text('Expense Summary')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _summaryTile(
            title: 'Today',
            amount: vm.todayTotal,
            icon: Icons.today,
          ),
          _summaryTile(
            title: 'Yesterday',
            amount: vm.yesterdayTotal,
            icon: Icons.nightlight_round,
          ),
          _summaryTile(
            title: 'This Month',
            amount: vm.monthTotal,
            icon: Icons.calendar_month,
          ),
          _summaryTile(
            title: 'Monthly Budget',
            amount: vm.monthlyBudget,
            icon: Icons.account_balance_wallet,
          ),
          if (vm.isMonthlyBudgetExceeded)
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Row(
                children: const [
                  Icon(Icons.warning, color: Colors.red),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Monthly budget exceeded!',
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _summaryTile({
    required String title,
    required double amount,
    required IconData icon,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Icon(icon),
        title: Text(title),
        trailing: Text(
          '₹ ${amount.toStringAsFixed(2)}',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
