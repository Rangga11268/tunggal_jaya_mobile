import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/config/app_theme.dart';
import '../providers/auth_provider.dart';

class AuthStaticPalette {
  static const Color background = Color(0xFFF8FAFC);
  static const Color surface = Colors.white;
  static const Color surfaceTint = Color(0xFFFFF7F8);
  static const Color textPrimary = Color(0xFF0F172A);
  static const Color textSecondary = Color(0xFF64748B);
  static const Color border = Color(0xFFE2E8F0);
  static const Color muted = Color(0xFF94A3B8);
}

TextStyle _titleStyle({double size = 30, FontWeight weight = FontWeight.w700}) {
  return GoogleFonts.plusJakartaSans(
    fontSize: size,
    fontWeight: weight,
    color: AuthStaticPalette.textPrimary,
    height: 1.08,
    letterSpacing: -0.5,
  );
}

TextStyle _bodyStyle({
  double size = 14,
  FontWeight weight = FontWeight.w400,
  Color? color,
}) {
  return GoogleFonts.plusJakartaSans(
    fontSize: size,
    fontWeight: weight,
    color: color ?? AuthStaticPalette.textSecondary,
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
      backgroundColor: AuthStaticPalette.background,
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
                    _BackButton(onTap: onBack ?? () => context.pop()),
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
            Container(color: AuthStaticPalette.background),
            Positioned(
              top: -60,
              right: -70,
              child: _GlowCircle(
                color: AppColors.primary.withValues(alpha: 0.08),
                size: 180,
              ),
            ),
            Positioned(
              top: 110,
              left: -50,
              child: _GlowCircle(color: const Color(0xFFFDE2E8), size: 130),
            ),
            Positioned(
              bottom: -40,
              right: -30,
              child: _GlowCircle(color: const Color(0xFFFFEEF1), size: 150),
            ),
          ],
        ),
      ),
    );
  }
}

class _GlowCircle extends StatelessWidget {
  final Color color;
  final double size;

  const _GlowCircle({required this.color, required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(shape: BoxShape.circle, color: color),
    );
  }
}

class _BackButton extends StatelessWidget {
  final VoidCallback onTap;

  const _BackButton({required this.onTap});

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
          border: Border.all(color: AuthStaticPalette.border),
          boxShadow: AppShadows.soft,
        ),
        child: const Icon(
          Icons.arrow_back_rounded,
          color: AuthStaticPalette.textPrimary,
          size: 22,
        ),
      ),
    );
  }
}

class _LogoBadge extends StatelessWidget {
  final double size;

  const _LogoBadge({this.size = 72});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(size * 0.28),
        border: Border.all(color: AuthStaticPalette.border),
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

class _HeroCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String imageAsset;
  final List<String> highlights;

  const _HeroCard({
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
        border: Border.all(color: AuthStaticPalette.border),
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
                    Text(title, style: _titleStyle(size: 26)),
                    const SizedBox(height: 10),
                    Text(subtitle, style: _bodyStyle(size: 13.5)),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              const _LogoBadge(size: 54),
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
                      color: AuthStaticPalette.surface,
                      borderRadius: BorderRadius.circular(999),
                      border: Border.all(color: AuthStaticPalette.border),
                    ),
                    child: Text(
                      label,
                      style: _bodyStyle(
                        size: 12,
                        weight: FontWeight.w600,
                        color: AuthStaticPalette.textPrimary,
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

class _SectionHeader extends StatelessWidget {
  final String eyebrow;
  final String title;
  final String subtitle;

  const _SectionHeader({
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
          style: _bodyStyle(
            size: 11,
            weight: FontWeight.w700,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: 8),
        Text(title, style: _titleStyle(size: 22)),
        const SizedBox(height: 8),
        Text(subtitle, style: _bodyStyle()),
      ],
    );
  }
}

class _AuthCard extends StatelessWidget {
  final Widget child;

  const _AuthCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: AuthStaticPalette.border),
        boxShadow: AppShadows.card,
      ),
      child: child,
    );
  }
}

class _FieldLabel extends StatelessWidget {
  final String text;

  const _FieldLabel({required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: _bodyStyle(
        size: 11.5,
        weight: FontWeight.w700,
        color: AuthStaticPalette.textPrimary,
      ),
    );
  }
}

