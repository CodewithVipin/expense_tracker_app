// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/category_model.dart';
import '../viewmodels/category_viewmodel.dart';

class EditCategoryDialog extends StatefulWidget {
  final Category category;
  const EditCategoryDialog({super.key, required this.category});

  @override
  State<EditCategoryDialog> createState() => _EditCategoryDialogState();
}

class _EditCategoryDialogState extends State<EditCategoryDialog> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.category.name);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Edit Category'),
      content: TextField(
        controller: _controller,
        decoration: const InputDecoration(labelText: 'Category name'),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () async {
            final newName = _controller.text.trim();
            if (newName.isEmpty) return;

            await context.read<CategoryViewModel>().updateCategory(
              widget.category.id!,
              newName,
            );

            Navigator.pop(context);
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}
