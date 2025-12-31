import 'package:flutter/material.dart';
import '../models/category_model.dart';
import '../services/category_service.dart';

class CategoryViewModel extends ChangeNotifier {
  final CategoryService _service = CategoryService();

  List<Category> _categories = [];

  List<Category> get categories => _categories;

  CategoryViewModel() {
    loadCategories();
  }

  Future<void> loadCategories() async {
    _categories = await _service.getCategories();
    notifyListeners();
  }

  Future<void> addCategory(String name) async {
    await _service.addCategory(name);
    await loadCategories();
  }

  Future<void> updateCategory(int id, String newName) async {
    await _service.updateCategory(id, newName);
    await loadCategories();
  }

  Future<bool> deleteCategory(Category category) async {
    final success = await _service.deleteCategory(category.id!, category.name);

    if (success) {
      await loadCategories();
    }
    return success;
  }
}
