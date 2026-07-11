import 'package:flutter/material.dart';
import '../../../auth/presentation/pages/auth_shared.dart';
import '../../../../core/config/app_theme.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _PageHeader(
            title: 'Cari Jadwal',
            subtitle: 'Temukan tiket bus sesuai kebutuhan Anda',
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: AuthCard(
              child: Column(
                children: [
                  _SearchInput(
                    icon: Icons.trip_origin_rounded,
                    hint: 'Kota Asal',
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 4),
                    child: Icon(Icons.swap_vert_rounded,
                        color: AppColors.primary, size: 20),
                  ),
                  _SearchInput(
                    icon: Icons.location_on_rounded,
                    hint: 'Kota Tujuan',
                  ),
                  const SizedBox(height: 12),
                  _SearchInput(
                    icon: Icons.calendar_month_rounded,
                    hint: 'Tanggal Keberangkatan',
                  ),
                  const SizedBox(height: 18),
                  AuthPrimaryButton(
                    label: 'Cari Tiket',
                    onPressed: () {},
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PageHeader extends StatelessWidget {
  final String title;
  final String subtitle;

  const _PageHeader({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: AuthPalette.border)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: authTitleStyle(size: 24)),
          const SizedBox(height: 4),
          Text(subtitle, style: authBodyStyle()),
        ],
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
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
      decoration: BoxDecoration(
        color: AuthPalette.background,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AuthPalette.border),
      ),
      child: Row(
        children: [
          Icon(icon, size: 18, color: AuthPalette.muted),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              readOnly: true,
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: authBodyStyle(
                    size: 14, color: AuthPalette.muted),
                border: InputBorder.none,
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ),
          Icon(Icons.keyboard_arrow_down_rounded,
              size: 18, color: AuthPalette.muted),
        ],
      ),
    );
  }
}
