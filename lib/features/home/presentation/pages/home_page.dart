import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:intl/intl.dart';

import '../../../../core/config/app_config.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../providers/home_provider.dart';
import '../../../../core/config/app_theme.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final userName = authState.user?['name'] as String? ?? 'Budi';

    return Scaffold(
      backgroundColor: const Color(0xFFFCF9F8), // Background from Figma
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _BannerAndSearch(userName: userName),
            const SizedBox(height: 32),
            const _QuickLinks(),
            const SizedBox(height: 32),
            const _ActiveSchedules(),
            const SizedBox(height: 32),
            const _HomeFooterShapes(),
          ],
        ),
      ),
    );
  }
}


class _BannerAndSearch extends StatelessWidget {
  final String userName;
  const _BannerAndSearch({required this.userName});

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        // Background Image
        Container(
          height: 340,
          width: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/heroImg.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.black.withValues(alpha: 0.5), 
                  Colors.transparent, 
                  Colors.black.withValues(alpha: 0.7) 
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: const [0.0, 0.4, 1.0],
              ),
            ),
            child: SafeArea(
              bottom: false,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Top Greeting (Rosalia Style) restored with TJ Logo
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 32, 20, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Left Logo Pill
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: Row(
                            children: [
                              Image.asset('assets/logo/logoNoBg.png', height: 24, fit: BoxFit.contain, errorBuilder: (context, error, stackTrace) => const Icon(Icons.directions_bus_rounded, color: Color(0xFF10207A), size: 24)),
                              const SizedBox(width: 8),
                              Text('TUNGGAL JAYA', style: AppTextStyles.bodyBold.copyWith(color: const Color(0xFF10207A), fontSize: 12, fontWeight: FontWeight.w900)),
                            ],
                          ),
                        ),
                        // Right Greeting Pill
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              decoration: BoxDecoration(
                                color: Colors.black.withValues(alpha: 0.6),
                                borderRadius: BorderRadius.circular(24),
                                border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
                              ),
                              child: Text(
                                'Hi, ${userName.length > 10 ? '${userName.substring(0, 10)}...' : userName}',
                                style: AppTextStyles.body.copyWith(color: Colors.white, fontSize: 12),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              width: 36,
                              height: 36,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.grey.shade300,
                                border: Border.all(color: Colors.white, width: 2),
                              ),
                              child: const Icon(LucideIcons.user, color: Colors.grey, size: 20),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Points & Status Card (Rosalia Style)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.6),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.amber),
                                  child: const Icon(LucideIcons.coins, color: Colors.white, size: 20),
                                ),
                                const SizedBox(width: 12),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('TJ Poin', style: AppTextStyles.label.copyWith(color: Colors.white.withValues(alpha: 0.8), fontSize: 12)),
                                    const SizedBox(height: 2),
                                    Text('50', style: AppTextStyles.bodyBold.copyWith(color: Colors.white, fontSize: 16)),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Container(width: 1, height: 32, color: Colors.white.withValues(alpha: 0.3)),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 16),
                              child: Row(
                                children: [
                                  const Icon(LucideIcons.creditCard, color: Colors.white70, size: 24),
                                  const SizedBox(width: 12),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('Status TJ Plus', style: AppTextStyles.label.copyWith(color: Colors.white.withValues(alpha: 0.8), fontSize: 12)),
                                      const SizedBox(height: 2),
                                      Text('CLASSIC', style: AppTextStyles.bodyBold.copyWith(color: Colors.white, fontSize: 14)),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        
        // Search Card (overlapping by 80px)
        const Padding(
          padding: EdgeInsets.only(top: 260, left: 20, right: 20),
          child: _SearchCard(),
        ),
      ],
    );
  }
}

class _SearchCard extends ConsumerStatefulWidget {
  const _SearchCard();

  @override
  ConsumerState<_SearchCard> createState() => _SearchCardState();
}

