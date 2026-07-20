import 'package:flutter/material.dart';

import '../../../../core/config/app_theme.dart';

class PromoPage extends StatelessWidget {
  const PromoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Promo'),
        backgroundColor: Colors.white,
        foregroundColor: AppColors.primaryText,
        elevation: 0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.local_offer_outlined, size: 64, color: AppColors.primaryLight),
            const SizedBox(height: 16),
            Text(
              'Promo Menarik',
              style: AppTextStyles.h2,
            ),
            const SizedBox(height: 8),
            Text(
              'Saat ini belum ada promo yang tersedia.',
              style: AppTextStyles.body,
            ),
          ],
        ),
      ),
    );
  }
}
