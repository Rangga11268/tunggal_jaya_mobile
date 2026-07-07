import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'auth_shared.dart';
import '../providers/auth_provider.dart';

class OtpPage extends ConsumerStatefulWidget {
  const OtpPage({super.key});

  @override
  ConsumerState<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends ConsumerState<OtpPage> {
  final _otpKey = GlobalKey<AuthOtpFieldsState>();
  bool _verified = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _sendOtp());
  }

  void _sendOtp() {
    ref.read(authProvider.notifier).sendOtp();
  }

  void _verifyOtp() {
    final otp = _otpKey.currentState?.otp ?? '';
    if (otp.length < 6) return;
    ref.read(authProvider.notifier).verifyOtp(otp);
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    if (authState.isAuthenticated &&
        !authState.needsVerification &&
        !_verified) {
      _verified = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.go('/home');
      });
    }

    final userPhone = authState.user?['phone'] ?? 'nomor Anda';

    return AuthShell(
      showBack: true,
      onBack: () => context.go('/register'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AuthLogoBadge(),
          const SizedBox(height: 18),
          Text('Verifikasi akun', style: authTitleStyle(size: 27)),
          const SizedBox(height: 8),
          Text(
            'Masukkan kode OTP yang dikirim ke $userPhone.',
            style: authBodyStyle(),
          ),
          const SizedBox(height: 18),
          AuthCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (authState.error != null) ...[
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFEF2F2),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFFECACA)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.error_outline,
                            size: 18, color: Color(0xFFDC2626)),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            authState.error!,
                            style: authBodyStyle(
                                size: 13,
                                color: const Color(0xFFDC2626),
                                weight: FontWeight.w500),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),
                ],
                const AuthFieldLabel(text: 'Kode verifikasi 6 digit'),
                const SizedBox(height: 12),
                AuthOtpFields(key: _otpKey),
                const SizedBox(height: 12),
                Text(
                  authState.otpSent
                      ? 'Kode OTP telah dikirim ke $userPhone'
                      : 'Mengirim kode OTP...',
                  style: authBodyStyle(size: 12.5),
                ),
                const SizedBox(height: 16),
                AuthPrimaryButton(
                  label: 'Verifikasi',
                  isBusy: authState.isLoading,
                  onPressed: _verifyOtp,
                ),
                const SizedBox(height: 10),
                AuthSecondaryButton(
                  label: 'Kirim ulang kode',
                  onPressed: authState.isLoading ? null : _sendOtp,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          AuthFooterLine(
            prompt: 'Sudah punya akun?',
            action: 'Masuk',
            onTap: () => context.go('/login'),
          ),
        ],
      ),
    );
  }
}
