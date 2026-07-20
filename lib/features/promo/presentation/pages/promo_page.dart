import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/config/app_theme.dart';
import '../../../../core/widgets/tj_page_header.dart';
import '../../../../core/widgets/tj_background.dart';

class PromoPage extends StatelessWidget {
  const PromoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: TjBackground(
        child: Column(
          children: [
            const TjPageHeader(
              title: 'Promo Spesial',
              subtitle: 'Penawaran menarik untuk Anda',
              showBackButton: true,
            ),
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: AppColors.primaryLight,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(LucideIcons.tags, size: 48, color: AppColors.primary),
                    ),
                    const SizedBox(height: 24),
                    Text('Belum Ada Promo', style: AppTextStyles.h3),
                    const SizedBox(height: 8),
                    Text('Saat ini belum ada promo yang tersedia.\nSilakan periksa kembali nanti.', textAlign: TextAlign.center, style: AppTextStyles.bodySmall),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
