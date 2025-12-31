// ignore_for_file: use_build_context_synchronously

// ignore: unused_import
import 'package:expense_tracker/models/category_model.dart';
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
                        icon: const Icon(Icons.delete),
                        onPressed: () async {
                          final success = await context
                              .read<CategoryViewModel>()
                              .deleteCategory(category);

                          if (!success && context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Category is used in expenses. Cannot delete.',
                                ),
                              ),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
