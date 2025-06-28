// lib/utils/app_themes.dart
import 'package:flutter/material.dart';

class AppThemes {
  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light, 
    primaryColor: Colors.blue,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.blue,
      foregroundColor: Colors.white,
      elevation: 0,
    ),
    scaffoldBackgroundColor: Colors.grey[100],
    cardColor: Colors.white,
    textTheme: const TextTheme(
      titleLarge: TextStyle(color: Colors.black87),
      bodyMedium: TextStyle(color: Colors.black54),
      bodySmall: TextStyle(color: Colors.black45),
    ),
    buttonTheme: const ButtonThemeData(
      buttonColor: Colors.blue,
      textTheme: ButtonTextTheme.primary,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Colors.blue,
      foregroundColor: Colors.white,
    ),
   
    colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.blue)
        .copyWith(
          background: Colors.grey[100],
          brightness: Brightness.light, 
        ),
  );

  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark, 
    primaryColor: Colors.indigo,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.indigo,
      foregroundColor: Colors.white,
      elevation: 0,
    ),
    scaffoldBackgroundColor: Colors.grey[900],
    cardColor: Colors.grey[850],
    textTheme: const TextTheme(
      titleLarge: TextStyle(color: Colors.white),
      bodyMedium: TextStyle(color: Colors.white70),
      bodySmall: TextStyle(color: Colors.white60),
    ),
    buttonTheme: const ButtonThemeData(
      buttonColor: Colors.indigo,
      textTheme: ButtonTextTheme.primary,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Colors.indigo,
      foregroundColor: Colors.white,
    ),
   
    colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.indigo)
        .copyWith(
          background: Colors.grey[900],
          brightness: Brightness.dark, 
        ),
  );
}