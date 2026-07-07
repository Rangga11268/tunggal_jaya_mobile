import 'package:flutter/material.dart';
import '../config/app_theme.dart';

class StatusBadge extends StatelessWidget {
  final String label;
  final Color? backgroundColor;
  final Color? textColor;
  final bool outlined;

  const StatusBadge({
    super.key,
    required this.label,
    this.backgroundColor,
    this.textColor,
    this.outlined = false,
  });

  factory StatusBadge.payment(String status) {
    switch (status) {
      case 'paid':
        return StatusBadge(
          label: 'Lunas',
          backgroundColor: Colors.green.withValues(alpha: 0.1),
          textColor: AppColors.success,
        );
      case 'pending':
        return StatusBadge(
          label: 'Menunggu',
          backgroundColor: AppColors.warning.withValues(alpha: 0.1),
          textColor: AppColors.warning,
        );
      case 'failed':
        return StatusBadge(
          label: 'Gagal',
          backgroundColor: AppColors.error.withValues(alpha: 0.1),
          textColor: AppColors.error,
        );
      case 'refunded':
        return StatusBadge(
          label: 'Dikembalikan',
          backgroundColor: AppColors.info.withValues(alpha: 0.1),
          textColor: AppColors.info,
        );
      default:
        return StatusBadge(label: status);
    }
  }

  factory StatusBadge.booking(String status) {
    switch (status) {
      case 'confirmed':
        return StatusBadge(
          label: 'Dikonfirmasi',
          backgroundColor: AppColors.success.withValues(alpha: 0.1),
          textColor: AppColors.success,
        );
      case 'pending':
        return StatusBadge(
          label: 'Menunggu',
          backgroundColor: AppColors.warning.withValues(alpha: 0.1),
          textColor: AppColors.warning,
        );
      case 'cancelled':
        return StatusBadge(
          label: 'Dibatalkan',
          backgroundColor: AppColors.error.withValues(alpha: 0.1),
          textColor: AppColors.error,
        );
      case 'completed':
        return StatusBadge(
          label: 'Selesai',
          backgroundColor: AppColors.success.withValues(alpha: 0.1),
          textColor: AppColors.success,
        );
      default:
        return StatusBadge(label: status);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: outlined ? Colors.transparent : (backgroundColor ?? AppColors.primary.withValues(alpha: 0.1)),
        borderRadius: BorderRadius.circular(AppRadius.full),
        border: outlined ? Border.all(color: backgroundColor ?? AppColors.primary.withValues(alpha: 0.3)) : null,
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: textColor ?? AppColors.primary,
          letterSpacing: 0.3,
        ),
      ),
    );
  }
}
