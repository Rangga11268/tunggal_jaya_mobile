import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'auth_shared.dart';

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
          const AuthLogoBadge(),
          const SizedBox(height: 18),
          Text('Verifikasi OTP login', style: authTitleStyle(size: 26)),
          const SizedBox(height: 8),
          Text(
            'Masukkan kode OTP yang dikirim ke email atau nomor Anda.',
            style: authBodyStyle(),
          ),
          const SizedBox(height: 18),
          AuthCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const AuthFieldLabel(text: 'Kode OTP 6 digit'),
                const SizedBox(height: 12),
                const AuthOtpFields(),
                const SizedBox(height: 12),
                Text(
                  'Kode dikirim ke email atau nomor yang terdaftar.',
                  style: authBodyStyle(size: 12.5),
                ),
                const SizedBox(height: 16),
                AuthPrimaryButton(
                  label: 'Verifikasi',
                  onPressed: () => context.go('/auth-success'),
                ),
                const SizedBox(height: 10),
                AuthSecondaryButton(
                  label: 'Kirim ulang kode',
                  onPressed: () => context.go('/verification-sent'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          AuthFooterLine(
            prompt: 'Pakai password saja?',
            action: 'Kembali ke login',
            onTap: () => context.go('/login'),
          ),
        ],
      ),
    );
  }
}
