import 'package:flutter/material.dart';
import '../../../../core/config/app_theme.dart';
import '../../../../core/widgets/empty_state_widget.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF0B0B0B),
                      Color(0xFF1A1A1A),
                    ],
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Cari Jadwal',
                      style: AppTextStyles.heroTitle.copyWith(fontSize: 28),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Temukan tiket bus sesuai kebutuhan Anda',
                      style: AppTextStyles.caption.copyWith(color: Colors.white54, fontSize: 14),
                    ),
                  ],
                ),
              ),

              // Search Form
              Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    // Origin - Destination
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: AppColors.border),
                        boxShadow: AppShadows.card,
                      ),
                      child: Column(
                        children: [
                          const _SearchInput(
                            icon: Icons.location_on_outlined,
                            hint: 'Kota Asal',
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Icon(Icons.swap_vert, color: AppColors.primary, size: 20),
                          ),
                          const _SearchInput(
                            icon: Icons.location_on_outlined,
                            hint: 'Kota Tujuan',
                          ),
                          const SizedBox(height: 12),
                          const _SearchInput(
                            icon: Icons.calendar_today_outlined,
                            hint: 'Tanggal Keberangkatan',
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            width: double.infinity,
                            height: 54,
                            child: ElevatedButton(
                              onPressed: () {},
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.search, size: 20),
                                  const SizedBox(width: 8),
                                  Text('Cari Tiket'.toUpperCase()),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SearchInput extends StatelessWidget {
  final IconData icon;
  final String hint;

  const _SearchInput({required this.icon, required this.hint});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.roseLight,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppColors.disabled),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              readOnly: true,
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: TextStyle(color: AppColors.disabled, fontSize: 14),
                border: InputBorder.none,
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 14),
              ),
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}
