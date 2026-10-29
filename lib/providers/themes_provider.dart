import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  static const _key = 'themeMode';

  ThemeMode themeMode;
  final SharedPreferences _prefs;

  ThemeProvider(this._prefs)
      : themeMode = ThemeMode.values.firstWhere(
        (m) => m.name == _prefs.getString(_key),
    orElse: () => ThemeMode.light,
  );

  Future<void> changeTheme(ThemeMode newTheme) async {
    if (themeMode == newTheme) return;
    themeMode = newTheme;
    notifyListeners();
    await _prefs.setString(_key, newTheme.name);
  }
}