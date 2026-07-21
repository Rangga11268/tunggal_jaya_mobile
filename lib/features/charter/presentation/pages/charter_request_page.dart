import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/config/app_theme.dart';
import '../../../auth/presentation/pages/auth_shared.dart';
import '../providers/charter_provider.dart';

class CharterRequestPage extends ConsumerStatefulWidget {
  final String? initialOrigin;
  final String? initialDestination;
  final DateTime? initialPickupDate;

  const CharterRequestPage({
    super.key,
    this.initialOrigin,
    this.initialDestination,
    this.initialPickupDate,
  });

  @override
  ConsumerState<CharterRequestPage> createState() => _CharterRequestPageState();
}

class _CharterRequestPageState extends ConsumerState<CharterRequestPage> {
  final _formKey = GlobalKey<FormState>();
  
  DateTime? _pickupDate;
  DateTime? _returnDate;
  final _pickupLocationCtrl = TextEditingController();
  final _destinationCtrl = TextEditingController();
  final _notesCtrl = TextEditingController();
  
  String _selectedBusType = 'Big Bus';
  int _busCount = 1;
  final List<String> _busTypes = ['Big Bus', 'Big Bus (Leg Rest)', 'Medium Bus'];

  @override
  void initState() {
    super.initState();
    if (widget.initialOrigin != null) _pickupLocationCtrl.text = widget.initialOrigin!;
    if (widget.initialDestination != null) _destinationCtrl.text = widget.initialDestination!;
    if (widget.initialPickupDate != null) _pickupDate = widget.initialPickupDate;
  }

  @override
  void dispose() {
    _pickupLocationCtrl.dispose();
    _destinationCtrl.dispose();
    _notesCtrl.dispose();
    super.dispose();
  }

