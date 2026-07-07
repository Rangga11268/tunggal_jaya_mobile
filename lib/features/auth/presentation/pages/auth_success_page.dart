import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'auth_shared.dart';

class AuthSuccessPage extends StatelessWidget {
  const AuthSuccessPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AuthShell(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AuthLogoBadge(),
          const SizedBox(height: 18),
          AuthHeroCard(
            title: 'Akun siap dipakai.',
            subtitle:
                'Selamat, akun Anda berhasil diverifikasi.',
            imageAsset: 'assets/images/bentas03.webp',
            highlights: const ['Aman', 'Cepat', 'Siap'],
          ),
          const SizedBox(height: 20),
          AuthCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Berhasil', style: authTitleStyle(size: 24)),
                const SizedBox(height: 8),
                Text(
                  'Akun Anda sudah siap digunakan.',
                  style: authBodyStyle(),
                ),
                const SizedBox(height: 16),
                AuthPrimaryButton(
                  label: 'Kembali ke login',
                  onPressed: () => context.go('/login'),
                ),
                const SizedBox(height: 10),
                AuthSecondaryButton(
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
