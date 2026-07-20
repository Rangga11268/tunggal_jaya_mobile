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
  String _selectedBus = '';
  String _selectedRoute = '';

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
                  final allBuses = schedules.map((s) => (s['bus']?['name'] ?? '').toString()).toSet().toList()..removeWhere((e) => e.isEmpty);
                  final allRoutes = schedules.map((s) => (s['route']?['name'] ?? '').toString()).toSet().toList()..removeWhere((e) => e.isEmpty);

                  final filteredSchedules = schedules.where((s) {
                    final busName = (s['bus']?['name'] ?? '').toString();
                    final routeName = (s['route']?['name'] ?? '').toString();
                    final depTime = (s['departure_time'] ?? '').toString();

                    if (_selectedBus.isNotEmpty && busName != _selectedBus) return false;
                    if (_selectedRoute.isNotEmpty && routeName != _selectedRoute) return false;

                    if (_searchQuery.isNotEmpty) {
                      final search = _searchQuery.toLowerCase();
                      return busName.toLowerCase().contains(search) || routeName.toLowerCase().contains(search) || depTime.toLowerCase().contains(search);
                    }
                    return true;
                  }).toList();

                  return Column(
                    children: [
                      if (allBuses.isNotEmpty || allRoutes.isNotEmpty)
                        Container(
                          height: 48,
                          margin: const EdgeInsets.only(bottom: 8),
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            children: [
                              if (allBuses.isNotEmpty) ...[
                                Padding(
                                  padding: const EdgeInsets.only(right: 8, top: 12),
                                  child: Text('Bus:', style: AppTextStyles.label.copyWith(color: AppColors.muted)),
                                ),
                                ...allBuses.map((bus) => Padding(
                                  padding: const EdgeInsets.only(right: 8),
                                  child: FilterChip(
                                    label: Text(bus),
                                    selected: _selectedBus == bus,
                                    onSelected: (selected) => setState(() => _selectedBus = selected ? bus : ''),
                                    selectedColor: AppColors.primaryLight,
                                    checkmarkColor: AppColors.primaryDark,
                                    labelStyle: TextStyle(
                                      color: _selectedBus == bus ? AppColors.primaryDark : AppColors.primaryText,
                                      fontWeight: _selectedBus == bus ? FontWeight.bold : FontWeight.normal,
                                    ),
                                    backgroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                      side: BorderSide(color: _selectedBus == bus ? AppColors.primary : AppColors.borderStrong),
                                    ),
                                  ),
                                )),
                                const SizedBox(width: 8),
                              ],
                              if (allRoutes.isNotEmpty) ...[
                                Padding(
                                  padding: const EdgeInsets.only(right: 8, top: 12),
                                  child: Text('Rute:', style: AppTextStyles.label.copyWith(color: AppColors.muted)),
                                ),
                                ...allRoutes.map((route) => Padding(
                                  padding: const EdgeInsets.only(right: 8),
                                  child: FilterChip(
                                    label: Text(route),
                                    selected: _selectedRoute == route,
                                    onSelected: (selected) => setState(() => _selectedRoute = selected ? route : ''),
                                    selectedColor: AppColors.primaryLight,
                                    checkmarkColor: AppColors.primaryDark,
                                    labelStyle: TextStyle(
                                      color: _selectedRoute == route ? AppColors.primaryDark : AppColors.primaryText,
                                      fontWeight: _selectedRoute == route ? FontWeight.bold : FontWeight.normal,
                                    ),
                                    backgroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                      side: BorderSide(color: _selectedRoute == route ? AppColors.primary : AppColors.borderStrong),
                                    ),
                                  ),
                                )),
                              ],
                            ],
                          ),
                        ),
                      Expanded(
                        child: filteredSchedules.isEmpty
                          ? Center(
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
                            )
                          : ListView.separated(
                              padding: const EdgeInsets.fromLTRB(20, 8, 20, 100),
                              itemCount: filteredSchedules.length,
                              separatorBuilder: (_, __) => const SizedBox(height: 16),
                              itemBuilder: (context, index) {
                                final schedule = filteredSchedules[index];
                                return _TicketCard(schedule: schedule, scheduleDate: widget.date);
                              },
                            ),
                      ),
                    ],
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

    bool isFull = (schedule['available_seats'] ?? 0) <= 0;

    Color statusBgColor = AppColors.primaryLight;
    Color statusTextColor = AppColors.primaryDark;
    String statusText = 'Sisa: ${schedule['available_seats'] ?? '-'}';
    
    if (hasDeparted) {
      statusBgColor = Colors.red.shade50;
      statusTextColor = Colors.red.shade700;
      statusText = 'Berangkat';
    } else if (isFull) {
      statusBgColor = Colors.grey.shade200;
      statusTextColor = Colors.grey.shade700;
      statusText = 'Penuh';
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
                    color: statusBgColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    statusText,
                    style: AppTextStyles.label.copyWith(color: statusTextColor),
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
                  onPressed: (hasDeparted || isFull) ? null : () => context.push('/seat-selection/${schedule['id']}'),
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

