import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const background1 = Color(0xFF0A0E1A);
  static const background2 = Color(0xFF0D1425);
  static const accent = Color(0xFF00D68F);
  static const accentGlow = Color(0x3300D68F);
  static const secondary = Color(0xFF8B5CF6);
  static const glassFill = Color(0x0FFFFFFF);   // rgba(255,255,255,0.06)
  static const glassBorder = Color(0x21FFFFFF);  // rgba(255,255,255,0.13)
  static const glassShimmer = Color(0x1AFFFFFF); // inner shimmer
  static const textPrimary = Colors.white;
  static const textSecondary = Color(0x99FFFFFF); // white 60%
  static const textHint = Color(0x4DFFFFFF);      // white 30%
  static const error = Color(0xFFFF4D6A);
  static const warning = Color(0xFFFFB547);
  static const success = Color(0xFF00D68F);
}

class AppTextStyles {
  static TextStyle get display => GoogleFonts.plusJakartaSans(
    fontSize: 32,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    letterSpacing: -0.5,
  );

  static TextStyle get headline => GoogleFonts.plusJakartaSans(
    fontSize: 22,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static TextStyle get title => GoogleFonts.plusJakartaSans(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static TextStyle get body => GoogleFonts.plusJakartaSans(
    fontSize: 15,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
  );

  static TextStyle get caption => GoogleFonts.plusJakartaSans(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
  );

  static TextStyle get label => GoogleFonts.plusJakartaSans(
    fontSize: 13,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
  );

  // Arabic variants
  static TextStyle get displayAr => GoogleFonts.cairo(
    fontSize: 32,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );

  static TextStyle get headlineAr => GoogleFonts.cairo(
    fontSize: 22,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static TextStyle get bodyAr => GoogleFonts.cairo(
    fontSize: 15,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
  );
}

ThemeData buildAppTheme() {
  return ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.background1,
    colorScheme: const ColorScheme.dark(
      primary: AppColors.accent,
      secondary: AppColors.secondary,
      surface: AppColors.glassFill,
      error: AppColors.error,
    ),
    textTheme: GoogleFonts.plusJakartaSansTextTheme(
      ThemeData.dark().textTheme,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.glassFill,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: AppColors.glassBorder),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: AppColors.glassBorder),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: AppColors.accent, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: AppColors.error),
      ),
      hintStyle: const TextStyle(color: AppColors.textHint),
      labelStyle: const TextStyle(color: AppColors.textSecondary),
    ),
    pageTransitionsTheme: const PageTransitionsTheme(
      builders: {
        TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
      },
    ),
  );
}

ThemeData buildLightTheme() {
  return ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: const Color(0xFFF2F5FB),
    colorScheme: ColorScheme.light(
      primary: AppColors.accent,
      secondary: AppColors.secondary,
      surface: Colors.white,
      error: AppColors.error,
    ),
    textTheme: GoogleFonts.plusJakartaSansTextTheme(
      ThemeData.light().textTheme,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: Colors.black.withAlpha(25)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: Colors.black.withAlpha(25)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: AppColors.accent, width: 1.5),
      ),
      hintStyle: TextStyle(color: Colors.black.withAlpha(90)),
      labelStyle: TextStyle(color: Colors.black.withAlpha(140)),
    ),
    pageTransitionsTheme: const PageTransitionsTheme(
      builders: {
        TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
      },
    ),
  );
}

