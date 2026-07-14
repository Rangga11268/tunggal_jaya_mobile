import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/config/app_theme.dart';
import '../../../../core/network/api_client.dart';
import '../../../../features/auth/presentation/pages/auth_shared.dart';
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
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  
  bool isLoading = false;
  MidtransSDK? midtrans;

  @override
  void initState() {
    super.initState();
    _initMidtrans();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
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
    // midtrans?.setUIKitCustomSetting(skipCustomerDetailsPages: true);
  }

  Future<void> _processCheckout() async {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final phone = _phoneController.text.trim();

    if (name.isEmpty || email.isEmpty || phone.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Harap lengkapi semua data')));
      return;
    }

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
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.borderStrong),
                boxShadow: AppShadows.soft,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Rincian Pesanan', style: AppTextStyles.h4),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Kursi Terpilih', style: AppTextStyles.body),
                      Text(
                        widget.selectedSeats.join(', '),
                        style: AppTextStyles.h4.copyWith(color: AppColors.primary),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Text('Data Penumpang', style: AppTextStyles.h3),
            const SizedBox(height: 16),
            AuthCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const AuthFieldLabel(text: 'Nama Lengkap'),
                  AuthTextField(
                    controller: _nameController,
                    hintText: 'Nama sesuai KTP',
                    prefixIcon: Icons.person_outline_rounded,
                  ),
                  const SizedBox(height: 16),
                  const AuthFieldLabel(text: 'Email'),
                  AuthTextField(
                    controller: _emailController,
                    hintText: 'Alamat Email',
                    prefixIcon: Icons.email_outlined,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 16),
                  const AuthFieldLabel(text: 'Nomor HP'),
                  AuthTextField(
                    controller: _phoneController,
                    hintText: 'Contoh: 08123456789',
                    prefixIcon: Icons.phone_outlined,
                    keyboardType: TextInputType.phone,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            AuthPrimaryButton(
              label: 'Bayar Sekarang',
              onPressed: _processCheckout,
              isBusy: isLoading,
            ),
          ],
        ),
      ),
    );
  }
}

