import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'auth_shared.dart';

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
          const AuthLogoBadge(),
          const SizedBox(height: 18),
          Text('Lupa password', style: authTitleStyle(size: 27)),
          const SizedBox(height: 8),
          Text(
            'Masukkan email untuk mengirimkan kode reset password.',
            style: authBodyStyle(),
          ),
          const SizedBox(height: 18),
          AuthCard(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const AuthFieldLabel(text: 'Email akun'),
                  const SizedBox(height: 8),
                  AuthTextField(
                    controller: _emailController,
                    hintText: 'nama@email.com',
                    prefixIcon: Icons.mail_outline,
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Email wajib diisi';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 14),
                  AuthPrimaryButton(
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
          AuthFooterLine(
            prompt: 'Ingat password Anda?',
            action: 'Kembali ke login',
            onTap: () => context.go('/login'),
          ),
        ],
      ),
    );
  }
}