  Future<void> _selectDate(bool isPickup) async {
    final now = DateTime.now();
    // Min H-3 untuk pemesanan
    final firstDate = isPickup ? now.add(const Duration(days: 3)) : (_pickupDate ?? now.add(const Duration(days: 3)));
    
    final picked = await showDatePicker(
      context: context,
      initialDate: firstDate,
      firstDate: firstDate,
      lastDate: now.add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        if (isPickup) {
          _pickupDate = picked;
          if (_returnDate != null && _returnDate!.isBefore(_pickupDate!)) {
            _returnDate = null;
          }
        } else {
          _returnDate = picked;
        }
      });
    }
  }

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      if (_pickupDate == null || _returnDate == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Harap pilih tanggal jemput dan selesai')),
        );
        return;
      }

      final data = {
        'pickup_date': DateFormat('yyyy-MM-dd').format(_pickupDate!),
        'return_date': DateFormat('yyyy-MM-dd').format(_returnDate!),
        'pickup_location': _pickupLocationCtrl.text,
        'destination': _destinationCtrl.text,
        'bus_type_requested': _selectedBusType,
        'bus_count': _busCount,
        'notes': _notesCtrl.text,
      };

      await ref.read(charterRequestProvider.notifier).submitRequest(data);
      
      final state = ref.read(charterRequestProvider);
      if (state.hasError) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Gagal mengirim permintaan: ${state.error}')),
          );
        }
      } else {
        if (mounted) {
          // Tampilkan pesan sukses dan arahkan ke daftar booking atau home
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (ctx) => AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              title: const Text('Berhasil!'),
              content: const Text('Permintaan sewa bus telah dikirim. Admin kami akan segera menghubungi Anda untuk penawaran harga dan pelunasan (Maks H-1 sebelum keberangkatan).'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(ctx);
                    context.go('/bookings');
                  },
                  child: const Text('Lihat Pesanan', style: TextStyle(color: AppColors.primary)),
                ),
              ],
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(charterRequestProvider);
    final isLoading = state.isLoading;

    return Scaffold(
      backgroundColor: AuthPalette.background,
      appBar: AppBar(
        title: const Text('Form Pengajuan Sewa', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Informasi Perjalanan', style: authTitleStyle(size: 18)),
              const SizedBox(height: 16),
              
              // Pickup Date
              _buildDateField('Tanggal Penjemputan', _pickupDate, () => _selectDate(true)),
              const SizedBox(height: 16),
              
              // Return Date
              _buildDateField('Tanggal Selesai', _returnDate, () => _selectDate(false)),
              const SizedBox(height: 16),

              // Bus Type Dropdown
              Text('Tipe Bus', style: authBodyStyle(size: 14, weight: FontWeight.w600)),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: _selectedBusType,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AuthPalette.border)),
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AuthPalette.border)),
                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.primary, width: 1.5)),
                ),
                items: _busTypes.map((type) => DropdownMenuItem(value: type, child: Text(type))).toList(),
                onChanged: (val) {
                  if (val != null) setState(() => _selectedBusType = val);
                },
              ),
              const SizedBox(height: 16),
              
              // Bus Count Stepper
              Text('Jumlah Bus', style: authBodyStyle(size: 14, weight: FontWeight.w600)),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: AuthPalette.border),
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('$_busCount Unit', style: authBodyStyle(size: 16, weight: FontWeight.w600)),
                    Row(
                      children: [
                        IconButton(
                          onPressed: _busCount > 1 ? () => setState(() => _busCount--) : null,
                          icon: const Icon(Icons.remove_circle_outline, color: AppColors.primary),
                        ),
                        Text('$_busCount', style: authBodyStyle(size: 18, weight: FontWeight.w600)),
                        IconButton(
                          onPressed: () => setState(() => _busCount++),
                          icon: const Icon(Icons.add_circle_outline, color: AppColors.primary),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              const SizedBox(height: 24),

              Text('Lokasi', style: authTitleStyle(size: 18)),
              const SizedBox(height: 16),
              
              AuthFieldLabel(text: 'Titik Jemput Lengkap'),
              AuthTextField(
                controller: _pickupLocationCtrl,
                hintText: 'Contoh: SMA 1 Jakarta, Jl. Gatot Subroto',
                prefixIcon: Icons.location_on_rounded,
                validator: (v) => v!.isEmpty ? 'Wajib diisi' : null,
              ),
              const SizedBox(height: 16),
              
              AuthFieldLabel(text: 'Tujuan Lengkap'),
              AuthTextField(
                controller: _destinationCtrl,
                hintText: 'Contoh: Candi Borobudur, Magelang',
                prefixIcon: Icons.location_on_rounded,
                validator: (v) => v!.isEmpty ? 'Wajib diisi' : null,
              ),
              const SizedBox(height: 24),

              Text('Catatan Tambahan', style: authTitleStyle(size: 18)),
              const SizedBox(height: 16),
              
              TextFormField(
                controller: _notesCtrl,
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: 'Tuliskan kebutuhan khusus Anda...',
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AuthPalette.border)),
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AuthPalette.border)),
                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.primary, width: 1.5)),
                ),
              ),
              const SizedBox(height: 32),

              SizedBox(
                width: double.infinity,
                height: 54,
                child: AuthPrimaryButton(
                  label: isLoading ? 'Mengirim...' : 'Kirim Permintaan',
                  onPressed: isLoading ? () {} : _submit,
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDateField(String label, DateTime? date, VoidCallback onTap) {
    final hasValue = date != null;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: authBodyStyle(size: 14, weight: FontWeight.w600)),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AuthPalette.border),
            ),
            child: Row(
              children: [
                Icon(Icons.calendar_today_rounded, size: 20, color: hasValue ? AppColors.primary : AuthPalette.muted),
                const SizedBox(width: 12),
                Text(
                  hasValue ? DateFormat('dd MMMM yyyy').format(date) : 'Pilih Tanggal',
                  style: authBodyStyle(
                    color: hasValue ? AuthPalette.textPrimary : AuthPalette.muted,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
