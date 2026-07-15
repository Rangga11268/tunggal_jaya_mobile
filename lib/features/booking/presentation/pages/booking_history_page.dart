import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../auth/presentation/pages/auth_shared.dart';
import '../../../../core/config/app_theme.dart';
import '../../../../core/network/api_client.dart';

final bookingsProvider = FutureProvider<List<dynamic>>((ref) async {
  final apiClient = ref.read(apiClientProvider);
  final response = await apiClient.get('/bookings');
  return response['data'] ?? [];
});

class BookingHistoryPage extends ConsumerStatefulWidget {
  const BookingHistoryPage({super.key});

  @override
  ConsumerState<BookingHistoryPage> createState() => _BookingHistoryPageState();
}

class _BookingHistoryPageState extends ConsumerState<BookingHistoryPage> {
  String _activeTab = 'Aktif'; // 'Aktif', 'Selesai', 'Dibatalkan'

  @override
  Widget build(BuildContext context) {
    final bookingsAsync = ref.watch(bookingsProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _PageHeader(
          title: 'Pesanan Saya',
          subtitle: 'Kelola semua pemesanan tiket Anda',
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              _buildTab('Aktif'),
              const SizedBox(width: 8),
              _buildTab('Selesai'),
              const SizedBox(width: 8),
              _buildTab('Dibatalkan'),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Expanded(
          child: bookingsAsync.when(
            data: (bookings) {
              final filtered = _filterBookings(bookings);
              if (filtered.isEmpty) {
                return const _EmptyState();
              }
              return RefreshIndicator(
                onRefresh: () => ref.refresh(bookingsProvider.future),
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  itemCount: filtered.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    return _TicketCard(booking: filtered[index]);
                  },
                ),
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, stack) => Center(
              child: Text('Gagal memuat tiket: $err', style: authBodyStyle(color: AppColors.error)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTab(String label) {
    final isActive = _activeTab == label;
    return GestureDetector(
      onTap: () => setState(() => _activeTab = label),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(999),
          border: isActive ? null : Border.all(color: AuthPalette.border),
        ),
        child: Text(
          label,
          style: authBodyStyle(
            size: 13,
            weight: FontWeight.w600,
            color: isActive ? Colors.white : AuthPalette.textPrimary,
          ),
        ),
      ),
    );
  }

  List<dynamic> _filterBookings(List<dynamic> all) {
    return all.where((b) {
      final status = (b['booking_status'] ?? '').toString().toLowerCase();
      if (_activeTab == 'Aktif') {
        return status == 'pending' || status == 'completed'; 
      } else if (_activeTab == 'Selesai') {
        return status == 'used' || status == 'finished'; 
      } else {
        return status == 'cancelled';
      }
    }).toList();
  }
}

class _TicketCard extends StatelessWidget {
  final Map<String, dynamic> booking;

  const _TicketCard({required this.booking});

  @override
  Widget build(BuildContext context) {
    final schedule = booking['schedule'] ?? {};
    final route = schedule['route'] ?? {};
    
    final status = booking['booking_status'] ?? 'pending';
    String displayDate = booking['booking_date'] ?? '';
    try {
      final parsedDate = DateTime.parse(displayDate);
      displayDate = DateFormat('dd MMM yyyy', 'id_ID').format(parsedDate);
    } catch (_) {}
    
    final departureTime = schedule['departure_time'] != null ? schedule['departure_time'].toString().substring(0, 5) : '--:--';
    final formatCurrency = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
    final price = formatCurrency.format(double.tryParse(booking['total_price'].toString()) ?? 0);

    return GestureDetector(
      onTap: () {
        context.push('/ticket-detail', extra: booking);
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AuthPalette.border),
          boxShadow: AppShadows.soft,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getStatusColor(status).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    status.toString().toUpperCase(),
                    style: authBodyStyle(size: 11, weight: FontWeight.w700, color: _getStatusColor(status)),
                  ),
                ),
                Text(
                  booking['booking_code'] ?? '-',
                  style: authTitleStyle(size: 14, color: AppColors.primary),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(route['origin'] ?? 'Asal', style: authTitleStyle(size: 16)),
                      const SizedBox(height: 4),
                      Text('$displayDate, $departureTime', style: authBodyStyle(size: 13, color: AuthPalette.textSecondary)),
                    ],
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  child: Icon(Icons.arrow_forward_rounded, color: AppColors.muted, size: 20),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(route['destination'] ?? 'Tujuan', style: authTitleStyle(size: 16)),
                      const SizedBox(height: 4),
                      Text('${booking['seat_numbers'] ?? '-'}', style: authBodyStyle(size: 13, weight: FontWeight.w700, color: AppColors.primary)),
                    ],
                  ),
                ),
              ],
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Divider(color: AuthPalette.border),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Total Harga', style: authBodyStyle(color: AuthPalette.textSecondary)),
                Text(price, style: authTitleStyle(size: 16)),
              ],
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

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
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
              onPressed: () {
                context.go('/home'); // Or /routes
              },
            ),
          ),
        ],
      ),
    );
  }
}
