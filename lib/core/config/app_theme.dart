import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const Color primary = Color(0xFFE11D48);
  static const Color primaryDark = Color(0xFFBE123C);
  static const Color accent = Color(0xFFF59E0B);
  static const Color accentDark = Color(0xFFD97706);
  static const Color background = Color(0xFFF8FAFC);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color primaryText = Color(0xFF0F172A);
  static const Color secondaryText = Color(0xFF64748B);
  static const Color border = Color(0xFFE2E8F0);
  static const Color error = Color(0xFFEF4444);
  static const Color warning = Color(0xFFF59E0B);
  static const Color success = Color(0xFF22C55E);
  static const Color info = Color(0xFF3B82F6);
  static const Color disabled = Color(0xFF94A3B8);
  static const Color scaffoldBackground = Color(0xFFF8FAFC);
  static const Color darkBg = Color(0xFF0B0B0B);
  static const Color darkSurface = Color(0xFF1A1A1A);
  static const Color roseLight = Color(0xFFFFF1F2);
  static const Color roseMuted = Color(0xFFFDA4AF);
  static const Color gold = Color(0xFFF59E0B);
  static const Color glassBg = Color(0x19FFFFFF);
  static const Color glassBorder = Color(0x33FFFFFF);
}

class AppSpacing {
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 24;
  static const double xxl = 32;
  static const double xxxl = 48;
}

class AppRadius {
  static const double sm = 8;
  static const double md = 14;
  static const double lg = 20;
  static const double xl = 24;
  static const double full = 999;
}

TextStyle _manrope({
  double fontSize = 15,
  FontWeight fontWeight = FontWeight.w400,
  Color color = AppColors.primaryText,
  double? letterSpacing,
}) {
  return GoogleFonts.manrope(
    fontSize: fontSize,
    fontWeight: fontWeight,
    color: color,
    letterSpacing: letterSpacing,
  );
}

TextStyle _unbounded({
  double fontSize = 18,
  FontWeight fontWeight = FontWeight.w600,
  Color color = AppColors.primaryText,
  double? letterSpacing,
}) {
  return GoogleFonts.unbounded(
    fontSize: fontSize,
    fontWeight: fontWeight,
    color: color,
    letterSpacing: letterSpacing,
  );
}

class AppTextStyles {
  static TextStyle get h1 => _unbounded(fontSize: 28, fontWeight: FontWeight.w900, letterSpacing: -0.5);
  static TextStyle get h2 => _unbounded(fontSize: 22, fontWeight: FontWeight.w700);
  static TextStyle get h3 => _unbounded(fontSize: 18, fontWeight: FontWeight.w600);
  static TextStyle get h4 => _unbounded(fontSize: 16, fontWeight: FontWeight.w600);
  static TextStyle get body => _manrope(fontSize: 15);
  static TextStyle get bodyMedium => _manrope(fontSize: 15, fontWeight: FontWeight.w500);
  static TextStyle get bodyBold => _manrope(fontSize: 15, fontWeight: FontWeight.w700);
  static TextStyle get bodySmall => _manrope(fontSize: 13, color: AppColors.secondaryText);
  static TextStyle get caption => _manrope(fontSize: 12, color: AppColors.secondaryText);
  static TextStyle get label => _manrope(fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 1.2, color: AppColors.secondaryText);
  static TextStyle get button => _manrope(fontSize: 15, fontWeight: FontWeight.w700, color: Colors.white, letterSpacing: 0.5);
  static TextStyle get price => _unbounded(fontSize: 24, fontWeight: FontWeight.w900, color: AppColors.primary);
  static TextStyle get heroTitle => _unbounded(fontSize: 36, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: -1);
}

class AppShadows {
  static List<BoxShadow> get card => [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.05),
      blurRadius: 10,
      offset: const Offset(0, 2),
    ),
  ];

  static List<BoxShadow> get premiumButton => [
    BoxShadow(
      color: AppColors.primary.withValues(alpha: 0.25),
      blurRadius: 14,
      offset: const Offset(0, 6),
    ),
  ];

  static List<BoxShadow> get soft => [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.03),
      blurRadius: 6,
      offset: const Offset(0, 4),
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
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.primaryText,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: _unbounded(fontSize: 16, fontWeight: FontWeight.w600),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 54),
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.full),
          ),
          textStyle: AppTextStyles.button,
          elevation: 0,
          shadowColor: AppColors.primary.withValues(alpha: 0.3),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          minimumSize: const Size(double.infinity, 54),
          side: const BorderSide(color: AppColors.border),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.full),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
          textStyle: AppTextStyles.button.copyWith(color: AppColors.primary),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.roseLight,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: const BorderSide(color: AppColors.error),
        ),
        labelStyle: _manrope(fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.secondaryText),
        hintStyle: _manrope(fontSize: 14, color: AppColors.disabled),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.surface,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.disabled,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        selectedLabelStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
        unselectedLabelStyle: TextStyle(fontSize: 11),
      ),
      cardTheme: CardThemeData(
        color: AppColors.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.xl),
          side: const BorderSide(color: AppColors.border, width: 0.5),
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.border,
        thickness: 0.5,
      ),
    );
  }
}
