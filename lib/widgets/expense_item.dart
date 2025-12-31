import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../models/expense_model.dart';
import '../../viewmodels/expense_viewmodel.dart';

class ExpenseItem extends StatelessWidget {
  final Expense expense;

  const ExpenseItem({super.key, required this.expense});

  @override
  Widget build(BuildContext context) {
    final formattedDate =
        '${expense.date.day.toString().padLeft(2, '0')}/'
        '${expense.date.month.toString().padLeft(2, '0')}/'
        '${expense.date.year}';
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),

      child: ListTile(
        title: Text(
          expense.category,
          style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        subtitle: Text(
          formattedDate,
          style: GoogleFonts.inter(fontSize: 12, color: Colors.grey.shade600),
        ),

        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '₹${expense.amount}',
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              icon: const Icon(Icons.remove_circle, color: Colors.red),
              onPressed: () {
                _showDeleteConfirmation(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Expense'),
        content: const Text('Do you want to delete this expense?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('No'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              context.read<ExpenseViewModel>().deleteExpense(expense.id!);
              Navigator.of(ctx).pop();
            },
            child: const Text('Yes, Delete'),
          ),
        ],
      ),
    );
  }
}
