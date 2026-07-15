import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:intl/intl.dart';
import '../../../../core/config/app_theme.dart';
import '../../../../features/auth/presentation/pages/auth_shared.dart';

class TicketDetailPage extends ConsumerWidget {
  final Map<String, dynamic> booking;

  const TicketDetailPage({super.key, required this.booking});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final schedule = booking['schedule'] ?? {};
    final route = schedule['route'] ?? {};
    final bus = schedule['bus'] ?? {};

    final bookingCode = booking['booking_code'] ?? 'UNKNOWN';
    final status = booking['booking_status'] ?? 'pending';
    final paymentStatus = booking['payment_status'] ?? 'pending';

    String displayDate = booking['booking_date'] ?? '';
    try {
      final parsedDate = DateTime.parse(displayDate);
      displayDate = DateFormat('EEEE, dd MMM yyyy', 'id_ID').format(parsedDate);
    } catch (_) {}

    final departureTime = schedule['departure_time'] != null ? schedule['departure_time'].toString().substring(0, 5) : '--:--';
    final formatCurrency = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
    final price = formatCurrency.format(double.tryParse(booking['total_price'].toString()) ?? 0);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('E-Ticket'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: AppShadows.card,
              ),
              child: Column(
                children: [
                  // Header (Status)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      color: _getStatusColor(status).withValues(alpha: 0.1),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        _getStatusText(status),
                        style: authBodyStyle(
                          size: 16,
                          weight: FontWeight.w700,
                          color: _getStatusColor(status),
                        ),
                      ),
                    ),
                  ),
                  
                  // Route & Time
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(route['origin'] ?? 'Asal', style: authTitleStyle(size: 20)),
                            const Icon(Icons.arrow_forward_rounded, color: AppColors.muted),
                            Text(route['destination'] ?? 'Tujuan', style: authTitleStyle(size: 20)),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Keberangkatan', style: authBodyStyle(size: 13, color: AuthPalette.textSecondary)),
                                const SizedBox(height: 4),
                                Text(displayDate, style: authBodyStyle(weight: FontWeight.w600)),
                                Text(departureTime, style: authTitleStyle(size: 18, color: AppColors.primary)),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const _DashedSeparator(),

                  // Passenger & Bus Details
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        _DetailRow(label: 'Kode Pemesanan', value: bookingCode, valueStyle: authTitleStyle(size: 16)),
                        const SizedBox(height: 12),
                        _DetailRow(label: 'Nama Penumpang', value: booking['passenger_name'] ?? '-'),
                        const SizedBox(height: 12),
                        _DetailRow(label: 'Armada Bus', value: bus['name'] ?? '-'),
                        const SizedBox(height: 12),
                        _DetailRow(label: 'Nomor Kursi', value: booking['seat_numbers'] ?? '-', valueStyle: authBodyStyle(weight: FontWeight.w700, color: AppColors.primary)),
                        const SizedBox(height: 12),
                        _DetailRow(label: 'Total Pembayaran', value: price),
                        const SizedBox(height: 12),
                        _DetailRow(label: 'Status Pembayaran', value: paymentStatus.toUpperCase()),
                      ],
                    ),
                  ),

                  const _DashedSeparator(),

                  // QR Code
                  Padding(
                    padding: const EdgeInsets.all(32),
                    child: Column(
                      children: [
                        Text('Tunjukkan QR Code ini kepada petugas', 
                          style: authBodyStyle(size: 13, color: AuthPalette.textSecondary),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        QrImageView(
                          data: bookingCode,
                          version: QrVersions.auto,
                          size: 200.0,
                          backgroundColor: Colors.white,
                        ),
                        const SizedBox(height: 16),
                        Text(bookingCode, style: authTitleStyle(size: 24).copyWith(letterSpacing: 2)),
                      ],
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

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'completed': return AppColors.success;
      case 'pending': return Colors.orange;
      case 'cancelled': return AppColors.error;
      default: return AppColors.primary;
    }
  }

  String _getStatusText(String status) {
    switch (status.toLowerCase()) {
      case 'completed': return 'TIKET AKTIF';
      case 'pending': return 'MENUNGGU PEMBAYARAN';
      case 'cancelled': return 'DIBATALKAN';
      default: return status.toUpperCase();
    }
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  final TextStyle? valueStyle;

  const _DetailRow({required this.label, required this.value, this.valueStyle});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: authBodyStyle(color: AuthPalette.textSecondary)),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            value,
            style: valueStyle ?? authBodyStyle(weight: FontWeight.w600),
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }
}

class _DashedSeparator extends StatelessWidget {
  const _DashedSeparator();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          final boxWidth = constraints.constrainWidth();
          const dashWidth = 5.0;
          const dashHeight = 1.0;
          final dashCount = (boxWidth / (2 * dashWidth)).floor();
          return Flex(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            direction: Axis.horizontal,
            children: List.generate(dashCount, (_) {
              return SizedBox(
                width: dashWidth,
                height: dashHeight,
                child: const DecoratedBox(
                  decoration: BoxDecoration(color: AuthPalette.border),
                ),
              );
            }),
          );
        },
      ),
    );
  }
}
