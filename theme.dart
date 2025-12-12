import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const Color navy = Color(0xFF1E2A38);
  static const Color beige = Color(0xFFEFE1C6);
  static const Color gold = Color(0xFFE6A756);
  static const Color textLight = Color(0xFFF8F8F5);
  static const Color textDark = Color(0xFF1E2A38);
  static const Color accentGray = Color(0xFF5A6B7C);
}

final furniTheme = ThemeData(
  scaffoldBackgroundColor: AppColors.navy,
  primaryColor: AppColors.beige,
  colorScheme: const ColorScheme.light(
    primary: AppColors.beige,
    secondary: AppColors.gold,
    surface: AppColors.navy,
  ),
  textTheme: TextTheme(
    headlineMedium: GoogleFonts.playfairDisplay(
      color: AppColors.beige,
      fontWeight: FontWeight.bold,
      fontSize: 22,
    ),
    bodyMedium: GoogleFonts.inter(
      color: AppColors.textLight,
      fontSize: 14,
      height: 1.4,
    ),
    bodyLarge: GoogleFonts.inter(
      color: AppColors.textLight,
      fontSize: 16,
    ),
    labelLarge: GoogleFonts.inter(
      color: AppColors.textDark,
      fontWeight: FontWeight.bold,
      fontSize: 14,
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.beige,
      foregroundColor: AppColors.textDark,
      shape: const StadiumBorder(),
      minimumSize: const Size.fromHeight(50),
      textStyle: GoogleFonts.inter(fontWeight: FontWeight.bold),
    ),
  ),
  chipTheme: ChipThemeData(
    backgroundColor: AppColors.beige,
    labelStyle: GoogleFonts.inter(color: AppColors.textDark),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
  ),
  useMaterial3: true,
);
