import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'auth_shared.dart';
import '../../../../core/config/app_theme.dart';

class ResetSuccessPage extends StatelessWidget {
  const ResetSuccessPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AuthShell(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          const AuthLogoBadge(),
          const SizedBox(height: 18),
          AuthCard(
            child: Column(
              children: [
                Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFEEF1),
                    borderRadius: BorderRadius.circular(22),
                  ),
                  child: const Icon(
                    Icons.verified_rounded,
                    color: AppColors.primary,
                    size: 38,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Password berhasil diperbarui',
                  style: authTitleStyle(size: 24),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Silakan masuk dengan password baru Anda.',
                  style: authBodyStyle(),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 18),
                AuthPrimaryButton(
                  label: 'Masuk sekarang',
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
