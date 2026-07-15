import 'package:flutter/material.dart';
import '../../../auth/presentation/pages/auth_shared.dart';
import '../../../../core/config/app_theme.dart';
import 'package:go_router/go_router.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../search/data/search_repository.dart';

class RoutesPage extends ConsumerStatefulWidget {
  const RoutesPage({super.key});

  @override
  ConsumerState<RoutesPage> createState() => _RoutesPageState();
}

class _RoutesPageState extends ConsumerState<RoutesPage> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final routesAsync = ref.watch(routesProvider);

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(
                  bottom: BorderSide(color: AuthPalette.border)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Rute Perjalanan',
                    style: authTitleStyle(size: 24)),
                const SizedBox(height: 4),
                Text(
                  'Jelajahi semua rute yang tersedia',
                  style: authBodyStyle(),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 2),
                  decoration: BoxDecoration(
                    color: AuthPalette.background,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AuthPalette.border),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.search_rounded,
                          size: 18, color: AuthPalette.muted),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          onChanged: (val) {
                            setState(() => _searchQuery = val);
                          },
                          decoration: InputDecoration(
                            hintText: 'Cari rute...',
                            hintStyle: authBodyStyle(
                                size: 14, color: AuthPalette.muted),
                            border: InputBorder.none,
                            isDense: true,
                            contentPadding:
                                const EdgeInsets.symmetric(vertical: 12),
                          ),
                          style: authBodyStyle(
                              size: 14,
                              color: AuthPalette.textPrimary),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Semua Rute',
                  style: authBodyStyle(
                    size: 13,
                    weight: FontWeight.w700,
                    color: AuthPalette.muted,
                  ),
                ),
                const SizedBox(height: 12),
                routesAsync.when(
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (err, stack) => Center(child: Text('Gagal memuat rute: $err')),
                  data: (data) {
                    final routesList = data['data'] as List<dynamic>;
                    
                    final filteredRoutes = routesList.where((route) {
                      final origin = (route['origin'] as String).toLowerCase();
                      final destination = (route['destination'] as String).toLowerCase();
                      final query = _searchQuery.toLowerCase();
                      return origin.contains(query) || destination.contains(query);
                    }).toList();

                    if (filteredRoutes.isEmpty) {
                      return const Center(child: Text('Tidak ada rute.'));
                    }

                    return Column(
                      children: filteredRoutes.map((route) => _RouteCard(route: route)).toList(),
                    );
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class _RouteCard extends StatelessWidget {
  final dynamic route;

  const _RouteCard({required this.route});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AuthPalette.border),
        boxShadow: AppShadows.card,
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(Icons.route_rounded,
                color: AppColors.primary, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(route['origin'],
                        style: authBodyStyle(
                            size: 15,
                            weight: FontWeight.w700,
                            color: AuthPalette.textPrimary)),
                    const SizedBox(width: 6),
                    const Icon(Icons.arrow_forward_rounded,
                        size: 14, color: AuthPalette.muted),
                    const SizedBox(width: 6),
                    Text(route['destination'],
                        style: authBodyStyle(
                            size: 15,
                            weight: FontWeight.w700,
                            color: AuthPalette.textPrimary)),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.schedule_rounded,
                        size: 12, color: AuthPalette.muted),
                    const SizedBox(width: 4),
                    Text('${route['duration']} mnt',
                        style: authBodyStyle(
                            size: 12, color: AuthPalette.muted)),
                    const SizedBox(width: 16),
                    Text('Jarak',
                        style: authBodyStyle(
                            size: 12, color: AuthPalette.muted)),
                    const SizedBox(width: 4),
                    Text('${route['distance']} km',
                        style: authBodyStyle(
                            size: 14,
                            weight: FontWeight.w700,
                            color: AppColors.primary)),
                  ],
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () => context.push('/schedule-list?origin=${route['origin']}&destination=${route['destination']}&date='),
            child: Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text('Lihat',
                  style: authBodyStyle(
                      size: 12,
                      weight: FontWeight.w700,
                      color: AppColors.primary)),
            ),
          ),
        ],
      ),
    );
  }
}
