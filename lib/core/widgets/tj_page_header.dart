import 'package:flutter/material.dart';
import '../config/app_theme.dart';
import '../../../features/auth/presentation/pages/auth_shared.dart';

class TjPageHeader extends StatelessWidget {
  final String title;
  final String subtitle;

  const TjPageHeader({
    super.key,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: AuthPalette.border)),
      ),
      child: SafeArea(
        bottom: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: authTitleStyle(size: 24)),
                  const SizedBox(height: 4),
                  Text(subtitle, style: authBodyStyle()),
                ],
              ),
            ),
            // TJ Logo on the right
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AuthPalette.border),
                boxShadow: [
                  BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 4)),
                ]
              ),
              child: Row(
                children: [
                  Image.asset('assets/logo/logoNoBg.png', width: 24, height: 24, fit: BoxFit.contain),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