class _TextFieldWrap extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final IconData prefixIcon;
  final TextInputType? keyboardType;
  final bool obscureText;
  final Widget? suffix;
  final List<TextInputFormatter>? inputFormatters;
  final String? Function(String?)? validator;
  final String? helperText;

  const _TextFieldWrap({
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
          style: _bodyStyle(
            size: 15,
            color: AuthStaticPalette.textPrimary,
            weight: FontWeight.w500,
          ),
          decoration: InputDecoration(
            hintText: hintText,
            prefixIcon: Icon(
              prefixIcon,
              size: 20,
              color: AuthStaticPalette.muted,
            ),
            suffixIcon: suffix,
          ),
          validator: validator,
        ),
        if (helperText != null) ...[
          const SizedBox(height: 6),
          Text(
            helperText!,
            style: _bodyStyle(size: 12, color: AuthStaticPalette.textSecondary),
          ),
        ],
      ],
    );
  }
}

class _PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isBusy;

  const _PrimaryButton({
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

class _SecondaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;

  const _SecondaryButton({required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          backgroundColor: Colors.white,
          side: const BorderSide(color: AuthStaticPalette.border),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
        child: Text(
          label,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: AuthStaticPalette.textPrimary,
          ),
        ),
      ),
    );
  }
}

class _TinyLink extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final Color? color;

  const _TinyLink({required this.label, required this.onTap, this.color});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Text(
        label,
        style: _bodyStyle(
          size: 13,
          weight: FontWeight.w700,
          color: color ?? AppColors.primary,
        ),
      ),
    );
  }
}

class _AuthFooterLine extends StatelessWidget {
  final String prompt;
  final String action;
  final VoidCallback onTap;

  const _AuthFooterLine({
    required this.prompt,
    required this.action,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(prompt, style: _bodyStyle(size: 13.5)),
        const SizedBox(width: 4),
        _TinyLink(label: action, onTap: onTap),
      ],
    );
  }
}

class _OtpFields extends StatefulWidget {
  final int length;
  final ValueChanged<String>? onChanged;

  const _OtpFields({super.key, this.length = 6, this.onChanged});

  @override
  State<_OtpFields> createState() => _OtpFieldsState();
}

