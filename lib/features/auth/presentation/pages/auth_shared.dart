import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/config/app_theme.dart';

class AuthPalette {
  static const Color background = Color(0xFFF8FAFC);
  static const Color surface = Colors.white;
  static const Color surfaceTint = Color(0xFFFFF7F8);
  static const Color textPrimary = Color(0xFF0F172A);
  static const Color textSecondary = Color(0xFF64748B);
  static const Color border = Color(0xFFE2E8F0);
  static const Color muted = Color(0xFF94A3B8);
}

TextStyle authTitleStyle({double size = 30, FontWeight weight = FontWeight.w700, Color? color}) {
  return GoogleFonts.plusJakartaSans(
    fontSize: size,
    fontWeight: weight,
    color: color ?? AuthPalette.textPrimary,
    height: 1.08,
    letterSpacing: -0.5,
  );
}

TextStyle authBodyStyle({
  double size = 14,
  FontWeight weight = FontWeight.w400,
  Color? color,
}) {
  return GoogleFonts.plusJakartaSans(
    fontSize: size,
    fontWeight: weight,
    color: color ?? AuthPalette.textSecondary,
    height: 1.45,
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
      body: SafeArea(
        child: Stack(
          children: [
            const _AuthBackdrop(),
            SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (showBack) ...[
                    AuthBackButton(onTap: onBack ?? () => context.pop()),
                    const SizedBox(height: 16),
                  ],
                  child,
                  if (footer != null) ...[const SizedBox(height: 20), footer!],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AuthBackdrop extends StatelessWidget {
  const _AuthBackdrop();

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: IgnorePointer(
        child: Stack(
          children: [
            Container(color: AuthPalette.background),
            Positioned(
              top: -60,
              right: -70,
              child: AuthGlowCircle(
                color: AppColors.primary.withValues(alpha: 0.08),
                size: 180,
              ),
            ),
            Positioned(
              top: 110,
              left: -50,
              child: AuthGlowCircle(color: const Color(0xFFFDE2E8), size: 130),
            ),
            Positioned(
              bottom: -40,
              right: -30,
              child: AuthGlowCircle(color: const Color(0xFFFFEEF1), size: 150),
            ),
          ],
        ),
      ),
    );
  }
}

class AuthGlowCircle extends StatelessWidget {
  final Color color;
  final double size;

  const AuthGlowCircle({required this.color, required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(shape: BoxShape.circle, color: color),
    );
  }
}

class AuthBackButton extends StatelessWidget {
  final VoidCallback onTap;

  const AuthBackButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AuthPalette.border),
          boxShadow: AppShadows.soft,
        ),
        child: const Icon(
          Icons.arrow_back_rounded,
          color: AuthPalette.textPrimary,
          size: 22,
        ),
      ),
    );
  }
}

class AuthLogoBadge extends StatelessWidget {
  final double size;

