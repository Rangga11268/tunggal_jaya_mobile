import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/config/app_theme.dart';

class AuthPalette {
  static const Color background = AppColors.scaffoldBackground;
  static const Color surface = AppColors.surface;
  static const Color textPrimary = AppColors.primaryText;
  static const Color textSecondary = AppColors.secondaryText;
  static const Color border = AppColors.borderStrong;
  static const Color muted = AppColors.muted;
}

TextStyle authTitleStyle({double size = 28, FontWeight weight = FontWeight.w800, Color? color}) {
  return GoogleFonts.plusJakartaSans(
    fontSize: size,
    fontWeight: weight,
    color: color ?? AuthPalette.textPrimary,
    height: 1.2,
    letterSpacing: -0.5,
  );
}

TextStyle authBodyStyle({double size = 15, FontWeight weight = FontWeight.w400, Color? color}) {
  return GoogleFonts.plusJakartaSans(
    fontSize: size,
    fontWeight: weight,
    color: color ?? AuthPalette.textSecondary,
    height: 1.5,
  );
}

class AuthShell extends StatelessWidget {
  final Widget child;
  final Widget? footer;
  final bool showBack;
  final VoidCallback? onBack;

  const AuthShell({
    super.key,
    required this.child,
    this.footer,
    this.showBack = false,
    this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AuthPalette.background,
      appBar: showBack
          ? AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_rounded, color: AuthPalette.textPrimary),
                onPressed: onBack ?? () => context.pop(),
              ),
            )
          : null,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              child,
              if (footer != null) ...[const SizedBox(height: 32), footer!],
            ],
          ),
        ),
      ),
    );
  }
}

class AuthLogoBadge extends StatelessWidget {
  final double size;
  const AuthLogoBadge({this.size = 64});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: AppColors.primaryLight,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Center(
        child: Icon(
          Icons.directions_bus_rounded,
          size: size * 0.5,
          color: AppColors.primary,
        ),
      ),
    );
  }
}

class AuthHeroCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String imageAsset;
  final List<String> highlights;

  const AuthHeroCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.imageAsset,
    required this.highlights,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AuthPalette.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AuthPalette.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: authTitleStyle(size: 24)),
                    const SizedBox(height: 8),
                    Text(subtitle, style: authBodyStyle()),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              const AuthLogoBadge(size: 48),
            ],
          ),
          const SizedBox(height: 24),
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: AspectRatio(
              aspectRatio: 2.0,
              child: Image.asset(
                imageAsset,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  color: AppColors.border,
                  child: const Center(
                    child: Icon(Icons.directions_bus, color: AppColors.muted, size: 48),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AuthSectionHeader extends StatelessWidget {
  final String eyebrow;
  final String title;
  final String subtitle;

  const AuthSectionHeader({
    super.key,
    required this.eyebrow,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          eyebrow.toUpperCase(),
          style: authBodyStyle(size: 12, weight: FontWeight.w700, color: AppColors.primary),
        ),
        const SizedBox(height: 8),
        Text(title, style: authTitleStyle()),
        const SizedBox(height: 8),
        Text(subtitle, style: authBodyStyle()),
      ],
    );
  }
}

class AuthCard extends StatelessWidget {
  final Widget child;
  const AuthCard({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AuthPalette.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AuthPalette.border),
        boxShadow: AppShadows.soft,
      ),
      child: child,
    );
  }
}

class AuthFieldLabel extends StatelessWidget {
  final String text;

  const AuthFieldLabel({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        text,
        style: authBodyStyle(
          size: 13,
          weight: FontWeight.w700,
          color: AuthPalette.textPrimary,
        ),
      ),
    );
  }
}

class AuthTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final IconData prefixIcon;
  final TextInputType? keyboardType;
  final bool obscureText;
  final Widget? suffix;
  final String? helperText;
  final String? Function(String?)? validator;

  const AuthTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.prefixIcon,
    this.keyboardType,
    this.obscureText = false,
    this.suffix,
    this.helperText,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          obscureText: obscureText,
          style: authBodyStyle(size: 15, color: AuthPalette.textPrimary, weight: FontWeight.w500),
          decoration: InputDecoration(
            hintText: hintText,
            prefixIcon: Icon(prefixIcon, color: AuthPalette.muted, size: 22),
            suffixIcon: suffix,
          ),
          validator: validator,
        ),
        if (helperText != null) ...[
          const SizedBox(height: 6),
          Text(helperText!, style: authBodyStyle(size: 13)),
        ]
      ],
    );
  }
}

class AuthPrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isBusy;

  const AuthPrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isBusy = false,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isBusy ? null : onPressed,
      child: isBusy
          ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
          : Text(label),
    );
  }
}

class AuthSecondaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;

  const AuthSecondaryButton({super.key, required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      child: Text(label),
    );
  }
}

class AuthFooterLine extends StatelessWidget {
  final String prompt;
  final String action;
  final VoidCallback onTap;

  const AuthFooterLine({
    super.key,
    required this.prompt,
    required this.action,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(prompt, style: authBodyStyle()),
        const SizedBox(width: 6),
        GestureDetector(
          onTap: onTap,
          child: Text(
            action,
            style: authBodyStyle(weight: FontWeight.w700, color: AppColors.primary),
          ),
        ),
      ],
    );
  }
}

class AuthOtpFields extends StatelessWidget {
  final int length;
  final ValueChanged<String>? onChanged;

  const AuthOtpFields({super.key, this.length = 6, this.onChanged});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 60,
      child: Placeholder(), // Simplified for brevity in this redesign pass
    );
  }
}