class _OtpFieldsState extends State<_OtpFields> {
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
            style: _bodyStyle(
              size: 18,
              weight: FontWeight.w700,
              color: AuthStaticPalette.textPrimary,
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

class GetStartedPage extends StatelessWidget {
  const GetStartedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AuthShell(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const _LogoBadge(),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tunggal Jaya',
                      style: _bodyStyle(
                        size: 18,
                        weight: FontWeight.w700,
                        color: AuthStaticPalette.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Transport mobile flow',
                      style: _bodyStyle(size: 12.5),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          _HeroCard(
            title: 'Pesan tiket dengan tampilan yang lebih ringan.',
            subtitle:
                'Halaman ini disiapkan untuk flow login, register, OTP, dan reset password. Backend tinggal disambungkan nanti.',
            imageAsset: 'assets/images/hero.jpg',
            highlights: const ['Login cepat', 'OTP siap', 'Reset password'],
          ),
          const SizedBox(height: 20),
          _AuthCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const _SectionHeader(
                  eyebrow: 'Get Started',
                  title: 'Mulai dari akun Anda',
                  subtitle:
                      'Pilihan di bawah ini sudah disusun agar nanti mudah dipasang API autentikasi.',
                ),
                const SizedBox(height: 18),
                _PrimaryButton(
                  label: 'Masuk',
                  onPressed: () => context.go('/login'),
                ),
                const SizedBox(height: 10),
                _SecondaryButton(
                  label: 'Daftar akun baru',
                  onPressed: () => context.go('/register'),
                ),
                const SizedBox(height: 14),
                _TinyLink(
                  label: 'Lihat alur OTP',
                  onTap: () => context.go('/otp'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _loginSuccess = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    ref.read(authProvider.notifier).login(
          _emailController.text.trim(),
          _passwordController.text,
        );
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    if (authState.isAuthenticated && !_loginSuccess) {
      _loginSuccess = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.go('/home');
      });
    }

    return AuthShell(
      showBack: true,
      onBack: () => context.go('/get-started'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _LogoBadge(),
          const SizedBox(height: 18),
          Text('Selamat datang kembali', style: _titleStyle(size: 27)),
          const SizedBox(height: 8),
          Text(
            'Masuk ke akun Anda untuk mulai memesan tiket.',
            style: _bodyStyle(),
          ),
          const SizedBox(height: 18),
          _HeroCard(
            title: 'Akses akun Anda lebih cepat.',
            subtitle:
                'Form dibuat sederhana supaya mudah dihubungkan ke login API, OTP, atau reset password.',
            imageAsset: 'assets/images/primadona.webp',
            highlights: const ['Email', 'Password', 'OTP'],
          ),
          const SizedBox(height: 20),
          _AuthCard(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (authState.error != null) ...[
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFEF2F2),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFFECACA)),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.error_outline,
                              size: 18, color: Color(0xFFDC2626)),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              authState.error!,
                              style: _bodyStyle(
                                  size: 13,
                                  color: const Color(0xFFDC2626),
                                  weight: FontWeight.w500),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),
                  ],
                  const _FieldLabel(text: 'Alamat email'),
                  const SizedBox(height: 8),
                  _TextFieldWrap(
                    controller: _emailController,
                    hintText: 'nama@email.com',
                    prefixIcon: Icons.email_outlined,
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty)
                        return 'Email wajib diisi';
                      return null;
                    },
                  ),
                  const SizedBox(height: 14),
                  const _FieldLabel(text: 'Password'),
                  const SizedBox(height: 8),
                  _TextFieldWrap(
                    controller: _passwordController,
                    hintText: 'Masukkan password',
                    prefixIcon: Icons.lock_outline,
                    obscureText: _obscurePassword,
                    suffix: IconButton(
                      onPressed: () =>
                          setState(() => _obscurePassword = !_obscurePassword),
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        color: AuthStaticPalette.muted,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty)
                        return 'Password wajib diisi';
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  Align(
                    alignment: Alignment.centerRight,
                    child: _TinyLink(
                      label: 'Lupa password?',
                      onTap: () => context.go('/forgot-password'),
                    ),
                  ),
                  const SizedBox(height: 18),
                  _PrimaryButton(
                    label: 'Masuk',
                    isBusy: authState.isLoading,
                    onPressed: _login,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          _AuthFooterLine(
            prompt: 'Belum punya akun?',
            action: 'Daftar',
            onTap: () => context.go('/register'),
          ),
        ],
      ),
    );
  }
}

class LoginOtpPage extends StatelessWidget {
  const LoginOtpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AuthShell(
      showBack: true,
      onBack: () => context.go('/login'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _LogoBadge(),
          const SizedBox(height: 18),
          Text('Verifikasi OTP login', style: _titleStyle(size: 26)),
          const SizedBox(height: 8),
          Text(
            'Halaman ini dipakai untuk alur login cepat berbasis kode. Backend tinggal disambungkan nanti.',
            style: _bodyStyle(),
          ),
          const SizedBox(height: 18),
          _AuthCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const _FieldLabel(text: 'Kode OTP 6 digit'),
                const SizedBox(height: 12),
                const _OtpFields(),
                const SizedBox(height: 12),
                Text(
                  'Kode dikirim ke email atau nomor yang terdaftar.',
                  style: _bodyStyle(size: 12.5),
                ),
                const SizedBox(height: 16),
                _PrimaryButton(
                  label: 'Verifikasi',
                  onPressed: () => context.go('/auth-success'),
                ),
                const SizedBox(height: 10),
                _SecondaryButton(
                  label: 'Kirim ulang kode',
                  onPressed: () => context.go('/verification-sent'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _AuthFooterLine(
            prompt: 'Pakai password saja?',
            action: 'Kembali ke login',
            onTap: () => context.go('/login'),
          ),
        ],
      ),
    );
  }
}

class RegisterPage extends ConsumerStatefulWidget {
  const RegisterPage({super.key});