class _SearchCardState extends ConsumerState<_SearchCard> {
  int _activeTab = 0; // 0 for Tiket Bus, 1 for Sewa Pariwisata
  String _origin = 'Jakarta';
  String _destination = 'Kuningan';
  DateTime _date = DateTime.now();
  int _passengers = 1;

  // Charter variables
  String _charterOrigin = 'Jakarta';
  String _charterDestination = 'Kuningan';
  DateTime _charterDate = DateTime.now().add(const Duration(days: 1));
  TimeOfDay _charterTime = const TimeOfDay(hour: 8, minute: 0);

  Future<void> _selectCity(bool isOrigin) async {
    final state = ref.read(originsDestinationsProvider);
    final cities = state.value != null ? (isOrigin ? state.value!['origins']! : state.value!['destinations']!) : <String>[];
    final fallback = ['Jakarta', 'Kuningan', 'Bandung', 'Cirebon', 'Tangerang', 'Bekasi'];
    final list = cities.isNotEmpty ? cities : fallback;

    final result = await showDialog<String>(
      context: context,
      builder: (context) => SimpleDialog(
        title: Text(isOrigin ? 'Pilih Kota Asal' : 'Pilih Kota Tujuan', style: AppTextStyles.h4),
        children: list.map((city) => SimpleDialogOption(
          onPressed: () => Navigator.pop(context, city),
          child: Text(city, style: AppTextStyles.body),
        )).toList(),
      ),
    );
    if (result != null) {
      setState(() {
        if (isOrigin) _origin = result;
        else _destination = result;
      });
    }
  }

