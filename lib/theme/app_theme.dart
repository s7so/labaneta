import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFF0FC2C0);
  static const Color secondary = Color(0xFF0CABA8);
  static const Color tertiary = Color(0xFF008F8C);
  static const Color accent = Color(0xFF015958);
  static const Color background = Color(0xFFF5F9FA); // Light background color
  static const Color surface = Colors.white;
  static const Color text = Color(0xFF023535);
  static const Color textLight = Color(0xFF015958);
  static const Color divider = Color(0xFFE0E0E0);
}

class AppTheme {
  static final ThemeData lightTheme = ThemeData(
    primaryColor: AppColors.primary,
    scaffoldBackgroundColor: AppColors.background,
    colorScheme: ColorScheme.light(
      primary: AppColors.primary,
      secondary: AppColors.secondary,
      tertiary: AppColors.tertiary,
      surface: AppColors.surface,
      background: AppColors.background,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: AppColors.text,
      onBackground: AppColors.text,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.primary,
      elevation: 0,
      iconTheme: IconThemeData(color: Colors.white),
      titleTextStyle: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.accent,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ),
    textTheme: TextTheme(
      headlineSmall: TextStyle(color: AppColors.text, fontWeight: FontWeight.bold),
      titleLarge: TextStyle(color: AppColors.text, fontWeight: FontWeight.bold),
      titleMedium: TextStyle(color: AppColors.text),
      bodyLarge: TextStyle(color: AppColors.text),
      bodyMedium: TextStyle(color: AppColors.textLight),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: AppColors.divider),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: AppColors.primary, width: 2),
      ),
      filled: true,
      fillColor: Colors.white,
    ),
    cardTheme: CardTheme(
      color: AppColors.surface,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
    dividerTheme: DividerThemeData(
      color: AppColors.divider,
      thickness: 1,
    ),
  );

  // يمكنك إضافة نمط داكن هنا إذا كنت ترغب في دعم الوضع الداكن
}