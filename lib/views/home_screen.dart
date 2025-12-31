// ignore_for_file: deprecated_member_use, use_build_context_synchronously, duplicate_ignore

import 'dart:async';

import 'package:expense_tracker/viewmodels/theme_viewmodel.dart';
import 'package:expense_tracker/views/screen/expense_summary_screen.dart';
import 'package:expense_tracker/views/screen/manage_categories_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/expense_viewmodel.dart';
import '../widgets/add_expense_dialog.dart';
import '../widgets/expense_item.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _showFab = true;
  Timer? _fabTimer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final vm = context.read<ExpenseViewModel>();
      vm.loadMonthlyBudget();
      vm.loadExpenses();
      _scrollController.addListener(_handleScroll);
    });
  }

  @override
  void dispose() {
    _fabTimer?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  void _handleScroll() {
    // Hide FAB immediately on scroll
    if (_showFab) {
      setState(() {
        _showFab = false;
      });
    }

    // Reset timer
    _fabTimer?.cancel();

    // Show FAB again after 3 seconds of inactivity
    _fabTimer = Timer(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _showFab = true;
        });
      }
    });
  }

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

  @override
  Widget build(BuildContext context) {
    final expenseVM = context.watch<ExpenseViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Expense Tracker'),

        // ✅ APP BAR ICONS
        actions: [
          // 🏷️ Manage Categories
          IconButton(
            icon: const Icon(Icons.category),
            tooltip: 'Manage Categories',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const ManageCategoriesScreen(),
                ),
              );
            },
          ),
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
            icon: const Icon(Icons.brightness_6),
            tooltip: 'Toggle Theme',
            onPressed: () {
              context.read<ThemeViewModel>().toggleTheme();
            },
          ),
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Column(
          children: [
            // ☀️ Today
            _summaryCard(
              icon: Icons.today,
              title: 'Today',
              amount: expenseVM.todayTotal,
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

            Divider(thickness: 0.8, color: Colors.brown.withOpacity(0.2)),

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
      ),

      // ➕ ADD EXPENSE FAB
      floatingActionButton: AnimatedScale(
        scale: _showFab ? 1.0 : 0.0,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        child: AnimatedOpacity(
          opacity: _showFab ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 200),
          child: FloatingActionButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (_) => const AddExpenseDialog(),
              );
            },
            child: const Icon(Icons.add),
          ),
        ),
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
