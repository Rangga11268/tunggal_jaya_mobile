import 'package:flutter/material.dart';
import '../../../auth/presentation/pages/auth_shared.dart';
import '../../../../core/config/app_theme.dart';
import 'package:go_router/go_router.dart';

class RoutesPage extends StatelessWidget {
  const RoutesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final routes = [
      _RouteData(
        'Surabaya', 'Banyuwangi', 'Rp 85.000', '2,5 jam',
        Icons.route_rounded,
      ),
      _RouteData(
        'Banyuwangi', 'Denpasar', 'Rp 120.000', '4 jam',
        Icons.route_rounded,
      ),
      _RouteData(
        'Surabaya', 'Denpasar', 'Rp 155.000', '6,5 jam',
        Icons.route_rounded,
      ),
      _RouteData(
        'Banyuwangi', 'Surabaya', 'Rp 85.000', '2,5 jam',
        Icons.route_rounded,
      ),
      _RouteData(
        'Denpasar', 'Banyuwangi', 'Rp 120.000', '4 jam',
        Icons.route_rounded,
      ),
      _RouteData(
        'Denpasar', 'Surabaya', 'Rp 155.000', '6,5 jam',
        Icons.route_rounded,
      ),
    ];

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
                ...routes.map((route) => _RouteCard(route: route)),
              ],
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class _RouteData {
  final String origin;
  final String destination;
  final String price;
  final String duration;
  final IconData icon;

  _RouteData(
    this.origin,
    this.destination,
    this.price,
    this.duration,
    this.icon,
  );
}

class _RouteCard extends StatelessWidget {
  final _RouteData route;

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
                    Text(route.origin,
                        style: authBodyStyle(
                            size: 15,
                            weight: FontWeight.w700,
                            color: AuthPalette.textPrimary)),
                    const SizedBox(width: 6),
                    const Icon(Icons.arrow_forward_rounded,
                        size: 14, color: AuthPalette.muted),
                    const SizedBox(width: 6),
                    Text(route.destination,
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
                    Text(route.duration,
                        style: authBodyStyle(
                            size: 12, color: AuthPalette.muted)),
                    const SizedBox(width: 16),
                    Text('Mulai',
                        style: authBodyStyle(
                            size: 12, color: AuthPalette.muted)),
                    const SizedBox(width: 4),
                    Text(route.price,
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
            onTap: () => context.go('/search'),
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
