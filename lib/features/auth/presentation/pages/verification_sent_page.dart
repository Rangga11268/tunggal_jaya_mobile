import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'auth_shared.dart';

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
          const AuthLogoBadge(),
          const SizedBox(height: 18),
          Text('Kode verifikasi dikirim', style: authTitleStyle(size: 27)),
          const SizedBox(height: 8),
          Text(
            'Cek email atau SMS Anda untuk kode OTP.',
            style: authBodyStyle(),
          ),
          const SizedBox(height: 18),
          AuthCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AuthHeroCard(
                  title: 'Cek inbox atau SMS Anda.',
                  subtitle:
                      'Kode OTP dan instruksi berikutnya sudah dikirim.',
                  imageAsset: 'assets/images/rute.png',
                  highlights: const ['OTP masuk', 'Resend', 'Validasi'],
                ),
                const SizedBox(height: 16),
                AuthPrimaryButton(
                  label: 'Lanjut ke OTP',
                  onPressed: () => context.go('/otp'),
                ),
                const SizedBox(height: 10),
                AuthSecondaryButton(
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