  const AuthLogoBadge({this.size = 72});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(size * 0.28),
        border: Border.all(color: AuthPalette.border),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.08),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(size * 0.28),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Image.asset(
            'assets/logo/logo.png',
            fit: BoxFit.contain,
            errorBuilder: (_, __, ___) => const Icon(
              Icons.directions_bus_rounded,
              color: AppColors.primary,
            ),
          ),
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
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFFFFFFF), Color(0xFFFFF5F7)],
        ),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: AuthPalette.border),
        boxShadow: AppShadows.card,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: authTitleStyle(size: 26)),
                    const SizedBox(height: 10),
                    Text(subtitle, style: authBodyStyle(size: 13.5)),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              const AuthLogoBadge(size: 54),
            ],
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(22),
            child: Stack(
              children: [
                AspectRatio(
                  aspectRatio: 1.95,
                  child: Image.asset(
                    imageAsset,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      color: const Color(0xFFF1F5F9),
                      child: const Center(
                        child: Icon(
                          Icons.directions_bus_rounded,
                          size: 54,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          Colors.black.withValues(alpha: 0.24),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: highlights
                .map(
                  (label) => Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: AuthPalette.surface,
                      borderRadius: BorderRadius.circular(999),
                      border: Border.all(color: AuthPalette.border),
                    ),
                    child: Text(
                      label,
                      style: authBodyStyle(
                        size: 12,
                        weight: FontWeight.w600,
                        color: AuthPalette.textPrimary,
                      ),
                    ),
                  ),
                )
                .toList(),
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
          style: authBodyStyle(
            size: 11,
            weight: FontWeight.w700,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: 8),
        Text(title, style: authTitleStyle(size: 22)),
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
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: AuthPalette.border),
        boxShadow: AppShadows.card,
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
    return Text(
      text,
      style: authBodyStyle(
        size: 11.5,
        weight: FontWeight.w700,
        color: AuthPalette.textPrimary,
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
  final List<TextInputFormatter>? inputFormatters;
  final String? Function(String?)? validator;
  final String? helperText;

  const AuthTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.prefixIcon,
    this.keyboardType,
    this.obscureText = false,
    this.suffix,
    this.inputFormatters,
    this.validator,
    this.helperText,
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
          inputFormatters: inputFormatters,
          style: authBodyStyle(
            size: 15,
            color: AuthPalette.textPrimary,
            weight: FontWeight.w500,
          ),
          decoration: InputDecoration(
            hintText: hintText,
            prefixIcon: Icon(
              prefixIcon,
              size: 20,
              color: AuthPalette.muted,
            ),
            suffixIcon: suffix,
          ),
          validator: validator,
        ),
        if (helperText != null) ...[
          const SizedBox(height: 6),
          Text(
            helperText!,
            style: authBodyStyle(size: 12, color: AuthPalette.textSecondary),
          ),
        ],
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
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: ElevatedButton(
        onPressed: isBusy ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          disabledBackgroundColor: AppColors.primary.withValues(alpha: 0.45),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          elevation: 0,
        ),
        child: isBusy
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2.2,
                  color: Colors.white,
                ),
              )
            : Text(
                label,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
      ),
    );
  }
}

class AuthSecondaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;

  const AuthSecondaryButton({super.key, required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          backgroundColor: Colors.white,
          side: const BorderSide(color: AuthPalette.border),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
        child: Text(
          label,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: AuthPalette.textPrimary,
          ),
        ),
      ),
    );
  }
}

class AuthTinyLink extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final Color? color;

  const AuthTinyLink({super.key, required this.label, required this.onTap, this.color});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Text(
        label,
        style: authBodyStyle(
          size: 13,
          weight: FontWeight.w700,
          color: color ?? AppColors.primary,
        ),
      ),
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
        Text(prompt, style: authBodyStyle(size: 13.5)),
        const SizedBox(width: 4),
        AuthTinyLink(label: action, onTap: onTap),
      ],
    );
  }
}

class AuthOtpFields extends StatefulWidget {
  final int length;
  final ValueChanged<String>? onChanged;

  const AuthOtpFields({super.key, this.length = 6, this.onChanged});

  @override
  State<AuthOtpFields> createState() => AuthOtpFieldsState();
}

class AuthOtpFieldsState extends State<AuthOtpFields> {
  late final List<TextEditingController> _controllers;
  late final List<FocusNode> _focusNodes;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(widget.length, (_) => TextEditingController());
    _focusNodes = List.generate(widget.length, (_) => FocusNode());
  }

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    for (final focusNode in _focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  String get otp => _controllers.map((c) => c.text).join();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(widget.length, (index) {
        return SizedBox(
          width: 48,
          child: TextField(
            controller: _controllers[index],
            focusNode: _focusNodes[index],
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            maxLength: 1,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            style: authBodyStyle(
              size: 18,
              weight: FontWeight.w700,
              color: AuthPalette.textPrimary,
            ),
            decoration: const InputDecoration(counterText: '', hintText: '0'),
            onChanged: (value) {
              if (value.isNotEmpty && index < widget.length - 1) {
                _focusNodes[index + 1].requestFocus();
              }
              if (value.isEmpty && index > 0) {
                _focusNodes[index - 1].requestFocus();
              }
              widget.onChanged?.call(otp);
            },
          ),
        );
      }),
    );
  }
}
