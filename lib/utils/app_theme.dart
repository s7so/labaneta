import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color _lightPrimaryColor = Color(0xFFFF85A2);
  static const Color _lightAccentColor = Color(0xFFFF5252);
  static const Color _lightBackgroundColor = Color(0xFFFFF0F5);
  static const Color _lightTextColor = Color(0xFF333333);

  static const Color _darkPrimaryColor = Color(0xFFFF5252);
  static const Color _darkAccentColor = Color(0xFFFF85A2);
  static const Color _darkBackgroundColor = Color(0xFF121212);
  static const Color _darkTextColor = Color(0xFFF5F5F5);

  static ThemeData get lightTheme => _buildTheme(
        brightness: Brightness.light,
        primaryColor: _lightPrimaryColor,
        accentColor: _lightAccentColor,
        backgroundColor: _lightBackgroundColor,
        textColor: _lightTextColor,
      );

  static ThemeData get darkTheme => _buildTheme(
        brightness: Brightness.dark,
        primaryColor: _darkPrimaryColor,
        accentColor: _darkAccentColor,
        backgroundColor: _darkBackgroundColor,
        textColor: _darkTextColor,
      );

  static ThemeData _buildTheme({
    required Brightness brightness,
    required Color primaryColor,
    required Color accentColor,
    required Color backgroundColor,
    required Color textColor,
  }) {
    final ColorScheme colorScheme = ColorScheme(
      brightness: brightness,
      primary: primaryColor,
      secondary: accentColor,
      surface: backgroundColor,
      onSurface: textColor,
      onError: Colors.white,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      error: Colors.red.shade400,
    );

    return ThemeData(
      brightness: brightness,
      primaryColor: primaryColor,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: backgroundColor,
      textTheme: _buildTextTheme(textColor),
      appBarTheme: AppBarTheme(
        color: primaryColor,
        elevation: 0,
        iconTheme: IconThemeData(color: textColor),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: accentColor,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: accentColor, width: 2),
        ),
      ),
    );
  }

  static TextTheme _buildTextTheme(Color textColor) {
    return TextTheme(
      displayLarge: _getGoogleFont(96, FontWeight.w300, textColor),
      displayMedium: _getGoogleFont(60, FontWeight.w300, textColor),
      displaySmall: _getGoogleFont(48, FontWeight.w400, textColor),
      headlineMedium: _getGoogleFont(34, FontWeight.w400, textColor),
      headlineSmall: _getGoogleFont(24, FontWeight.w400, textColor),
      titleLarge: _getGoogleFont(20, FontWeight.w500, textColor),
      bodyLarge: _getGoogleFont(16, FontWeight.w400, textColor, fontFamily: 'Roboto'),
      bodyMedium: _getGoogleFont(14, FontWeight.w400, textColor, fontFamily: 'Roboto'),
      labelLarge: _getGoogleFont(14, FontWeight.w500, textColor, fontFamily: 'Roboto'),
    );
  }

  static TextStyle _getGoogleFont(double fontSize, FontWeight fontWeight, Color color, {String fontFamily = 'Poppins'}) {
    return GoogleFonts.getFont(
      fontFamily,
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
    );
  }

  static BoxDecoration getGradientDecoration(bool isDarkMode) {
    final List<Color> colors = isDarkMode
        ? [
            _darkPrimaryColor.withOpacity(0.2),
            _darkAccentColor.withOpacity(0.2),
          ]
        : [
            _lightPrimaryColor.withOpacity(0.1),
            _lightAccentColor.withOpacity(0.1),
          ];

    return BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: colors,
      ),
    );
  }
}