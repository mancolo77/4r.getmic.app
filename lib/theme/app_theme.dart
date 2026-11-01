import 'package:flutter/material.dart';

class AppTheme {
  static const Color background = Color(0xFF0B1928);
  static const Color darkNav = Color(0xFF11263C);
  static const Color surfaceCard = Color(0xFF172D42);
  static const Color filterBg = Color(0xFF243C53);
  static const Color border = Color(0xFF243C53);
  static const Color primary = Color(0xFF0088FF); // Electric Blue
  static const Color accentYellow = Color(0xFFFFF000);
  static const Color textMain = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFF9DAFC1);

  static const double cardRadius = 16.0;
  static const double buttonRadius = 12.0;
  static const double buttonHeight = 48.0;
  static const double screenPadding = 16.0;

  static ThemeData get theme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: background,
      primaryColor: primary,
      colorScheme: const ColorScheme.dark(
        primary: primary,
        surface: surfaceCard,
        
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: Colors.white,
          elevation: 0,
          minimumSize: const Size(0, buttonHeight),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(buttonRadius)),
        ),
      ),
    );
  }

  // Compatibility getters
  static const Color surface = surfaceCard;
  static const Color surfaceElevated = surfaceCard;
  static const Color surfaceBorder = border;
  static const Color textPrimary = textMain;
  static const Color textMuted = textSecondary;
  static const Color secondary = primary;
  
  static const Color accentGold = primary;
  static const Color accentRose = Color(0xFFED2433);

  static List<BoxShadow> get cardShadow => [
        BoxShadow(
          color: Colors.black.withAlpha(20),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ];

  static List<BoxShadow> get neonGlow => [
        BoxShadow(
          color: primary.withAlpha(50),
          blurRadius: 16,
          spreadRadius: 1,
        ),
      ];

  static ThemeData get darkTheme => theme;
  static ThemeData get lightTheme => theme;
}