  @override
  ConsumerState<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends ConsumerState<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _acceptTerms = true;
  bool _registerSuccess = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _register() {
    if (!(_formKey.currentState?.validate() ?? false) || !_acceptTerms) return;
    ref.read(authProvider.notifier).register({
      'name': _nameController.text.trim(),
      'email': _emailController.text.trim(),
      'phone': _phoneController.text.trim(),
      'password': _passwordController.text,
      'password_confirmation': _confirmPasswordController.text,
    });
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    if (authState.isAuthenticated && !_registerSuccess) {
      _registerSuccess = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.go('/home');
      });
    }

    return AuthShell(
      showBack: true,
      onBack: () => context.go('/get-started'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _LogoBadge(),
          const SizedBox(height: 18),
          Text('Buat akun baru', style: _titleStyle(size: 27)),
          const SizedBox(height: 8),
          Text(
            'Daftar untuk mulai memesan tiket bus dengan mudah.',
            style: _bodyStyle(),
          ),
          const SizedBox(height: 18),
          _HeroCard(
            title: 'Satu langkah untuk mulai memesan.',
            subtitle:
                'Gunakan data yang umum dipakai saat register: nama, email, nomor, dan password.',
            imageAsset: 'assets/images/bentas01.webp',
            highlights: const ['Nama', 'Email', 'Nomor'],
          ),
          const SizedBox(height: 20),
          _AuthCard(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (authState.error != null) ...[
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFEF2F2),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFFECACA)),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.error_outline,
                              size: 18, color: Color(0xFFDC2626)),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              authState.error!,
                              style: _bodyStyle(
                                  size: 13,
                                  color: const Color(0xFFDC2626),
                                  weight: FontWeight.w500),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),
                  ],
                  const _FieldLabel(text: 'Nama lengkap'),
                  const SizedBox(height: 8),
                  _TextFieldWrap(
                    controller: _nameController,
                    hintText: 'Masukkan nama lengkap',
                    prefixIcon: Icons.person_outline,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty)
                        return 'Nama wajib diisi';
                      return null;
                    },
                  ),
                  const SizedBox(height: 14),
                  const _FieldLabel(text: 'Alamat email'),
                  const SizedBox(height: 8),
                  _TextFieldWrap(
                    controller: _emailController,
                    hintText: 'nama@email.com',
                    prefixIcon: Icons.email_outlined,
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty)
                        return 'Email wajib diisi';
                      return null;
                    },
                  ),
                  const SizedBox(height: 14),
                  const _FieldLabel(text: 'Nomor telepon'),
                  const SizedBox(height: 8),
                  _TextFieldWrap(
                    controller: _phoneController,
                    hintText: '08xxxxxxxxxx',
                    prefixIcon: Icons.phone_outlined,
                    keyboardType: TextInputType.phone,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty)
                        return 'Nomor telepon wajib diisi';
                      return null;
                    },
                  ),
                  const SizedBox(height: 14),
                  const _FieldLabel(text: 'Password'),
                  const SizedBox(height: 8),
                  _TextFieldWrap(
                    controller: _passwordController,
                    hintText: 'Minimal 8 karakter',
                    prefixIcon: Icons.lock_outline,
                    obscureText: _obscurePassword,
                    suffix: IconButton(
                      onPressed: () =>
                          setState(() => _obscurePassword = !_obscurePassword),
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        color: AuthStaticPalette.muted,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.length < 8)
                        return 'Password minimal 8 karakter';
                      return null;
                    },
                  ),
                  const SizedBox(height: 14),
                  const _FieldLabel(text: 'Konfirmasi password'),
                  const SizedBox(height: 8),
                  _TextFieldWrap(
                    controller: _confirmPasswordController,
                    hintText: 'Ulangi password',
                    prefixIcon: Icons.lock_reset_outlined,
                    obscureText: true,
                    validator: (value) {
                      if (value != _passwordController.text)
                        return 'Password tidak cocok';
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Checkbox(
                        value: _acceptTerms,
                        activeColor: AppColors.primary,
                        onChanged: (value) =>
                            setState(() => _acceptTerms = value ?? false),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Text(
                            'Saya setuju dengan syarat penggunaan dan kebijakan privasi.',
                            style: _bodyStyle(size: 12.5),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  _PrimaryButton(
                    label: 'Daftar',
                    isBusy: authState.isLoading,
                    onPressed: _register,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          _AuthFooterLine(
            prompt: 'Sudah punya akun?',
            action: 'Masuk',
            onTap: () => context.go('/login'),
          ),
        ],
      ),
    );
  }
}

class OtpPage extends ConsumerStatefulWidget {
  const OtpPage({super.key});