  Future<void> _selectCharterCity(bool isOrigin) async {
    final ctrl = TextEditingController(text: isOrigin ? _charterOrigin : _charterDestination);
    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(isOrigin ? 'Pilih Keberangkatan' : 'Pilih Tujuan', style: AppTextStyles.h4),
        content: TextField(
          controller: ctrl,
          decoration: const InputDecoration(hintText: 'Masukkan nama kota'),
          autofocus: true,
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Batal')),
          ElevatedButton(onPressed: () => Navigator.pop(context, ctrl.text), child: const Text('Simpan')),
        ],
      ),
    );
    if (result != null && result.isNotEmpty) {
      setState(() {
        if (isOrigin) _charterOrigin = result;
        else _charterDestination = result;
      });
    }
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 90)),
    );
    if (picked != null) setState(() => _date = picked);
  }

  Future<void> _selectCharterDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _charterDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) setState(() => _charterDate = picked);
  }

  Future<void> _selectCharterTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _charterTime,
    );
    if (picked != null) setState(() => _charterTime = picked);
  }

  Future<void> _selectPassengers() async {
    final result = await showDialog<int>(
      context: context,
      builder: (context) => SimpleDialog(
        title: Text('Jumlah Penumpang', style: AppTextStyles.h4),
        children: [1, 2, 3, 4, 5].map((num) => SimpleDialogOption(
          onPressed: () => Navigator.pop(context, num),
          child: Text('$num Orang', style: AppTextStyles.body),
        )).toList(),
      ),
    );
    if (result != null) setState(() => _passengers = result);
  }

  @override
  Widget build(BuildContext context) {
    // Watch provider so it fetches data in background
    ref.watch(originsDestinationsProvider);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE5E7EB), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Tabs
          Container(
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: Color(0xFFF3F4F6), width: 2)),
            ),
            child: Row(
              children: [
                _buildTab(0, 'Tiket Bus', LucideIcons.bus),
                _buildTab(1, 'Sewa Pariwisata', LucideIcons.compass),
              ],
            ),
          ),
          
          // Form Content
          Padding(
            padding: const EdgeInsets.all(24),
            child: _activeTab == 0 ? _buildBusTicketForm(context) : _buildCharterForm(context),
          ),
        ],
      ),
    );
  }

  Widget _buildTab(int index, String title, IconData icon) {
    final isActive = _activeTab == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _activeTab = index),
        behavior: HitTestBehavior.opaque,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: isActive ? const Color(0xFF10207A) : Colors.transparent,
                width: 2,
              ),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 18, color: isActive ? const Color(0xFF10207A) : const Color(0xFF6B7280)),
              const SizedBox(width: 8),
              Text(
                title,
                style: AppTextStyles.bodyBold.copyWith(
                  fontSize: 14,
                  color: isActive ? const Color(0xFF10207A) : const Color(0xFF6B7280),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBusTicketForm(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('DARI', style: AppTextStyles.label.copyWith(color: const Color(0xFF6B7280), fontSize: 10, fontWeight: FontWeight.w800, letterSpacing: 0.5)),
        const SizedBox(height: 6),
        _SearchInput(icon: LucideIcons.mapPin, text: _origin, onTap: () => _selectCity(true)),
        const SizedBox(height: 16),
        Text('TUJUAN', style: AppTextStyles.label.copyWith(color: const Color(0xFF6B7280), fontSize: 10, fontWeight: FontWeight.w800, letterSpacing: 0.5)),
        const SizedBox(height: 6),
        _SearchInput(icon: LucideIcons.navigation, text: _destination, isHint: _destination == 'Pilih Kota Tujuan', onTap: () => _selectCity(false)),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('TANGGAL', style: AppTextStyles.label.copyWith(color: const Color(0xFF6B7280), fontSize: 10, fontWeight: FontWeight.w800, letterSpacing: 0.5)),
                  const SizedBox(height: 6),
                  _SearchInput(icon: LucideIcons.calendar, text: DateFormat('dd MMM yyyy', 'id_ID').format(_date), onTap: _selectDate),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('PENUMPANG', style: AppTextStyles.label.copyWith(color: const Color(0xFF6B7280), fontSize: 10, fontWeight: FontWeight.w800, letterSpacing: 0.5)),
                  const SizedBox(height: 6),
                  _SearchInput(icon: LucideIcons.users, text: '$_passengers Orang', onTap: _selectPassengers),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () => context.push('/schedule-list?origin=$_origin&destination=$_destination&date=${_date.toString().substring(0, 10)}'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF10207A),
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 0,
            ),
            child: Text('Cari Tiket Bus', style: AppTextStyles.bodyBold.copyWith(color: Colors.white, fontSize: 16)),
          ),
        ),
      ],
    );
  }

  Widget _buildCharterForm(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('KOTA KEBERANGKATAN', style: AppTextStyles.label.copyWith(color: const Color(0xFF6B7280), fontSize: 10, fontWeight: FontWeight.w800, letterSpacing: 0.5)),
                  const SizedBox(height: 6),
                  _SearchInput(icon: LucideIcons.mapPin, text: _charterOrigin, onTap: () => _selectCharterCity(true)),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('KOTA TUJUAN', style: AppTextStyles.label.copyWith(color: const Color(0xFF6B7280), fontSize: 10, fontWeight: FontWeight.w800, letterSpacing: 0.5)),
                  const SizedBox(height: 6),
                  _SearchInput(icon: LucideIcons.navigation, text: _charterDestination, onTap: () => _selectCharterCity(false)),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('TANGGAL MULAI', style: AppTextStyles.label.copyWith(color: const Color(0xFF6B7280), fontSize: 10, fontWeight: FontWeight.w800, letterSpacing: 0.5)),
                  const SizedBox(height: 6),
                  _SearchInput(icon: LucideIcons.calendar, text: DateFormat('dd MMM yyyy', 'id_ID').format(_charterDate), onTap: _selectCharterDate),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('JAM MULAI', style: AppTextStyles.label.copyWith(color: const Color(0xFF6B7280), fontSize: 10, fontWeight: FontWeight.w800, letterSpacing: 0.5)),
                  const SizedBox(height: 6),
                  _SearchInput(icon: LucideIcons.clock, text: _charterTime.format(context), onTap: _selectCharterTime),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              // Combine date and time
              final combinedDate = DateTime(
                _charterDate.year, _charterDate.month, _charterDate.day,
                _charterTime.hour, _charterTime.minute,
              );
              context.push('/charter/request', extra: {
                'origin': _charterOrigin,
                'destination': _charterDestination,
                'date': combinedDate,
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF25D366),
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 0,
            ),
            child: Text('Cari Bus Wisata', style: AppTextStyles.bodyBold.copyWith(color: Colors.white, fontSize: 16)),
          ),
        ),
      ],
    );
  }
}

