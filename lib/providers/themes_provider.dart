import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier{
  ThemeMode themeMode = ThemeMode.light;

  changeTheme(ThemeMode newTheme){
    if(themeMode == newTheme) return;
    themeMode = newTheme;
    notifyListeners();
  }

}