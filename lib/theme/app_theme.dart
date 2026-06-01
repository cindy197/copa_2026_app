import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  AppTheme._();

  static const Color primaryContainer = Color(0xFFFFD700);
  static const Color secondaryContainer = Color(0xFF00CB65);
  static const Color background = Color(0xFF111415);
  static const Color surfaceContainer = Color(0xFF1D2021);
  static const Color surfaceContainerHigh = Color(0xFF282A2B);
  static const Color surfaceContainerLow = Color(0xFF191C1D);
  static const Color surfaceBright = Color(0xFF373A3B);
  static const Color onSurface = Color(0xFFE1E3E4);
  static const Color onSurfaceVariant = Color(0xFFD0C6AB);
  static const Color outlineVariant = Color(0xFF4D4732);
  static const Color primary = Color(0xFFFFF6DF);
  static const Color secondary = Color(0xFF3FE87E);
  static const Color error = Color(0xFFFFB4AB);
  static const Color surfaceTint = Color(0xFFE9C400);
  static const Color surfaceVariant = Color(0xFF323536);
  static const Color onPrimaryContainer = Color(0xFF705E00);

  static ThemeData get darkTheme => ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: background,
    colorScheme: const ColorScheme.dark(
      primary: primary,
      secondary: secondary,
      surface: background,
      error: error,
    ),
    textTheme: TextTheme(
      displayLarge: GoogleFonts.archivoNarrow(
        fontSize: 48, fontWeight: FontWeight.w700,
        letterSpacing: -0.02, color: primaryContainer,
      ),
      headlineLarge: GoogleFonts.archivoNarrow(
        fontSize: 32, fontWeight: FontWeight.w700, color: primary,
      ),
      headlineMedium: GoogleFonts.archivoNarrow(
        fontSize: 24, fontWeight: FontWeight.w600, color: primary,
      ),
      headlineSmall: GoogleFonts.archivoNarrow(
        fontSize: 28, fontWeight: FontWeight.w700, color: primary,
      ),
      bodyLarge: GoogleFonts.inter(
        fontSize: 18, fontWeight: FontWeight.w400, color: onSurface,
      ),
      bodyMedium: GoogleFonts.inter(
        fontSize: 16, fontWeight: FontWeight.w400, color: onSurface,
      ),
      labelLarge: GoogleFonts.jetBrainsMono(
        fontSize: 14, fontWeight: FontWeight.w500,
        letterSpacing: 0.05, color: onSurfaceVariant,
      ),
      labelSmall: GoogleFonts.jetBrainsMono(
        fontSize: 12, fontWeight: FontWeight.w500, color: onSurfaceVariant,
      ),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: surfaceContainer,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: GoogleFonts.archivoNarrow(
        fontSize: 24, fontWeight: FontWeight.w600,
        color: primaryContainer,
      ),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: surfaceContainerHigh,
      selectedItemColor: primaryContainer,
      unselectedItemColor: onSurfaceVariant,
    ),
  );
}
