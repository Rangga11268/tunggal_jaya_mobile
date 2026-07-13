import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/config/app_theme.dart';
import '../../../../core/network/api_client.dart';
import 'package:midtrans_sdk/midtrans_sdk.dart';

class BookingCheckoutPage extends ConsumerStatefulWidget {
  final String scheduleId;
  final List<String> selectedSeats;

  const BookingCheckoutPage({
    super.key,
    required this.scheduleId,
    required this.selectedSeats,
  });

  @override
  ConsumerState<BookingCheckoutPage> createState() => _BookingCheckoutPageState();
}

class _BookingCheckoutPageState extends ConsumerState<BookingCheckoutPage> {
  final _formKey = GlobalKey<FormState>();
  String name = '';
  String email = '';
  String phone = '';
  bool isLoading = false;
  MidtransSDK? midtrans;

  @override
  void initState() {
    super.initState();
    _initMidtrans();
  }

  Future<void> _initMidtrans() async {
    midtrans = await MidtransSDK.init(
      config: MidtransConfig(
        clientKey: "YOUR_CLIENT_KEY", // Get from env
        merchantBaseUrl: "YOUR_MERCHANT_BASE_URL", // Get from env
        colorTheme: ColorTheme(
          colorPrimary: Theme.of(context).primaryColor,
          colorPrimaryDark: Theme.of(context).primaryColorDark,
          colorSecondary: Theme.of(context).colorScheme.secondary,
        ),
      ),
    );
    midtrans?.setUIKitCustomSetting(skipCustomerDetailsPages: true);
  }

  Future<void> _processCheckout() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    setState(() => isLoading = true);

    try {
      final apiClient = ref.read(apiClientProvider);
      
      // 1. Create Booking
      final bookingRes = await apiClient.post('/bookings', data: {
        'schedule_id': widget.scheduleId,
        'passenger_name': name,
        'passenger_email': email,
        'passenger_phone': phone,
        'number_of_seats': widget.selectedSeats.length,
      });
      final bookingId = bookingRes['data']['id'];

      // 2. Lock Seats
      await apiClient.post('/bookings/select-seats', data: {
        'booking_id': bookingId,
        'seat_numbers': widget.selectedSeats.map(int.parse).toList(),
      });

      // 3. Process Payment
      final paymentRes = await apiClient.post('/bookings/process-payment', data: {
        'booking_id': bookingId,
        'payment_method': 'shopeepay', // default or selected from UI
      });
      
      final snapToken = paymentRes['data']['snap_token'];

      // 4. Start Midtrans SDK
      midtrans?.startPaymentUiFlow(
        token: snapToken,
      );

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
        backgroundColor: Colors.white,
        foregroundColor: AppColors.textDark,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Kursi Terpilih: ${widget.selectedSeats.join(', ')}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 20),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Nama Penumpang', border: OutlineInputBorder()),
                onSaved: (val) => name = val ?? '',
                validator: (val) => val!.isEmpty ? 'Wajib diisi' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Email', border: OutlineInputBorder()),
                keyboardType: TextInputType.emailAddress,
                onSaved: (val) => email = val ?? '',
                validator: (val) => val!.isEmpty ? 'Wajib diisi' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Nomor HP', border: OutlineInputBorder()),
                keyboardType: TextInputType.phone,
                onSaved: (val) => phone = val ?? '',
                validator: (val) => val!.isEmpty ? 'Wajib diisi' : null,
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: isLoading ? null : _processCheckout,
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, padding: const EdgeInsets.all(16)),
                child: isLoading ? const CircularProgressIndicator(color: Colors.white) : const Text('Bayar Sekarang'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
