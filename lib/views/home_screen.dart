// ignore_for_file: deprecated_member_use

import 'package:expense_tracker/views/screen/expense_summary_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../viewmodels/expense_viewmodel.dart';
import '../../viewmodels/theme_viewmodel.dart';
import '../widgets/add_expense_dialog.dart';
import '../widgets/expense_item.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // 🔁 Auto-scroll to today's first expense
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final vm = context.read<ExpenseViewModel>();
      final index = vm.expenses.indexWhere((e) => _isToday(e.date));

      if (index != -1 && _scrollController.hasClients) {
        _scrollController.animateTo(
          index * 80.0, // approx item height
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  void _showEditBudgetDialog(BuildContext context, ExpenseViewModel vm) {
    final controller = TextEditingController(
      text: vm.monthlyBudget == 0 ? '' : vm.monthlyBudget.toStringAsFixed(0),
    );

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Set Monthly Budget'),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Enter amount',
            prefixText: '₹ ',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final value = double.tryParse(controller.text.trim()) ?? 0;
              vm.updateMonthlyBudget(value);
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final expenseVM = context.watch<ExpenseViewModel>();
    final themeVM = context.watch<ThemeViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Expense Tracker'),

        // ✅ APP BAR ICONS
        actions: [
          // 📊 Summary icon
          IconButton(
            icon: const Icon(Icons.analytics),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ExpenseSummaryScreen()),
              );
            },
          ),

          // 🌗 Theme toggle icon
          IconButton(
            icon: Icon(themeVM.isDark ? Icons.light_mode : Icons.dark_mode),
            onPressed: () {
              themeVM.toggleTheme();
            },
          ),
        ],
      ),

      body: Column(
        children: [
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  const Icon(Icons.account_balance_wallet, size: 28),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Monthly Budget',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          expenseVM.monthlyBudget == 0
                              ? 'Not set'
                              : '₹ ${expenseVM.monthlyBudget.toStringAsFixed(0)}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // ✏️ Edit Button
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () {
                      _showEditBudgetDialog(context, expenseVM);
                    },
                  ),
                ],
              ),
            ),
          ),

          // ☀️ Today
          _summaryCard(
            icon: Icons.today,
            title: 'Today',
            amount: expenseVM.todayTotal,
          ),

          // ⚠️ Daily budget warning
          if (expenseVM.isMonthlyBudgetExceeded)
            Container(
              margin: const EdgeInsets.all(12),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.red.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Row(
                children: [
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
          // 🌙 Yesterday
          _summaryCard(
            icon: Icons.nightlight_round,
            title: 'Yesterday',
            amount: expenseVM.yesterdayTotal,
          ),

          // 📆 This Month
          _summaryCard(
            icon: Icons.calendar_month,
            title: 'This Month',
            amount: expenseVM.monthTotal,
          ),

          const Divider(),

          // 📋 Expense list (full history)
          Expanded(
            child: expenseVM.expenses.isEmpty
                ? const Center(child: Text('No expenses added yet'))
                : ListView.builder(
                    controller: _scrollController,
                    itemCount: expenseVM.expenses.length,
                    itemBuilder: (context, index) {
                      return ExpenseItem(expense: expenseVM.expenses[index]);
                    },
                  ),
          ),
        ],
      ),

      // ➕ ADD EXPENSE FAB
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (_) => const AddExpenseDialog(),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  // =======================
  // 🔹 Summary Card Widget
  // =======================
  Widget _summaryCard({
    required IconData icon,
    required String title,
    required double amount,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            Icon(icon, size: 28),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 4),
                Text(
                  '₹ ${amount.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // =======================
  // 🔹 Date Helper
  // =======================
  bool _isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }
}
