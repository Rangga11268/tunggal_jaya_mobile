import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
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

    return Scaffold(
      appBar: AppBar(
        title: Text('$origin - $destination'),
        backgroundColor: Colors.white,
        foregroundColor: AppColors.textDark,
        elevation: 0,
      ),
      body: schedulesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
        data: (schedules) {
          if (schedules.isEmpty) {
            return const Center(child: Text('Tidak ada jadwal tersedia.'));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: schedules.length,
            itemBuilder: (context, index) {
              final schedule = schedules[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16),
                  title: Text(schedule['route']['name'] ?? 'Route', style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text('Berangkat: ${schedule['departure_time']}\nHarga: Rp ${schedule['price']}'),
                  trailing: ElevatedButton(
                    onPressed: () {
                      context.push('/seat-selection/${schedule['id']}');
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
                    child: const Text('Pilih'),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