class _SearchInput extends StatelessWidget {
  final IconData icon;
  final String text;
  final bool isHint;
  final VoidCallback? onTap;

  const _SearchInput({required this.icon, required this.text, this.isHint = false, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
        color: const Color(0xFFF3F4F6), // Slightly darker gray for a better integrated feel
        borderRadius: BorderRadius.circular(12),
        // No borders for a cleaner look
      ),
      child: Row(
        children: [
          Icon(icon, size: 18, color: const Color(0xFF10207A)), // Slightly smaller lucide icon
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text, 
              style: AppTextStyles.body.copyWith(
                color: isHint ? const Color(0xFF9CA3AF) : const Color(0xFF111827),
                fontSize: 14,
                fontWeight: isHint ? FontWeight.normal : FontWeight.w600,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    ),
    );
  }
}

class _QuickLinks extends StatelessWidget {
  const _QuickLinks();

  @override
  Widget build(BuildContext context) {
    const links = [
      ('Cari Tiket', LucideIcons.search, '/schedule-list'),
      ('Sewa Bus', LucideIcons.bus, '/charter'),
      ('Promo', LucideIcons.tags, '/promo'),
      ('Bantuan', LucideIcons.headphones, '/help'),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: links.map((link) {
          return Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => context.push(link.$3),
              borderRadius: BorderRadius.circular(12),
              splashColor: const Color(0xFF10207A).withValues(alpha: 0.1),
              highlightColor: const Color(0xFF10207A).withValues(alpha: 0.05),
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF10207A).withValues(alpha: 0.08),
                            blurRadius: 16,
                            offset: const Offset(0, 6),
                          ),
                          BoxShadow(
                            color: Colors.white.withValues(alpha: 0.8),
                            blurRadius: 4,
                            offset: const Offset(0, -2),
                          ),
                        ],
                        border: Border.all(color: const Color(0xFFEEF0FF), width: 1.5),
                      ),
                      child: Center(
                        child: Icon(link.$2, color: const Color(0xFF10207A), size: 28),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      link.$1,
                      textAlign: TextAlign.center,
                      style: AppTextStyles.bodyBold.copyWith(
                        fontSize: 13, 
                        color: const Color(0xFF1F2937), 
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.2,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _ActiveSchedules extends ConsumerWidget {
  const _ActiveSchedules();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final schedulesAsync = ref.watch(popularRoutesProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Jadwal Aktif', style: AppTextStyles.h2.copyWith(fontSize: 24, color: const Color(0xFF1C1B1B))),
              GestureDetector(
                onTap: () => context.push('/schedule-list'),
                child: Text(
                  'Lihat Semua',
                  style: AppTextStyles.bodyBold.copyWith(color: const Color(0xFF10207A), fontSize: 14),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        schedulesAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, stack) => Center(child: Text('Gagal memuat jadwal: $err')),
          data: (schedules) {
            if (schedules.isEmpty) {
              return const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text('Belum ada jadwal aktif saat ini.'),
              );
            }
            return SizedBox(
              height: 190,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: schedules.length,
                itemBuilder: (context, index) {
                  final schedule = schedules[index];
                  final route = schedule['route'] ?? {};
                  final bus = schedule['bus'] ?? {};
                  
                  bool hasDeparted = false;
                  final depTimeStr = schedule['departure_time']?.toString() ?? '';
                  if (depTimeStr.isNotEmpty) {
                    try {
                      final now = DateTime.now();
                      final dateStr = "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";
                      final depDateTime = DateTime.parse('$dateStr ${depTimeStr.substring(0, 5)}:00');
                      if (now.isAfter(depDateTime)) {
                        hasDeparted = true;
                      }
                    } catch (_) {}
                  }
                  
                  return Container(
                    width: 290,
                    margin: const EdgeInsets.only(right: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFC6C5D3)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 2,
                          offset: const Offset(0, 1),
                        )
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('DARI', style: AppTextStyles.label.copyWith(color: const Color(0xFF454652))),
                                    const SizedBox(height: 2),
                                    Text(route['origin']?.toString() ?? '-', style: AppTextStyles.h3.copyWith(fontSize: 18, color: const Color(0xFF1C1B1B)), overflow: TextOverflow.ellipsis),
                                    const SizedBox(height: 4),
                                    Text(schedule['departure_time']?.toString() ?? '-', style: AppTextStyles.bodyBold.copyWith(color: const Color(0xFF10207A), fontSize: 14)),
                                  ],
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 8),
                                child: Icon(Icons.arrow_forward_rounded, color: Color(0xFFC6C5D3), size: 24),
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text('KE', style: AppTextStyles.label.copyWith(color: const Color(0xFF454652))),
                                    const SizedBox(height: 2),
                                    Text(route['destination']?.toString() ?? '-', style: AppTextStyles.h3.copyWith(fontSize: 18, color: const Color(0xFF1C1B1B)), overflow: TextOverflow.ellipsis),
                                    const SizedBox(height: 4),
                                    Text(schedule['arrival_time']?.toString() ?? '-', style: AppTextStyles.bodyBold.copyWith(color: const Color(0xFF10207A), fontSize: 14)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          decoration: const BoxDecoration(
                            border: Border(top: BorderSide(color: Color(0xFFC6C5D3))),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        const Icon(LucideIcons.bus, size: 14, color: Color(0xFF454652)),
                                        const SizedBox(width: 4),
                                        Expanded(
                                          child: Text(
                                            bus['name']?.toString() ?? 'Sleeper Class',
                                            style: AppTextStyles.bodyBold.copyWith(color: const Color(0xFF454652), fontSize: 12),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0).format(double.tryParse(schedule['price']?.toString() ?? '0') ?? 0),
                                      style: AppTextStyles.bodyBold.copyWith(color: const Color(0xFF10207A), fontSize: 14)
                                    ),
                                  ],
                                ),
                              ),
                              ElevatedButton(
                                onPressed: hasDeparted ? null : () => context.push('/seat-selection/${schedule['id']}'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF10207A),
                                  disabledBackgroundColor: Colors.grey.shade300,
                                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                  minimumSize: const Size(0, 36),
                                ),
                                child: Text(hasDeparted ? 'Berangkat' : 'Pesan', style: AppTextStyles.bodyBold.copyWith(color: hasDeparted ? Colors.grey.shade600 : Colors.white, fontSize: 12)),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            );
          },
    ),
  ],
);
  }
}

class _HomeFooterShapes extends StatelessWidget {
  const _HomeFooterShapes();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120,
      width: double.infinity,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Red/Orange accent circle
          Positioned(
            bottom: -20, left: -20,
            child: Container(width: 140, height: 140, decoration: const BoxDecoration(shape: BoxShape.circle, color: Color(0xFFE63946))), // Accent red
          ),
          // Dark Blue box
          Positioned(
            bottom: 20, right: 40,
            child: Container(width: 80, height: 80, decoration: BoxDecoration(color: const Color(0xFF10207A), borderRadius: BorderRadius.circular(20))),
          ),
          // Gold/Yellow circle
          Positioned(
            bottom: -30, right: -10,
            child: Container(width: 100, height: 100, decoration: const BoxDecoration(shape: BoxShape.circle, color: Color(0xFFF4A261))), // Accent Gold
          ),
          // Dark blue curved block
          Positioned(
            bottom: 0, left: 80,
            child: Container(width: 150, height: 60, decoration: const BoxDecoration(color: Color(0xFF10207A), borderRadius: BorderRadius.vertical(top: Radius.circular(60)))),
          ),
          // Small white dot
          Positioned(
            bottom: 40, left: 160,
            child: Container(width: 40, height: 40, decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
