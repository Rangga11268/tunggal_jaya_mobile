import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  // Brand Red - Slightly refined, elegant red
  static const Color primary = Color(0xFFE11D48);
  static const Color primaryDark = Color(0xFFBE123C);
  static const Color primaryLight = Color(0xFFFEE2E2);
  
  static const Color accent = Color(0xFFF59E0B);
  static const Color accentDark = Color(0xFFD97706);
  
  // Backgrounds - very clean, almost white
  static const Color background = Color(0xFFFDFDFD);
  static const Color surface = Color(0xFFFFFFFF);
  
  // Text - high contrast but not pure black
  static const Color primaryText = Color(0xFF1E293B); // Slate 800
  static const Color secondaryText = Color(0xFF64748B); // Slate 500
  static const Color muted = Color(0xFF94A3B8); // Slate 400
  
  // Borders
  static const Color border = Color(0xFFF1F5F9); // Slate 100
  static const Color borderStrong = Color(0xFFE2E8F0); // Slate 200
  
  // States
  static const Color error = Color(0xFFEF4444);
  static const Color warning = Color(0xFFF59E0B);
  static const Color success = Color(0xFF22C55E);
  static const Color info = Color(0xFF3B82F6);
  static const Color disabled = Color(0xFFCBD5E1);
  
  // Extra
  static const Color scaffoldBackground = Color(0xFFF8FAFC); // Very light slate
}

class AppSpacing {
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;
  static const double xxl = 48;
}

class AppRadius {
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 24;
  static const double full = 999;
}

// Clean and modern typography
TextStyle _primaryFont({
  double fontSize = 15,
  FontWeight fontWeight = FontWeight.w400,
  Color color = AppColors.primaryText,
  double? letterSpacing,
}) {
  return GoogleFonts.plusJakartaSans(
    fontSize: fontSize,
    fontWeight: fontWeight,
    color: color,
    letterSpacing: letterSpacing,
  );
}

class AppTextStyles {
  static TextStyle get h1 => _primaryFont(fontSize: 28, fontWeight: FontWeight.w800, letterSpacing: -0.5);
  static TextStyle get h2 => _primaryFont(fontSize: 24, fontWeight: FontWeight.w700, letterSpacing: -0.5);
  static TextStyle get h3 => _primaryFont(fontSize: 20, fontWeight: FontWeight.w700);
  static TextStyle get h4 => _primaryFont(fontSize: 18, fontWeight: FontWeight.w600);
  
  static TextStyle get body => _primaryFont(fontSize: 15);
  static TextStyle get bodyMedium => _primaryFont(fontSize: 15, fontWeight: FontWeight.w500);
  static TextStyle get bodyBold => _primaryFont(fontSize: 15, fontWeight: FontWeight.w700);
  
  static TextStyle get bodySmall => _primaryFont(fontSize: 13, color: AppColors.secondaryText);
  static TextStyle get caption => _primaryFont(fontSize: 12, color: AppColors.secondaryText);
  static TextStyle get label => _primaryFont(fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 1.0, color: AppColors.secondaryText);
  
  static TextStyle get button => _primaryFont(fontSize: 15, fontWeight: FontWeight.w700, color: Colors.white, letterSpacing: 0.2);
}

class AppShadows {
  static List<BoxShadow> get card => [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.04),
      blurRadius: 16,
      offset: const Offset(0, 4),
    ),
  ];

  static List<BoxShadow> get soft => [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.02),
      blurRadius: 8,
      offset: const Offset(0, 2),
    ),
  ];
}

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.scaffoldBackground,
      colorScheme: ColorScheme.light(
        primary: AppColors.primary,
        secondary: AppColors.accent,
        surface: AppColors.surface,
        error: AppColors.error,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.scaffoldBackground,
        foregroundColor: AppColors.primaryText,
        elevation: 0,
        centerTitle: true,
        scrolledUnderElevation: 0,
        titleTextStyle: AppTextStyles.h4,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 56),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.lg),
          ),
          textStyle: AppTextStyles.button,
          elevation: 0,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          minimumSize: const Size(double.infinity, 56),
          side: const BorderSide(color: AppColors.borderStrong, width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.lg),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          textStyle: AppTextStyles.button.copyWith(color: AppColors.primary),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surface,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: 18,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: const BorderSide(color: AppColors.borderStrong),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: const BorderSide(color: AppColors.borderStrong),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: const BorderSide(color: AppColors.error),
        ),
        labelStyle: AppTextStyles.body.copyWith(color: AppColors.secondaryText),
        hintStyle: AppTextStyles.body.copyWith(color: AppColors.muted),
      ),
      cardTheme: CardThemeData(
        color: AppColors.surface,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg),
          side: const BorderSide(color: AppColors.border, width: 1),
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.borderStrong,
        thickness: 1,
      ),
    );
  }
}
