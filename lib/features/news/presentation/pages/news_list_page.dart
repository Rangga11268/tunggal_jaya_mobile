import 'package:flutter/material.dart';
import '../../../auth/presentation/pages/auth_shared.dart';
import '../../../../core/config/app_theme.dart';

class NewsListPage extends StatelessWidget {
  const NewsListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _PageHeader(
          title: 'Berita',
          subtitle: 'Informasi dan pengumuman terbaru',
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              _CategoryChip(label: 'Semua', isActive: true),
              const SizedBox(width: 8),
              _CategoryChip(label: 'Berita', isActive: false),
              const SizedBox(width: 8),
              _CategoryChip(label: 'Promo', isActive: false),
            ],
          ),
        ),
        const SizedBox(height: 14),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: 3,
            itemBuilder: (context, index) {
              return Container(
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AuthPalette.border),
                ),
                clipBehavior: Clip.antiAlias,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 180,
                      color: AuthPalette.background,
                      child: Center(
                        child: ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(20)),
                          child: Image.asset(
                            'assets/images/bentas0${index + 1}.webp',
                            width: double.infinity,
                            height: 180,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => const Icon(
                              Icons.image_outlined,
                              size: 48,
                              color: AuthPalette.muted,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: AppColors.primary
                                      .withValues(alpha: 0.08),
                                  borderRadius: BorderRadius.circular(999),
                                ),
                                child: Text(
                                  'Berita',
                                  style: authBodyStyle(
                                    size: 11,
                                    weight: FontWeight.w700,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Icon(Icons.calendar_today_rounded,
                                  size: 12, color: AuthPalette.muted),
                              const SizedBox(width: 4),
                              Text(
                                '05 Mar 2026',
                                style: authBodyStyle(
                                    size: 11, color: AuthPalette.muted),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Judul Berita Menarik',
                            style: authBodyStyle(
                                size: 16,
                                weight: FontWeight.w600,
                                color: AuthPalette.textPrimary),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Deskripsi singkat berita akan ditampilkan di sini...',
                            style: authBodyStyle(size: 13),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                'Baca Selengkapnya',
                                style: authBodyStyle(
                                  size: 12,
                                  weight: FontWeight.w600,
                                  color: AppColors.primary,
                                ),
                              ),
                              const SizedBox(width: 2),
                              const Icon(Icons.chevron_right,
                                  size: 16, color: AppColors.primary),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
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

class _CategoryChip extends StatelessWidget {
  final String label;
  final bool isActive;

  const _CategoryChip({required this.label, required this.isActive});

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
