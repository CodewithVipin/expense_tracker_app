import 'package:flutter/material.dart';
import '../services/settings_service.dart';

class ThemeViewModel extends ChangeNotifier {
  final SettingsService _settings = SettingsService();

  ThemeMode _themeMode = ThemeMode.light;

  ThemeMode get themeMode => _themeMode;

  ThemeViewModel() {
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    final saved = await _settings.getLastCategory(); // reuse table
    if (saved == 'dark') {
      _themeMode = ThemeMode.dark;
    } else {
      _themeMode = ThemeMode.light;
    }
    notifyListeners();
  }

  Future<void> toggleTheme() async {
    if (_themeMode == ThemeMode.light) {
      _themeMode = ThemeMode.dark;
      await _settings.saveLastCategory('dark');
    } else {
      _themeMode = ThemeMode.light;
      await _settings.saveLastCategory('light');
    }
    notifyListeners();
  }

  bool get isDark => _themeMode == ThemeMode.dark;
}
