import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/config/app_theme.dart';

class SeatSelectionPage extends ConsumerStatefulWidget {
  final String scheduleId;

  const SeatSelectionPage({super.key, required this.scheduleId});

  @override
  ConsumerState<SeatSelectionPage> createState() => _SeatSelectionPageState();
}

class _SeatSelectionPageState extends ConsumerState<SeatSelectionPage> {
  final List<String> selectedSeats = [];

  @override
  void initState() {
    super.initState();
    // TODO: Init Pusher Channels here to listen for seat locks
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pilih Kursi'),
        backgroundColor: Colors.white,
        foregroundColor: AppColors.textDark,
        elevation: 0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Denah kursi untuk jadwal ${widget.scheduleId} akan tampil di sini.'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // TODO: Navigate to checkout
              },
              child: const Text('Lanjut Checkout'),
            )
          ],
        ),
      ),
    );
  }
}
