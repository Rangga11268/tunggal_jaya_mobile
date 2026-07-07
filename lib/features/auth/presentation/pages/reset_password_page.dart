import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'auth_shared.dart';

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
          const AuthLogoBadge(),
          const SizedBox(height: 18),
          Text('Atur password baru', style: authTitleStyle(size: 27)),
          const SizedBox(height: 8),
          Text(
            'Masukkan password baru untuk akun Anda.',
            style: authBodyStyle(),
          ),
          const SizedBox(height: 18),
          AuthCard(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const AuthFieldLabel(text: 'Password baru'),
                  const SizedBox(height: 8),
                  AuthTextField(
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
                        color: AuthPalette.muted,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.length < 8) {
                        return 'Password minimal 8 karakter';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 14),
                  const AuthFieldLabel(text: 'Konfirmasi password baru'),
                  const SizedBox(height: 8),
                  AuthTextField(
                    controller: _confirmController,
                    hintText: 'Ulangi password baru',
                    prefixIcon: Icons.lock_reset_outlined,
                    obscureText: true,
                    validator: (value) {
                      if (value != _passwordController.text) {
                        return 'Password tidak cocok';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 14),
                  AuthPrimaryButton(
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
          AuthFooterLine(
            prompt: 'Sudah punya password baru?',
            action: 'Masuk lagi',
            onTap: () => context.go('/login'),
          ),
        ],
      ),
    );
  }
}
