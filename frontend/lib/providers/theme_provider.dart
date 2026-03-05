import 'package:flutter/material.dart';

/// Global theme state manager.
///
/// Controls whether the application runs in light or dark mode
/// and notifies listeners when the theme changes.
class ThemeProvider extends ChangeNotifier {

  /// Internal theme state (true = dark mode enabled).
  bool _isDarkMode = true;

  /// Returns whether dark mode is currently active.
  bool get isDarkMode => _isDarkMode;

  /// Returns the corresponding [ThemeMode]
  /// used by [MaterialApp].
  ThemeMode get themeMode =>
      _isDarkMode ? ThemeMode.dark : ThemeMode.light;

  /// Toggles the theme and notifies all listening widgets
  /// to rebuild with the new theme mode.
  void toggleTheme(bool isOn) {
    _isDarkMode = isOn;
    notifyListeners();
  }
}