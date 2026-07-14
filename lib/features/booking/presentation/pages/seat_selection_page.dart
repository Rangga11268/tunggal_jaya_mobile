import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';
import '../../../../core/config/app_theme.dart';
import '../../../search/data/search_repository.dart';

final scheduleDetailProvider = FutureProvider.family<Map<String, dynamic>, String>((ref, id) async {
  final repo = ref.read(searchRepositoryProvider);
  final res = await repo.getSchedule(id);
  return res['data'] as Map<String, dynamic>;
});

class SeatSelectionPage extends ConsumerStatefulWidget {
  final String scheduleId;
  const SeatSelectionPage({super.key, required this.scheduleId});

  @override
  ConsumerState<SeatSelectionPage> createState() => _SeatSelectionPageState();
}

class _SeatSelectionPageState extends ConsumerState<SeatSelectionPage> {
  final Set<String> _selectedSeats = {};
  final Set<String> _lockedSeats = {}; // dynamically updated via WS
  late PusherChannelsFlutter pusher;

  @override
  void initState() {
    super.initState();
    _initPusher();
  }

  Future<void> _initPusher() async {
    pusher = PusherChannelsFlutter.getInstance();
    try {
      await pusher.init(
        apiKey: "app-key", // In production, get from .env
        cluster: "mt1",
        onEvent: _onEvent,
      );
      await pusher.subscribe(channelName: 'schedule.${widget.scheduleId}');
      await pusher.connect();
    } catch (e) {
      debugPrint("Pusher error: $e");
    }
  }

  void _onEvent(PusherEvent event) {
    if (event.eventName == 'seat.locked') {
      // final data = event.data; // parse JSON if needed
      // setState(() { _lockedSeats.add(seatNumber.toString()); });
    }
  }

  @override
  void dispose() {
    pusher.unsubscribe(channelName: 'schedule.${widget.scheduleId}');
    pusher.disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheduleAsync = ref.watch(scheduleDetailProvider(widget.scheduleId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pilih Kursi'),
      ),
      body: scheduleAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err', style: AppTextStyles.body)),
        data: (schedule) {
          final capacity = schedule['bus']['capacity'] as int? ?? 40;
          final apiOccupied = (schedule['occupied_seats'] as List?)?.cast<String>() ?? [];
          
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildLegend('Tersedia', Colors.white, AppColors.borderStrong),
                    _buildLegend('Terisi', AppColors.borderStrong, AppColors.borderStrong),
                    _buildLegend('Dipilih', AppColors.primary, AppColors.primary),
                  ],
                ),
              ),
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 1,
                  ),
                  itemCount: capacity,
                  itemBuilder: (context, index) {
                    final seatNum = (index + 1).toString();
                    final isOccupied = apiOccupied.contains(seatNum) || _lockedSeats.contains(seatNum);
                    final isSelected = _selectedSeats.contains(seatNum);

                    return GestureDetector(
                      onTap: isOccupied ? null : () {
                        setState(() {
                          isSelected ? _selectedSeats.remove(seatNum) : _selectedSeats.add(seatNum);
                        });
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        decoration: BoxDecoration(
                          color: isOccupied ? AppColors.border : (isSelected ? AppColors.primary : Colors.white),
                          border: Border.all(
                            color: isOccupied ? AppColors.borderStrong : (isSelected ? AppColors.primary : AppColors.borderStrong),
                            width: isSelected ? 2 : 1,
                          ),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: isSelected ? AppShadows.soft : [],
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          seatNum,
                          style: AppTextStyles.h4.copyWith(
                            color: isOccupied ? AppColors.muted : (isSelected ? Colors.white : AppColors.primaryText),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: const Border(top: BorderSide(color: AppColors.borderStrong)),
                  boxShadow: AppShadows.soft,
                ),
                child: SafeArea(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Kursi Terpilih', style: AppTextStyles.caption),
                          const SizedBox(height: 4),
                          Text(
                            _selectedSeats.isEmpty ? '-' : '${_selectedSeats.length} Kursi',
                            style: AppTextStyles.h3,
                          ),
                        ],
                      ),
                      ElevatedButton(
                        onPressed: _selectedSeats.isEmpty ? null : () {
                          context.push('/checkout/${widget.scheduleId}', extra: {
                            'selectedSeats': _selectedSeats.toList(),
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(120, 50),
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                        ),
                        child: const Text('Lanjut'),
                      )
                    ],
                  ),
                ),
              )
            ],
          );
        },
      ),
    );
  }

  Widget _buildLegend(String label, Color color, Color borderColor) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            border: Border.all(color: borderColor),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 8),
        Text(label, style: AppTextStyles.bodySmall),
      ],
    );
  }
}