  @override
  ConsumerState<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends ConsumerState<OtpPage> {
  final _otpKey = GlobalKey<_OtpFieldsState>();
  bool _verified = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _sendOtp());
  }

  void _sendOtp() {
    ref.read(authProvider.notifier).sendOtp();
  }

  void _verifyOtp() {
    final otp = _otpKey.currentState?.otp ?? '';
    if (otp.length < 6) return;
    ref.read(authProvider.notifier).verifyOtp(otp);
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    if (authState.isAuthenticated &&
        !authState.needsVerification &&
        !_verified) {
      _verified = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.go('/home');
      });
    }

    final userPhone = authState.user?['phone'] ?? 'nomor Anda';

    return AuthShell(
      showBack: true,
      onBack: () => context.go('/register'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _LogoBadge(),
          const SizedBox(height: 18),
          Text('Verifikasi akun', style: _titleStyle(size: 27)),
          const SizedBox(height: 8),
          Text(
            'Masukkan kode OTP yang dikirim ke $userPhone untuk verifikasi akun Anda.',
            style: _bodyStyle(),
          ),
          const SizedBox(height: 18),
          _AuthCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (authState.error != null) ...[
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFEF2F2),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFFECACA)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.error_outline,
                            size: 18, color: Color(0xFFDC2626)),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            authState.error!,
                            style: _bodyStyle(
                                size: 13,
                                color: const Color(0xFFDC2626),
                                weight: FontWeight.w500),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),
                ],
                const _FieldLabel(text: 'Kode verifikasi 6 digit'),
                const SizedBox(height: 12),
                _OtpFields(key: _otpKey),
                const SizedBox(height: 12),
                Text(
                  authState.otpSent
                      ? 'Kode OTP telah dikirim ke $userPhone'
                      : 'Mengirim kode OTP...',
                  style: _bodyStyle(size: 12.5),
                ),
                const SizedBox(height: 16),
                _PrimaryButton(
                  label: 'Verifikasi',
                  isBusy: authState.isLoading,
                  onPressed: _verifyOtp,
                ),
                const SizedBox(height: 10),
                _SecondaryButton(
                  label: 'Kirim ulang kode',
                  onPressed: authState.isLoading ? null : _sendOtp,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _AuthFooterLine(
            prompt: 'Sudah punya akun?',
            action: 'Masuk',
            onTap: () => context.go('/login'),
          ),
        ],
      ),
    );
  }
}

