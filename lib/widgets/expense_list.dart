import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/expense_viewmodel.dart';
import 'expense_item.dart';

class ExpenseList extends StatelessWidget {
  const ExpenseList({super.key});

  @override
  Widget build(BuildContext context) {
    final expenses = context.watch<ExpenseViewModel>().expenses;

    if (expenses.isEmpty) {
      return const Center(child: Text('No expenses added yet'));
    }

    return ListView.builder(
      itemCount: expenses.length,
      itemBuilder: (ctx, index) {
        return ExpenseItem(expense: expenses[index]);
      },
    );
  }
}
