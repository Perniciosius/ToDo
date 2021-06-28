import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider with ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;
  static const String key = 'THEME';

  ThemeMode get themeMode => _themeMode;

  void init() async {
    var instance = await SharedPreferences.getInstance();
    int index = instance.getInt(key) ?? 0;
    _themeMode = ThemeMode.values.elementAt(index);
    notifyListeners();
  }

  Future setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    notifyListeners();
    var instance = await SharedPreferences.getInstance();
    await instance.setInt(key, mode.index);
  }
}
