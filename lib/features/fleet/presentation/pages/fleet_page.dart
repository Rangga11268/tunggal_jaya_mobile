import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../auth/presentation/pages/auth_shared.dart';
import '../../../search/data/search_repository.dart';
import '../../../../core/config/app_theme.dart';

class FleetPage extends ConsumerWidget {
  const FleetPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
              border: Border(bottom: BorderSide(color: AppColors.borderStrong)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Armada Kami', style: authTitleStyle(size: 24)),
                const SizedBox(height: 4),
                Text(
                  'Jelajahi rute perjalanan yang tersedia',
                  style: authBodyStyle(),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: routesAsync.when(
              loading: () => const Center(
                child: Padding(
                  padding: EdgeInsets.all(32),
                  child: CircularProgressIndicator(color: AppColors.primary),
                ),
              ),
              error: (e, _) => Center(
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Text('Gagal memuat data', style: authBodyStyle(color: AppColors.error)),
                ),
              ),
              data: (data) {
                final routes = (data['data'] as List?)?.cast<Map<String, dynamic>>() ?? [];
                if (routes.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32),
                      child: Column(
                        children: [
                          Icon(Icons.directions_bus_outlined, size: 48, color: AppColors.disabled),
                          const SizedBox(height: 12),
                          Text('Belum ada rute', style: authBodyStyle()),
                        ],
                      ),
                    ),
                  );
                }
                return Column(
                  children: routes.map((route) => _RouteCard(route: route)).toList(),
                );
              },
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class _RouteCard extends StatelessWidget {
  final Map<String, dynamic> route;

  const _RouteCard({required this.route});

  @override
  Widget build(BuildContext context) {
    final origin = route['origin'] as String? ?? '';
    final destination = route['destination'] as String? ?? '';
    final name = route['name'] as String? ?? '';
    final duration = route['duration'] as int? ?? 0;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: GestureDetector(
        onTap: () => context.push('/search', extra: {'origin': origin, 'destination': destination}),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppRadius.lg),
            border: Border.all(color: AppColors.borderStrong),
            boxShadow: AppShadows.card,
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
                child: const Icon(Icons.route_rounded, color: AppColors.primary, size: 22),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name, style: authBodyStyle(size: 13, weight: FontWeight.w600, color: AppColors.muted)),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Text(origin, style: authBodyStyle(size: 15, weight: FontWeight.w700)),
                        const SizedBox(width: 6),
                        const Icon(Icons.arrow_forward_rounded, size: 14, color: AppColors.muted),
                        const SizedBox(width: 6),
                        Text(destination, style: authBodyStyle(size: 15, weight: FontWeight.w700)),
                      ],
                    ),
                  ],
                ),
              ),
              if (duration > 0)
                Text('${duration ~/ 60}j', style: authBodyStyle(size: 12, color: AppColors.muted)),
              const SizedBox(width: 8),
              const Icon(Icons.chevron_right_rounded, color: AppColors.muted),
            ],
          ),
        ),
      ),
    );
  }
}
