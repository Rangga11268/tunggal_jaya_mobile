import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../auth/presentation/pages/auth_shared.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../../core/config/app_theme.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final user = authState.user;

    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(
                  bottom: BorderSide(color: AuthPalette.border)),
            ),
            child: Column(
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                        color: AuthPalette.border, width: 1.5),
                  ),
                  child: Center(
                    child: Text(
                      (user?['name'] as String? ?? 'U')
                          .substring(0, 1)
                          .toUpperCase(),
                      style: authTitleStyle(size: 28, color: AppColors.primary),
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  user?['name'] as String? ?? 'User',
                  style: authBodyStyle(
                    size: 18,
                    weight: FontWeight.w700,
                    color: AuthPalette.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  user?['email'] as String? ?? '',
                  style: authBodyStyle(size: 13),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.success.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.check_circle,
                          color: AppColors.success, size: 14),
                      const SizedBox(width: 6),
                      Text(
                        'Terverifikasi',
                        style: authBodyStyle(
                          size: 12,
                          weight: FontWeight.w600,
                          color: AppColors.success,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                _MenuCard(
                  icon: Icons.person_outline,
                  label: 'Edit Profil',
                  subtitle: 'Ubah data diri Anda',
                  onTap: () {},
                ),
                const SizedBox(height: 8),
                _MenuCard(
                  icon: Icons.phone_outlined,
                  label: 'Verifikasi Nomor',
                  subtitle: 'Verifikasi nomor telepon Anda',
                  onTap: () {},
                ),
                const SizedBox(height: 8),
                _MenuCard(
                  icon: Icons.lock_outline,
                  label: 'Ubah Password',
                  subtitle: 'Perbarui kata sandi Anda',
                  onTap: () {},
                ),
                const SizedBox(height: 8),
                _MenuCard(
                  icon: Icons.confirmation_number_outlined,
                  label: 'Riwayat Pesanan',
                  subtitle: 'Lihat riwayat pemesanan tiket',
                  onTap: () => context.go('/bookings'),
                ),
                const SizedBox(height: 8),
                _MenuCard(
                  icon: Icons.help_outline,
                  label: 'Pusat Bantuan',
                  subtitle: 'FAQ & Hubungi kami',
                  onTap: () {},
                ),
                const SizedBox(height: 8),
                _MenuCard(
                  icon: Icons.info_outline,
                  label: 'Tentang Aplikasi',
                  subtitle: 'Versi 1.0.0',
                  onTap: () {},
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: OutlinedButton.icon(
                    onPressed: () =>
                        ref.read(authProvider.notifier).logout(),
                    icon: const Icon(Icons.logout, size: 18),
                    label: Text(
                      'Keluar',
                      style: authBodyStyle(
                        size: 15,
                        weight: FontWeight.w700,
                        color: AppColors.error,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      backgroundColor: AppColors.error
                          .withValues(alpha: 0.06),
                      side: const BorderSide(
                          color: AppColors.error, width: 0.5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MenuCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String subtitle;
  final VoidCallback onTap;

  const _MenuCard({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AuthPalette.border),
          boxShadow: AppShadows.card,
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon,
                  color: AppColors.primary, size: 20),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label,
                      style: authBodyStyle(
                          size: 14,
                          weight: FontWeight.w600,
                          color: AuthPalette.textPrimary)),
                  const SizedBox(height: 2),
                  Text(subtitle,
                      style: authBodyStyle(
                          size: 12, color: AuthPalette.textSecondary)),
                ],
              ),
            ),
            Icon(Icons.chevron_right,
                color: AuthPalette.muted, size: 20),
          ],
        ),
      ),
    );
  }
}
