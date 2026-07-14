import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../data/search_repository.dart';
import '../../../../core/config/app_theme.dart';

final scheduleListProvider = FutureProvider.family<List<dynamic>, Map<String, String>>((ref, params) async {
  final repository = ref.read(searchRepositoryProvider);
  final res = await repository.getSchedules(
    origin: params['origin']!,
    destination: params['destination']!,
    date: params['date']!,
  );
  return res['data'] as List<dynamic>;
});

class ScheduleListPage extends ConsumerWidget {
  final String origin;
  final String destination;
  final String date;

  const ScheduleListPage({
    super.key,
    required this.origin,
    required this.destination,
    required this.date,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final schedulesAsync = ref.watch(scheduleListProvider({
      'origin': origin,
      'destination': destination,
      'date': date,
    }));

    // Format date string for display
    String displayDate = date;
    try {
      final parsedDate = DateTime.parse(date);
      displayDate = DateFormat('dd MMM yyyy').format(parsedDate);
    } catch (_) {}

    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: [
            Text('$origin - $destination', style: AppTextStyles.h4),
            Text(displayDate, style: AppTextStyles.bodySmall),
          ],
        ),
      ),
      body: schedulesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text('Terjadi kesalahan: $error', textAlign: TextAlign.center, style: AppTextStyles.body),
          ),
        ),
        data: (schedules) {
          if (schedules.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.event_busy_rounded, size: 64, color: AppColors.muted),
                  const SizedBox(height: 16),
                  Text('Tidak ada jadwal tersedia\npada tanggal ini.', textAlign: TextAlign.center, style: AppTextStyles.body),
                ],
              ),
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.all(24),
            itemCount: schedules.length,
            separatorBuilder: (_, __) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              final schedule = schedules[index];
              return _TicketCard(schedule: schedule);
            },
          );
        },
      ),
    );
  }
}

class _TicketCard extends StatelessWidget {
  final dynamic schedule;

  const _TicketCard({required this.schedule});

  @override
  Widget build(BuildContext context) {
    final formatCurrency = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
    final price = schedule['price'] != null ? formatCurrency.format(double.tryParse(schedule['price'].toString()) ?? 0) : 'Rp -';
    final departureTime = schedule['departure_time'] != null ? schedule['departure_time'].toString().substring(0, 5) : '--:--';
    final arrivalTime = schedule['arrival_time'] != null ? schedule['arrival_time'].toString().substring(0, 5) : '--:--';
    final busName = schedule['bus'] != null ? schedule['bus']['name'] : 'Bus';
    final routeName = schedule['route'] != null ? schedule['route']['name'] : 'Route';

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderStrong),
        boxShadow: AppShadows.soft,
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(busName, style: AppTextStyles.h4),
                      Text(routeName, style: AppTextStyles.caption),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'Sisa: ${schedule['available_seats'] ?? '-'}',
                    style: AppTextStyles.label.copyWith(color: AppColors.primaryDark),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: AppColors.borderStrong),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Berangkat', style: AppTextStyles.caption),
                    const SizedBox(height: 4),
                    Text(departureTime, style: AppTextStyles.h3),
                  ],
                ),
                Icon(Icons.arrow_right_alt_rounded, color: AppColors.muted),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('Tiba', style: AppTextStyles.caption),
                    const SizedBox(height: 4),
                    Text(arrivalTime, style: AppTextStyles.h3),
                  ],
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: AppColors.borderStrong),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(price, style: AppTextStyles.h3.copyWith(color: AppColors.primary)),
                ElevatedButton(
                  onPressed: () => context.push('/seat-selection/${schedule['id']}'),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(0, 40),
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 0),
                  ),
                  child: const Text('Pilih'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

