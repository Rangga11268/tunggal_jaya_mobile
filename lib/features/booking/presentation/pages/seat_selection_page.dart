import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';
import '../../../../core/config/app_theme.dart';
import '../../search/data/search_repository.dart';

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
      final data = event.data; // parse JSON if needed
      // Basic handling (assume data has seatNumber)
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
        backgroundColor: Colors.white,
        foregroundColor: AppColors.textDark,
      ),
      body: scheduleAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
        data: (schedule) {
          final capacity = schedule['bus']['capacity'] as int? ?? 40;
          // Normally we mix API booked seats + WS locked seats
          final apiOccupied = (schedule['occupied_seats'] as List?)?.cast<String>() ?? [];
          
          return Column(
            children: [
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.all(20),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
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
                      child: Container(
                        decoration: BoxDecoration(
                          color: isOccupied ? Colors.grey[300] : (isSelected ? AppColors.primary : Colors.white),
                          border: Border.all(color: isOccupied ? Colors.grey : AppColors.primary),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          seatNum,
                          style: TextStyle(
                            color: isOccupied ? Colors.grey[600] : (isSelected ? Colors.white : AppColors.primary),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, -2))],
                ),
                child: SafeArea(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('${_selectedSeats.length} Kursi Dipilih', style: const TextStyle(fontWeight: FontWeight.bold)),
                      ElevatedButton(
                        onPressed: _selectedSeats.isEmpty ? null : () {
                          // TODO: proceed to checkout
                        },
                        style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
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
}
