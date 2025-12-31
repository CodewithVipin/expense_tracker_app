// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/category_model.dart';
import '../viewmodels/category_viewmodel.dart';
import '../viewmodels/expense_viewmodel.dart';

class AddExpenseDialog extends StatefulWidget {
  const AddExpenseDialog({super.key});

  @override
  State<AddExpenseDialog> createState() => _AddExpenseDialogState();
}

class _AddExpenseDialogState extends State<AddExpenseDialog> {
  Category? _selectedCategory;

  final TextEditingController _customController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(), // 🚫 future expense allowed nahi
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final categoryVM = context.watch<CategoryViewModel>();
    final categories = categoryVM.categories;

    return AlertDialog(
      title: const Text('Add Expense'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 🔽 CATEGORY DROPDOWN (Category, not String)
            DropdownButtonFormField<Category>(
              initialValue: _selectedCategory,
              hint: const Text('Select Category'),
              items: categories
                  .map(
                    (cat) => DropdownMenuItem<Category>(
                      value: cat,
                      child: Text(cat.name),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _selectedCategory = value;
                });
              },
            ),

            const SizedBox(height: 12),

            // ✏️ Custom category input
            TextField(
              controller: _customController,
              decoration: const InputDecoration(
                labelText: 'Or enter custom category',
              ),
            ),

            const SizedBox(height: 12),

            // 💰 Amount
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Amount'),
            ),
            const SizedBox(height: 12),

            Row(
              children: [
                const Icon(Icons.calendar_today, size: 18),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Date: ${_selectedDate.day}-${_selectedDate.month}-${_selectedDate.year}',
                  ),
                ),
                TextButton(onPressed: _pickDate, child: const Text('Change')),
              ],
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () => _saveExpense(context),
          child: const Text('Add'),
        ),
      ],
    );
  }

  Future<void> _saveExpense(BuildContext context) async {
    final amount = double.tryParse(_amountController.text.trim()) ?? 0;
    if (amount <= 0) return;

    final categoryVM = context.read<CategoryViewModel>();
    final expenseVM = context.read<ExpenseViewModel>();

    String categoryName;

    // 🧠 If custom category entered
    if (_customController.text.trim().isNotEmpty) {
      categoryName = _customController.text.trim();
      await categoryVM.addCategory(categoryName);
    }
    // 🧠 If selected from dropdown
    else if (_selectedCategory != null) {
      categoryName = _selectedCategory!.name;
    } else {
      return; // ❌ no category selected
    }

    // ✅ BACK-DATE SUPPORT (MOST IMPORTANT LINE)
    await expenseVM.addExpense(categoryName, amount, date: _selectedDate);

    Navigator.pop(context);
  }
}
