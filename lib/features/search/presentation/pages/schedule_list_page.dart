import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../data/search_repository.dart';
import '../../../../core/config/app_theme.dart';
import '../../../../core/widgets/tj_page_header.dart';
import '../../../../core/widgets/tj_background.dart';

typedef ScheduleParams = ({String origin, String destination, String date});

final scheduleListProvider = FutureProvider.family<List<dynamic>, ScheduleParams>((ref, params) async {
  final repository = ref.read(searchRepositoryProvider);
  final res = await repository.getSchedules(
    origin: params.origin,
    destination: params.destination,
    date: params.date,
  );
  return res['data'] as List<dynamic>;
});

class ScheduleListPage extends ConsumerStatefulWidget {
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
  ConsumerState<ScheduleListPage> createState() => _ScheduleListPageState();
}

class _ScheduleListPageState extends ConsumerState<ScheduleListPage> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final schedulesAsync = ref.watch(scheduleListProvider((
      origin: widget.origin,
      destination: widget.destination,
      date: widget.date,
    )));

    // Format date string for display
    String displayDate = widget.date.isEmpty ? 'Semua Tanggal' : widget.date;
    try {
      if (widget.date.isNotEmpty) {
        final parsedDate = DateTime.parse(widget.date);
        displayDate = DateFormat('dd MMM yyyy').format(parsedDate);
      }
    } catch (_) {}

    final titleText = widget.origin.isEmpty && widget.destination.isEmpty 
        ? 'Semua Jadwal' 
        : '${widget.origin.isNotEmpty ? widget.origin : "Semua"} - ${widget.destination.isNotEmpty ? widget.destination : "Semua"}';

    return Scaffold(
      backgroundColor: AppColors.background,
      body: TjBackground(
        child: Column(
          children: [
            TjPageHeader(
              title: titleText,
              subtitle: displayDate,
              showBackButton: true,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: TextField(
                onChanged: (value) => setState(() => _searchQuery = value),
                decoration: InputDecoration(
                  hintText: 'Cari rute, bus, atau jam...',
                  prefixIcon: const Icon(LucideIcons.search, color: AppColors.muted),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.borderStrong)),
                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.primary)),
                ),
              ),
            ),
            Expanded(
              child: schedulesAsync.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stack) => Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Text('Terjadi kesalahan:\n$error', textAlign: TextAlign.center, style: AppTextStyles.body),
                  ),
                ),
                data: (schedules) {
                  final filteredSchedules = schedules.where((s) {
                    if (_searchQuery.isEmpty) return true;
                    final search = _searchQuery.toLowerCase();
                    final busName = (s['bus']?['name'] ?? '').toString().toLowerCase();
                    final routeName = (s['route']?['name'] ?? '').toString().toLowerCase();
                    final depTime = (s['departure_time'] ?? '').toString().toLowerCase();
                    return busName.contains(search) || routeName.contains(search) || depTime.contains(search);
                  }).toList();

                  if (filteredSchedules.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              color: AppColors.primaryLight,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(LucideIcons.calendarX2, size: 48, color: AppColors.primary),
                          ),
                          const SizedBox(height: 24),
                          Text('Jadwal Tidak Tersedia', style: AppTextStyles.h3),
                          const SizedBox(height: 8),
                          Text('Maaf, tidak ada jadwal bus yang cocok\nSilakan cari dengan kata kunci lain.', textAlign: TextAlign.center, style: AppTextStyles.bodySmall),
                        ],
                      ),
                    );
                  }
                  return ListView.separated(
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 100),
                    itemCount: filteredSchedules.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 16),
                    itemBuilder: (context, index) {
                      final schedule = filteredSchedules[index];
                      return _TicketCard(schedule: schedule, scheduleDate: widget.date);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TicketCard extends StatelessWidget {
  final dynamic schedule;
  final String scheduleDate;

  const _TicketCard({required this.schedule, required this.scheduleDate});

  @override
  Widget build(BuildContext context) {
    final formatCurrency = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
    final price = schedule['price'] != null ? formatCurrency.format(double.tryParse(schedule['price'].toString()) ?? 0) : 'Rp -';
    final departureTime = schedule['departure_time'] != null ? schedule['departure_time'].toString().substring(0, 5) : '--:--';
    final arrivalTime = schedule['arrival_time'] != null ? schedule['arrival_time'].toString().substring(0, 5) : '--:--';
    final busName = schedule['bus'] != null ? schedule['bus']['name'] : 'Bus';
    final routeName = schedule['route'] != null ? schedule['route']['name'] : 'Route';

    // Check if departed
    bool hasDeparted = false;
    if (scheduleDate.isNotEmpty && departureTime != '--:--') {
      try {
        final depDateTime = DateTime.parse('${scheduleDate.substring(0, 10)} $departureTime:00');
        if (DateTime.now().isAfter(depDateTime)) {
          hasDeparted = true;
        }
      } catch (_) {}
    }

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
                    color: hasDeparted ? Colors.red.shade50 : AppColors.primaryLight,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    hasDeparted ? 'Berangkat' : 'Sisa: ${schedule['available_seats'] ?? '-'}',
                    style: AppTextStyles.label.copyWith(color: hasDeparted ? Colors.red.shade700 : AppColors.primaryDark),
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
                  onPressed: hasDeparted ? null : () => context.push('/seat-selection/${schedule['id']}'),
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

