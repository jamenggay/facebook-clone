import 'package:flutter/material.dart';
import '../constants.dart';
import '../services/shared_preference.dart';

class ThemeProvider extends ChangeNotifier {
  final SessionService _session = SessionService();

  ThemeMode _themeMode = ThemeMode.light;

  ThemeProvider() {
    _loadSavedTheme();
  }

  Future<void> _loadSavedTheme() async {
    final isDark = await _session.getDarkMode();
    if (isDark) toggleTheme(true);
  }

  ThemeMode get themeMode => _themeMode;

  bool get isDarkMode => _themeMode == ThemeMode.dark;

  void toggleTheme(bool isDark) {
    _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    fbDarkMode = isDark;
    notifyListeners();
  }
}
