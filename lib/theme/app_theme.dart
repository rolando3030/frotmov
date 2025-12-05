// lib/theme/app_theme.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // ======= PALETA GENERAL =======
  // Home
  static const Color primaryPurple = Color(0xFF5B4DB7);
  static const Color bottomBar = Color(0xFF5B4DB7);

  // Filtros
  static const Color purple = Color(0xFF6A65B8);
  static const Color red = Color(0xFFC8102E);
  static const Color navy = Color(0xFF0D2B39);
  static const Color steel = Color(0xFF7A7D82);
  static const Color blue = Color(0xFF3B5B92);
  static const Color grayBG = Color(0xFFF6F7F9);

  // ======= THEME LIGHT =======
  static ThemeData get light {
    final base = ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryPurple,
      ).copyWith(primary: primaryPurple),
      scaffoldBackgroundColor: Colors.white,
      textTheme: GoogleFonts.poppinsTextTheme(),
      appBarTheme: const AppBarTheme(
        backgroundColor: primaryPurple,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: bottomBar,
        selectedItemColor: Colors.orange,
        unselectedItemColor: Colors.white,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
      ),
      listTileTheme: const ListTileThemeData(
        textColor: Colors.white,
        iconColor: Colors.white,
      ),
    );

    return base;
  }
}
