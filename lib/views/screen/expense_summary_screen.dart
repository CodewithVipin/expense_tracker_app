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
          _summaryCard(
            title: 'Today',
            amount: vm.todayTotal,
            icon: Icons.today,
            color: Colors.blue,
          ),
          _summaryCard(
            title: 'This Month',
            amount: vm.monthTotal,
            icon: Icons.calendar_month,
            color: Colors.orange,
          ),
          _summaryCard(
            title: 'This Year',
            amount: vm.yearTotal,
            icon: Icons.event,
            color: Colors.green,
          ),
        ],
      ),
    );
  }

  Widget _summaryCard({
    required String title,
    required double amount,
    required IconData icon,
    required Color color,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: color.withValues(alpha: 0.15),
              child: Icon(icon, color: color),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Text(
              '₹ ${amount.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
