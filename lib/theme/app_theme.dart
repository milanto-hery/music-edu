// lib/theme/app_theme.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // ── Palette ──────────────────────────────────────────────────
  static const Color bg = Color(0xFF0D0D0F);
  static const Color surface = Color(0xFF16161A);
  static const Color card = Color(0xFF1E1E24);
  static const Color cardBorder = Color(0xFF2A2A35);
  static const Color accent = Color(0xFFE8A020); // amber
  static const Color accentBlue = Color(0xFF3D8EF0);
  static const Color accentGreen = Color(0xFF2DBD6E);
  static const Color accentRed = Color(0xFFE05252);
  static const Color textPrimary = Color(0xFFF0EAD8);
  static const Color textSecond = Color(0xFF8A7E6E);
  static const Color majorCol = Color(0xFF1A3A5C);
  static const Color minorCol = Color(0xFF5C1A1A);
  static const Color dimCol = Color(0xFF3A1A5C);

  // ── Gradients ────────────────────────────────────────────────
  static const LinearGradient guitarGrad = LinearGradient(
    colors: [Color(0xFF1A0A00), Color(0xFF3D1A00)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  static const LinearGradient pianoGrad = LinearGradient(
    colors: [Color(0xFF000D1A), Color(0xFF001A3D)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  static const LinearGradient accentGrad = LinearGradient(
    colors: [Color(0xFFE8A020), Color(0xFFF5C060)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // ── ThemeData ────────────────────────────────────────────────
  static ThemeData get dark {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: bg,
      colorScheme: const ColorScheme.dark(
        primary: accent,
        secondary: accentBlue,
        surface: surface,
        error: accentRed,
      ),
      textTheme: GoogleFonts.dmSansTextTheme(ThemeData.dark().textTheme)
          .copyWith(
            displayLarge: GoogleFonts.bebasNeue(
              color: textPrimary,
              fontSize: 56,
              letterSpacing: 3,
            ),
            displayMedium: GoogleFonts.bebasNeue(
              color: textPrimary,
              fontSize: 40,
              letterSpacing: 2,
            ),
            displaySmall: GoogleFonts.bebasNeue(
              color: textPrimary,
              fontSize: 28,
              letterSpacing: 2,
            ),
            headlineMedium: GoogleFonts.dmSans(
              color: textPrimary,
              fontSize: 22,
              fontWeight: FontWeight.w700,
            ),
            titleLarge: GoogleFonts.dmSans(
              color: textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
            titleMedium: GoogleFonts.dmSans(
              color: textPrimary,
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
            bodyLarge: GoogleFonts.dmSans(color: textPrimary, fontSize: 14),
            bodyMedium: GoogleFonts.dmSans(color: textSecond, fontSize: 13),
            labelSmall: GoogleFonts.spaceMono(
              color: textSecond,
              fontSize: 10,
              letterSpacing: 1.5,
            ),
          ),
      cardTheme: CardThemeData(
        color: card,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: cardBorder, width: 1),
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: bg,
        elevation: 0,
        centerTitle: false,
        iconTheme: IconThemeData(color: textPrimary),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: accent,
          foregroundColor: bg,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          textStyle: GoogleFonts.dmSans(
            fontWeight: FontWeight.w700,
            fontSize: 14,
          ),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: card,
        side: const BorderSide(color: cardBorder),
        labelStyle: GoogleFonts.dmSans(color: textPrimary, fontSize: 12),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      dividerColor: cardBorder,
      useMaterial3: true,
    );
  }
}
