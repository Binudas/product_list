
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class ThemeProvider with ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system; 

  ThemeMode get themeMode => _themeMode;


  void setInitialTheme(BuildContext context) {
    if (_themeMode == ThemeMode.system) {
  
      final Brightness systemBrightness = MediaQuery.of(context).platformBrightness;
      _themeMode = systemBrightness == Brightness.dark ? ThemeMode.dark : ThemeMode.light;
    
    }
  }

  void toggleTheme() {
    _themeMode = _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    notifyListeners(); 
  }

  void setTheme(ThemeMode mode) {
    if (_themeMode != mode) {
      _themeMode = mode;
      notifyListeners();
    }
  }
}