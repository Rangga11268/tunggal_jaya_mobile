import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/config/app_theme.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final user = authState.user;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // ========== HEADER ==========
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(24, 60, 24, 32),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF0B0B0B),
                    Color(0xFF1A1A1A),
                  ],
                ),
              ),
              child: Column(
                children: [
                  Container(
                    width: 88,
                    height: 88,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: Colors.white.withValues(alpha: 0.2), width: 2),
                    ),
                    child: Center(
                      child: Text(
                        (user?['name'] as String? ?? 'U').substring(0, 1).toUpperCase(),
                        style: AppTextStyles.heroTitle.copyWith(fontSize: 32),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    user?['name'] as String? ?? 'User',
                    style: AppTextStyles.h2.copyWith(color: Colors.white),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    user?['email'] as String? ?? '',
                    style: AppTextStyles.caption.copyWith(color: Colors.white54),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppColors.success.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.check_circle, color: AppColors.success, size: 16),
                        const SizedBox(width: 6),
                        const Text(
                          'Terverifikasi',
                          style: TextStyle(color: AppColors.success, fontSize: 13, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // ========== MENU ==========
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  _MenuCard(
                    icon: Icons.person_outlined,
                    iconColor: AppColors.primary,
                    label: 'Edit Profil',
                    subtitle: 'Ubah data diri Anda',
                    onTap: () {},
                  ),
                  const SizedBox(height: 8),
                  _MenuCard(
                    icon: Icons.phone_outlined,
                    iconColor: const Color(0xFF8B5CF6),
                    label: 'Verifikasi Nomor',
                    subtitle: 'Verifikasi nomor telepon Anda',
                    onTap: () {},
                  ),
                  const SizedBox(height: 8),
                  _MenuCard(
                    icon: Icons.lock_outlined,
                    iconColor: AppColors.accent,
                    label: 'Ubah Password',
                    subtitle: 'Perbarui kata sandi Anda',
                    onTap: () {},
                  ),
                  const SizedBox(height: 8),
                  _MenuCard(
                    icon: Icons.confirmation_number_outlined,
                    iconColor: const Color(0xFF0EA5E9),
                    label: 'Riwayat Pesanan',
                    subtitle: 'Lihat riwayat pemesanan tiket',
                    onTap: () {},
                  ),
                  const SizedBox(height: 8),
                  _MenuCard(
                    icon: Icons.help_outline,
                    iconColor: AppColors.disabled,
                    label: 'Pusat Bantuan',
                    subtitle: 'FAQ & Hubungi kami',
                    onTap: () {},
                  ),
                  const SizedBox(height: 8),
                  _MenuCard(
                    icon: Icons.info_outline,
                    iconColor: AppColors.disabled,
                    label: 'Tentang Aplikasi',
                    subtitle: 'Versi 1.0.0',
                    onTap: () {},
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: ElevatedButton(
                      onPressed: () => ref.read(authProvider.notifier).logout(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.error.withValues(alpha: 0.1),
                        foregroundColor: AppColors.error,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.logout, size: 20),
                          SizedBox(width: 8),
                          Text(
                            'Keluar',
                            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MenuCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final String subtitle;
  final VoidCallback onTap;

  const _MenuCard({
    required this.icon,
    required this.iconColor,
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
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: iconColor, size: 22),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: AppTextStyles.bodyMedium),
                  const SizedBox(height: 2),
                  Text(subtitle, style: AppTextStyles.caption.copyWith(fontSize: 12)),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: AppColors.disabled, size: 22),
          ],
        ),
      ),
    );
  }
}
