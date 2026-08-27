import 'package:flutter/material.dart';
import '../constants.dart';

/// ThemeProvider is an example of APP STATE (long-lived state).
///
/// Unlike ephemeral state (which lives inside a single widget and is managed
/// with setState), app state affects large portions of the UI. Here it holds
/// the app-wide theme (light/dark) so that toggling it on one screen changes
/// the appearance of the entire application.
///
/// It extends [ChangeNotifier] so that any widget listening through the
/// provider package rebuilds automatically when the theme changes.
class ThemeProvider extends ChangeNotifier {
  // The current theme mode. Starts in light mode.
  ThemeMode _themeMode = ThemeMode.light;

  /// Exposes the current theme mode to the widgets that read this provider.
  ThemeMode get themeMode => _themeMode;

  /// Convenience getter that returns true when the app is in dark mode.
  /// Useful for driving a Switch widget's on/off value.
  bool get isDarkMode => _themeMode == ThemeMode.dark;

  /// Toggles between light and dark mode and notifies all listeners so the
  /// whole app rebuilds with the new theme.
  void toggleTheme(bool isDark) {
    _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    // Keep the palette getters in constants.dart in sync with the theme so the
    // custom brand colors switch to their dark variants too.
    fbDarkMode = isDark;
    notifyListeners();
  }
}
