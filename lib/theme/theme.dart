import 'package:flutter/material.dart';

class AppTheme{
  static final ColorScheme colorScheme = ColorScheme.fromSeed(
    seedColor: const Color(0xFFC7C1D3),
    brightness: Brightness.dark,
    surface: const Color(0xFF0C1417),
    onSurface: Colors.white,
    primary: const Color(0xFF3E4849),
    onPrimary: Colors.white,
  );

  static final ThemeData themeData = ThemeData(
    colorScheme: colorScheme,
    useMaterial3: true,
    appBarTheme: AppBarTheme(
      backgroundColor: colorScheme.primary,
      foregroundColor: colorScheme.onPrimary,
    ),

    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderSide: BorderSide(color: const Color(0xFF2D4955)),
        borderRadius: BorderRadius.circular(16),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: const Color(0xFF2D4955)),
        borderRadius: BorderRadius.circular(16),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: const Color(0xFFE0ECEC)),
        borderRadius: BorderRadius.circular(16),
      ),
      labelStyle: TextStyle(color: Colors.white70),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF0038EE),
        foregroundColor: Colors.white,
      ),
    ),

    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: const Color(0xFFBB86FC),
      ),
    ),

    scaffoldBackgroundColor: const Color(0xFF0C1417),
  );
}