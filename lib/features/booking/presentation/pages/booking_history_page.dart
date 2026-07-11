import 'package:flutter/material.dart';
import '../../../auth/presentation/pages/auth_shared.dart';
import '../../../../core/config/app_theme.dart';

class BookingHistoryPage extends StatelessWidget {
  const BookingHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _PageHeader(
          title: 'Pesanan Saya',
          subtitle: 'Kelola semua pemesanan tiket Anda',
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              _TabChip(label: 'Aktif', isActive: true),
              const SizedBox(width: 8),
              _TabChip(label: 'Selesai', isActive: false),
              const SizedBox(width: 8),
              _TabChip(label: 'Dibatalkan', isActive: false),
            ],
          ),
        ),
        const SizedBox(height: 40),
        Expanded(
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(
                    Icons.confirmation_number_outlined,
                    size: 32,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Belum Ada Pesanan',
                  style: authTitleStyle(size: 20),
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Text(
                    'Pesan tiket bus Anda sekarang dan nikmati perjalanan nyaman',
                    style: authBodyStyle(),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: 180,
                  height: 48,
                  child: AuthPrimaryButton(
                    label: 'Cari Tiket',
                    onPressed: () {},
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _PageHeader extends StatelessWidget {
  final String title;
  final String subtitle;

  const _PageHeader({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: AuthPalette.border)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: authTitleStyle(size: 24)),
          const SizedBox(height: 4),
          Text(subtitle, style: authBodyStyle()),
        ],
      ),
    );
  }
}

class _TabChip extends StatelessWidget {
  final String label;
  final bool isActive;

  const _TabChip({required this.label, required this.isActive});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
      decoration: BoxDecoration(
        color: isActive ? AppColors.primary : Colors.transparent,
        borderRadius: BorderRadius.circular(999),
        border: isActive
            ? null
            : Border.all(color: AuthPalette.border),
      ),
      child: Text(
        label,
        style: authBodyStyle(
          size: 13,
          weight: FontWeight.w600,
          color: isActive ? Colors.white : AuthPalette.textPrimary,
        ),
      ),
    );
  }
}
