// ignore_for_file: use_build_context_synchronously

import 'package:expense_tracker/widgets/edit_category_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/category_viewmodel.dart';

class ManageCategoriesScreen extends StatelessWidget {
  const ManageCategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<CategoryViewModel>();

    return Scaffold(
      appBar: AppBar(title: const Text('Manage Categories')),
      body: vm.categories.isEmpty
          ? const Center(child: Text('No categories added yet'))
          : ListView.builder(
              itemCount: vm.categories.length,
              itemBuilder: (context, index) {
                final category = vm.categories[index];

                return ListTile(
                  title: Text(category.name),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (_) =>
                                EditCategoryDialog(category: category),
                          );
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          _confirmDelete(context, vm, category.id!);
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }

  void _confirmDelete(
    BuildContext context,
    CategoryViewModel vm,
    int categoryId,
  ) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Category'),
        content: const Text('Do you want to delete this category?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              await vm.deleteCategory(categoryId);
              Navigator.of(ctx).pop();
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
