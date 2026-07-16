import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../auth/presentation/pages/auth_shared.dart';
import '../../../../core/config/app_theme.dart';
import '../../../../core/network/api_client.dart';
import '../../../charter/presentation/providers/charter_provider.dart';

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
  String _mainTab = 'Reguler'; // 'Reguler', 'Pariwisata'
  String _activeTab = 'Aktif'; // 'Aktif', 'Selesai', 'Dibatalkan'

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _PageHeader(
          title: 'Pesanan Saya',
          subtitle: 'Kelola semua pemesanan tiket Anda',
        ),
        const SizedBox(height: 16),
        
        // Main Tab (Reguler vs Pariwisata)
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Container(
            decoration: BoxDecoration(
              color: AuthPalette.background,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AuthPalette.border),
            ),
            child: Row(
              children: [
                Expanded(child: _buildMainTab('Reguler')),
                Expanded(child: _buildMainTab('Pariwisata')),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        
        // Sub Tab (Aktif, Selesai, Dibatalkan)
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildSubTab('Aktif'),
                const SizedBox(width: 8),
                _buildSubTab('Selesai'),
                const SizedBox(width: 8),
                _buildSubTab('Dibatalkan'),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
        
        // Content
        Expanded(
          child: _mainTab == 'Reguler' ? _buildRegulerList() : _buildCharterList(),
        ),
      ],
    );
  }

  Widget _buildMainTab(String label) {
    final isActive = _mainTab == label;
    return GestureDetector(
      onTap: () => setState(() { _mainTab = label; _activeTab = 'Aktif'; }),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isActive ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: authBodyStyle(
            size: 14,
            weight: FontWeight.w600,
            color: isActive ? Colors.white : AuthPalette.textPrimary,
          ),
        ),
      ),
    );
  }

  Widget _buildSubTab(String label) {
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

  Widget _buildRegulerList() {
    final bookingsAsync = ref.watch(bookingsProvider);
    return bookingsAsync.when(
      data: (bookings) {
        final filtered = bookings.where((b) {
          final status = (b['booking_status'] ?? '').toString().toLowerCase();
          if (_activeTab == 'Aktif') return status == 'pending' || status == 'completed'; 
          if (_activeTab == 'Selesai') return status == 'used' || status == 'finished'; 
          return status == 'cancelled';
        }).toList();

        if (filtered.isEmpty) return const _EmptyState();
        return RefreshIndicator(
          onRefresh: () => ref.refresh(bookingsProvider.future),
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            itemCount: filtered.length,
            separatorBuilder: (_, __) => const SizedBox(height: 16),
            itemBuilder: (context, index) => _TicketCard(booking: filtered[index]),
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(child: Text('Gagal memuat tiket: $err')),
    );
  }

  Widget _buildCharterList() {
    final chartersAsync = ref.watch(charterHistoryProvider);
    return chartersAsync.when(
      data: (charters) {
        final filtered = charters.where((c) {
          final status = (c['status'] ?? '').toString().toLowerCase();
          if (_activeTab == 'Aktif') return status == 'pending' || status == 'approved' || status == 'active'; 
          if (_activeTab == 'Selesai') return status == 'completed'; 
          return status == 'cancelled' || status == 'rejected';
        }).toList();

        if (filtered.isEmpty) return const _EmptyState(isCharter: true);
        return RefreshIndicator(
          onRefresh: () => ref.refresh(charterHistoryProvider.future),
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            itemCount: filtered.length,
            separatorBuilder: (_, __) => const SizedBox(height: 16),
            itemBuilder: (context, index) => _CharterCard(charter: filtered[index]),
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(child: Text('Gagal memuat sewa: $err')),
    );
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
      displayDate = DateFormat('dd MMM yyyy', 'id_ID').format(DateTime.parse(displayDate));
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
                _StatusBadge(status: status),
                Text(booking['booking_code'] ?? '-', style: authTitleStyle(size: 14, color: AppColors.primary)),
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
            const Padding(padding: EdgeInsets.symmetric(vertical: 12), child: Divider(color: AuthPalette.border)),
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
}

class _CharterCard extends ConsumerWidget {
  final Map<String, dynamic> charter;
  const _CharterCard({required this.charter});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final status = charter['status'] ?? 'pending';
    
    String formatMyDate(String? d) {
      if (d == null) return '';
      try { return DateFormat('dd MMM yyyy', 'id_ID').format(DateTime.parse(d)); } catch (_) { return d; }
    }
    
    final pickup = formatMyDate(charter['pickup_date']);
    final returnD = formatMyDate(charter['return_date']);
    
    final formatCurrency = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
    final price = charter['total_price'] != null ? formatCurrency.format(double.tryParse(charter['total_price'].toString()) ?? 0) : 'Menunggu Penawaran';

    // Cancel logic
    bool canCancel = false;
    if (status != 'cancelled' && status != 'completed' && status != 'rejected') {
      try {
        final pickupTime = DateTime.parse(charter['pickup_date'].toString());
        // Batas pembatalan jam 08:00 hari keberangkatan
        final cutoff = DateTime(pickupTime.year, pickupTime.month, pickupTime.day, 8, 0, 0);
        if (DateTime.now().isBefore(cutoff)) {
          canCancel = true;
        }
      } catch (_) {}
    }

    return Container(
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
              _StatusBadge(status: status),
              Text(charter['charter_code'] ?? '-', style: authTitleStyle(size: 14, color: AppColors.primary)),
            ],
          ),
          const SizedBox(height: 16),
          Text(charter['bus_type_requested'] ?? 'Sewa Bus', style: authTitleStyle(size: 16)),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.location_on_rounded, size: 14, color: AuthPalette.muted),
              const SizedBox(width: 4),
              Expanded(child: Text('${charter['pickup_location']} → ${charter['destination']}', style: authBodyStyle(size: 13, color: AuthPalette.textSecondary))),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              const Icon(Icons.calendar_today_rounded, size: 14, color: AuthPalette.muted),
              const SizedBox(width: 4),
              Expanded(child: Text('$pickup s/d $returnD', style: authBodyStyle(size: 13, color: AuthPalette.textSecondary))),
            ],
          ),
          const Padding(padding: EdgeInsets.symmetric(vertical: 12), child: Divider(color: AuthPalette.border)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Total Harga', style: authBodyStyle(color: AuthPalette.textSecondary)),
              Text(price, style: authTitleStyle(size: 14, color: charter['total_price'] != null ? AppColors.primary : AuthPalette.muted)),
            ],
          ),
          if (canCancel) ...[
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 40,
              child: OutlinedButton(
                onPressed: () => _handleCancel(context, ref, charter['id']),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.error,
                  side: const BorderSide(color: AppColors.error),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: const Text('Batalkan Pesanan', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _handleCancel(BuildContext context, WidgetRef ref, int id) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Batalkan Pesanan?'),
        content: const Text('Apakah Anda yakin ingin membatalkan pesanan sewa bus ini?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Kembali', style: TextStyle(color: AuthPalette.muted))),
          TextButton(
            onPressed: () async {
              Navigator.pop(ctx);
              await ref.read(charterRequestProvider.notifier).cancelCharter(id);
              final state = ref.read(charterRequestProvider);
              if (!state.hasError) {
                ref.refresh(charterHistoryProvider.future);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Pesanan berhasil dibatalkan.')));
              } else {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Gagal: ${state.error}')));
              }
            },
            child: const Text('Ya, Batalkan', style: TextStyle(color: AppColors.error, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String status;
  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    Color color;
    switch (status.toLowerCase()) {
      case 'completed': 
      case 'approved': color = AppColors.success; break;
      case 'pending': color = Colors.orange; break;
      case 'cancelled': 
      case 'rejected': color = AppColors.error; break;
      default: color = AppColors.primary;
    }
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        status.toUpperCase(),
        style: authBodyStyle(size: 11, weight: FontWeight.w700, color: color),
      ),
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

class _EmptyState extends StatelessWidget {
  final bool isCharter;
  const _EmptyState({this.isCharter = false});

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
          Text('Belum Ada Pesanan', style: authTitleStyle(size: 20)),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              isCharter ? 'Ajukan sewa bus untuk perjalanan rombongan Anda' : 'Pesan tiket bus Anda sekarang dan nikmati perjalanan nyaman',
              style: authBodyStyle(),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: 180,
            height: 48,
            child: AuthPrimaryButton(
              label: isCharter ? 'Sewa Bus' : 'Cari Tiket',
              onPressed: () {
                context.go(isCharter ? '/charter' : '/home');
              },
            ),
          ),
        ],
      ),
    );
  }
}
