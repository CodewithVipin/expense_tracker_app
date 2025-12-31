// ignore_for_file: use_build_context_synchronously

import 'package:expense_tracker/viewmodels/expense_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../utils/summary_type.dart';
// ignore: duplicate_import
import '../../viewmodels/expense_viewmodel.dart';

class ExpenseSummaryScreen extends StatefulWidget {
  const ExpenseSummaryScreen({super.key});

  @override
  State<ExpenseSummaryScreen> createState() => _ExpenseSummaryScreenState();
}

class _ExpenseSummaryScreenState extends State<ExpenseSummaryScreen> {
  SummaryType _type = SummaryType.daily;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<ExpenseViewModel>().loadSummary(_type);
    });
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ExpenseViewModel>();

    return Scaffold(
      appBar: AppBar(title: const Text('Expense Summary')),
      body: Column(
        children: [
          // 🔘 FILTER BUTTONS
          Padding(
            padding: const EdgeInsets.all(8),
            child: SegmentedButton<SummaryType>(
              segments: const [
                ButtonSegment(value: SummaryType.daily, label: Text('Daily')),
                ButtonSegment(
                  value: SummaryType.monthly,
                  label: Text('Monthly'),
                ),
                ButtonSegment(value: SummaryType.yearly, label: Text('Yearly')),
              ],
              selected: {_type},
              onSelectionChanged: (value) {
                setState(() {
                  _type = value.first;
                });
                vm.loadSummary(_type);
              },
            ),
          ),

          // 📊 SUMMARY LIST
          Expanded(
            child: vm.summary.isEmpty
                ? const Center(child: Text('No data'))
                : ListView.builder(
                    itemCount: vm.summary.length,
                    itemBuilder: (context, index) {
                      final item = vm.summary[index];
                      return ListTile(
                        title: Text(item['period']),
                        trailing: Text(
                          '₹${item['total'].toStringAsFixed(2)}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
