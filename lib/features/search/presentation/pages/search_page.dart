import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../auth/presentation/pages/auth_shared.dart';
import '../../../../core/config/app_theme.dart';
import '../../data/search_repository.dart';
import 'package:intl/intl.dart';

final searchOriginProvider = StateProvider<String?>((ref) => null);
final searchDestinationProvider = StateProvider<String?>((ref) => null);
final searchDateProvider = StateProvider<DateTime?>((ref) => null);

class SearchPage extends ConsumerWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final originsDestinationsAsync = ref.watch(originsDestinationsProvider);
    final origin = ref.watch(searchOriginProvider);
    final destination = ref.watch(searchDestinationProvider);
    final date = ref.watch(searchDateProvider);

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _PageHeader(
            title: 'Cari Jadwal',
            subtitle: 'Temukan tiket bus sesuai kebutuhan Anda',
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: AuthCard(
              child: originsDestinationsAsync.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stack) => Text('Error: $error'),
                data: (data) {
                  final origins = (data['data']['origins'] as List).cast<String>();
                  final destinations = (data['data']['destinations'] as List).cast<String>();

                  return Column(
                    children: [
                      _DropdownSearchInput(
                        icon: Icons.trip_origin_rounded,
                        hint: 'Kota Asal',
                        value: origin,
                        items: origins,
                        onChanged: (val) => ref.read(searchOriginProvider.notifier).state = val,
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 4),
                        child: Icon(Icons.swap_vert_rounded, color: AppColors.primary, size: 20),
                      ),
                      _DropdownSearchInput(
                        icon: Icons.location_on_rounded,
                        hint: 'Kota Tujuan',
                        value: destination,
                        items: destinations,
                        onChanged: (val) => ref.read(searchDestinationProvider.notifier).state = val,
                      ),
                      const SizedBox(height: 12),
                      _DateSearchInput(
                        icon: Icons.calendar_month_rounded,
                        hint: 'Tanggal Keberangkatan',
                        value: date,
                        onChanged: (val) => ref.read(searchDateProvider.notifier).state = val,
                      ),
                      const SizedBox(height: 18),
                      AuthPrimaryButton(
                        label: 'Cari Tiket',
                        onPressed: (origin != null && destination != null && date != null)
                            ? () {
                                final dateStr = DateFormat('yyyy-MM-dd').format(date);
                                context.push('/schedule-list?origin=$origin&destination=$destination&date=$dateStr');
                              }
                            : null, // disabled if incomplete
                      ),
                    ],
                  );
                },
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

class _DropdownSearchInput extends StatelessWidget {
  final IconData icon;
  final String hint;
  final String? value;
  final List<String> items;
  final ValueChanged<String?> onChanged;

  const _DropdownSearchInput({
    required this.icon,
    required this.hint,
    required this.value,
    required this.items,
    required this.onChanged,
  });

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
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: value,
                hint: Text(hint, style: authBodyStyle(size: 14, color: AuthPalette.muted)),
                isExpanded: true,
                items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                onChanged: onChanged,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DateSearchInput extends StatelessWidget {
  final IconData icon;
  final String hint;
  final DateTime? value;
  final ValueChanged<DateTime?> onChanged;

  const _DateSearchInput({
    required this.icon,
    required this.hint,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final date = await showDatePicker(
          context: context,
          initialDate: value ?? DateTime.now(),
          firstDate: DateTime.now(),
          lastDate: DateTime.now().add(const Duration(days: 90)),
        );
        if (date != null) onChanged(date);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
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
              child: Text(
                value == null ? hint : DateFormat('dd MMM yyyy').format(value!),
                style: authBodyStyle(
                  size: 14,
                  color: value == null ? AuthPalette.muted : AppColors.primaryText,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
