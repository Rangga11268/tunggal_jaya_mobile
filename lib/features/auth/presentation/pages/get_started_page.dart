import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'auth_shared.dart';

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
              const AuthLogoBadge(),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tunggal Jaya',
                      style: authBodyStyle(
                        size: 18,
                        weight: FontWeight.w700,
                        color: AuthPalette.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Transport',
                      style: authBodyStyle(size: 12.5),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          AuthHeroCard(
            title: 'Pesan tiket bus dengan mudah.',
            subtitle:
                'Cari jadwal, pilih kursi, bayar — semua dalam satu aplikasi.',
            imageAsset: 'assets/images/hero.jpg',
            highlights: const ['Cari jadwal', 'Pilih kursi', 'Bayar'],
          ),
          const SizedBox(height: 20),
          AuthCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const AuthSectionHeader(
                  eyebrow: 'Selamat datang',
                  title: 'Mulai dari akun Anda',
                  subtitle:
                      'Masuk atau daftar untuk mulai memesan tiket bus.',
                ),
                const SizedBox(height: 18),
                AuthPrimaryButton(
                  label: 'Masuk',
                  onPressed: () => context.go('/login'),
                ),
                const SizedBox(height: 10),
                AuthSecondaryButton(
                  label: 'Daftar akun baru',
                  onPressed: () => context.go('/register'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