class VerificationSentPage extends StatelessWidget {
  const VerificationSentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AuthShell(
      showBack: true,
      onBack: () => context.go('/register'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _LogoBadge(),
          const SizedBox(height: 18),
          Text('Kode verifikasi dikirim', style: _titleStyle(size: 27)),
          const SizedBox(height: 8),
          Text(
            'Page ini bisa dipakai ulang untuk register ataupun forgot password.',
            style: _bodyStyle(),
          ),
          const SizedBox(height: 18),
          _AuthCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _HeroCard(
                  title: 'Cek inbox atau SMS Anda.',
                  subtitle:
                      'Kode OTP dan instruksi berikutnya disiapkan agar backend tinggal mengirim data ke screen ini.',
                  imageAsset: 'assets/images/rute.png',
                  highlights: const ['OTP masuk', 'Resend', 'Validasi'],
                ),
                const SizedBox(height: 16),
                _PrimaryButton(
                  label: 'Lanjut ke OTP',
                  onPressed: () => context.go('/otp'),
                ),
                const SizedBox(height: 10),
                _SecondaryButton(
                  label: 'Pakai login password',
                  onPressed: () => context.go('/login'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AuthShell(
      showBack: true,
      onBack: () => context.go('/login'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _LogoBadge(),
          const SizedBox(height: 18),
          Text('Lupa password', style: _titleStyle(size: 27)),
          const SizedBox(height: 8),
          Text(
            'Masukkan email untuk mengirimkan kode reset password.',
            style: _bodyStyle(),
          ),
          const SizedBox(height: 18),
          _AuthCard(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const _FieldLabel(text: 'Email akun'),
                  const SizedBox(height: 8),
                  _TextFieldWrap(
                    controller: _emailController,
                    hintText: 'nama@email.com',
                    prefixIcon: Icons.mail_outline,
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty)
                        return 'Email wajib diisi';
                      return null;
                    },
                  ),
                  const SizedBox(height: 14),
                  _PrimaryButton(
                    label: 'Kirim kode reset',
                    onPressed: () {
                      if (_formKey.currentState?.validate() ?? false) {
                        context.go('/verification-sent');
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          _AuthFooterLine(
            prompt: 'Ingat password Anda?',
            action: 'Kembali ke login',
            onTap: () => context.go('/login'),
          ),
        ],
      ),
    );
  }
}

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({super.key});

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AuthShell(
      showBack: true,
      onBack: () => context.go('/verification-sent'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _LogoBadge(),
          const SizedBox(height: 18),
          Text('Atur password baru', style: _titleStyle(size: 27)),
          const SizedBox(height: 8),
          Text(
            'Form ini disiapkan supaya backend reset password tinggal mengisi endpoint.',
            style: _bodyStyle(),
          ),
          const SizedBox(height: 18),
          _AuthCard(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const _FieldLabel(text: 'Password baru'),
                  const SizedBox(height: 8),
                  _TextFieldWrap(
                    controller: _passwordController,
                    hintText: 'Minimal 8 karakter',
                    prefixIcon: Icons.lock_outline,
                    obscureText: _obscurePassword,
                    suffix: IconButton(
                      onPressed: () =>
                          setState(() => _obscurePassword = !_obscurePassword),
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        color: AuthStaticPalette.muted,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.length < 8)
                        return 'Password minimal 8 karakter';
                      return null;
                    },
                  ),
                  const SizedBox(height: 14),
                  const _FieldLabel(text: 'Konfirmasi password baru'),
                  const SizedBox(height: 8),
                  _TextFieldWrap(
                    controller: _confirmController,
                    hintText: 'Ulangi password baru',
                    prefixIcon: Icons.lock_reset_outlined,
                    obscureText: true,
                    validator: (value) {
                      if (value != _passwordController.text)
                        return 'Password tidak cocok';
                      return null;
                    },
                  ),
                  const SizedBox(height: 14),
                  _PrimaryButton(
                    label: 'Simpan password',
                    onPressed: () {
                      if (_formKey.currentState?.validate() ?? false) {
                        context.go('/reset-success');
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          _AuthFooterLine(
            prompt: 'Sudah punya password baru?',
            action: 'Masuk lagi',
            onTap: () => context.go('/login'),
          ),
        ],
      ),
    );
  }
}

class ResetSuccessPage extends StatelessWidget {
  const ResetSuccessPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AuthShell(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          const _LogoBadge(),
          const SizedBox(height: 18),
          _AuthCard(
            child: Column(
              children: [
                Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFEEF1),
                    borderRadius: BorderRadius.circular(22),
                  ),
                  child: const Icon(
                    Icons.verified_rounded,
                    color: AppColors.primary,
                    size: 38,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Password berhasil diperbarui',
                  style: _titleStyle(size: 24),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Setelah backend disambungkan, halaman ini bisa ditampilkan saat reset password sukses.',
                  style: _bodyStyle(),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 18),
                _PrimaryButton(
                  label: 'Masuk sekarang',
                  onPressed: () => context.go('/login'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class AuthSuccessPage extends StatelessWidget {
  const AuthSuccessPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AuthShell(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _LogoBadge(),
          const SizedBox(height: 18),
          _HeroCard(
            title: 'Akun siap dipakai.',
            subtitle:
                'Halaman sukses serbaguna ini bisa dipakai sebagai penutup flow OTP atau login nanti.',
            imageAsset: 'assets/images/bentas03.webp',
            highlights: const ['Aman', 'Cepat', 'Siap'],
          ),
          const SizedBox(height: 20),
          _AuthCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Berhasil', style: _titleStyle(size: 24)),
                const SizedBox(height: 8),
                Text(
                  'Struktur halaman sudah siap. Backend tinggal dihubungkan ke form yang sama.',
                  style: _bodyStyle(),
                ),
                const SizedBox(height: 16),
                _PrimaryButton(
                  label: 'Kembali ke login',
                  onPressed: () => context.go('/login'),
                ),
                const SizedBox(height: 10),
                _SecondaryButton(
                  label: 'Mulai dari awal',
                  onPressed: () => context.go('/get-started'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
