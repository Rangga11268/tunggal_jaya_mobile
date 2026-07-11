import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../auth/presentation/pages/auth_shared.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../../core/config/app_theme.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final userName = authState.user?['name'] as String? ?? 'Penumpang';

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Header(userName: userName),
          const SizedBox(height: 20),
          const _SearchCard(),
          const SizedBox(height: 24),
          const _SectionHeader(
            title: 'Rute Populer',
            onSeeAll: null,
          ),
          const SizedBox(height: 14),
          const _RouteList(),
          const SizedBox(height: 24),
          const _SectionHeader(
            title: 'Berita Terbaru',
            onSeeAll: null,
          ),
          const SizedBox(height: 14),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                _NewsCard(
                  image: 'assets/images/bentas01.webp',
                  title: 'Info Jadwal Perjalanan Terbaru & Terupdate',
                  excerpt: 'Dapatkan informasi lengkap mengenai jadwal keberangkatan terbaru armada Tunggal Jaya Transport.',
                  date: '05 Mar 2026',
                ),
                SizedBox(height: 12),
                _NewsCard(
                  image: 'assets/images/bentas02.webp',
                  title: 'Jelajahi Rute & Armada Kelas Premium',
                  excerpt: 'Nikmati kenyamanan perjalanan dengan armada premium kami.',
                  date: '05 Mar 2026',
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const _SectionHeader(
            title: 'Armada Kami',
            onSeeAll: null,
          ),
          const SizedBox(height: 14),
          const Padding(
            padding: EdgeInsets.fromLTRB(20, 0, 20, 32),
            child: _FleetCard(),
          ),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final String userName;

  const _Header({required this.userName});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: AuthPalette.border)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                          color: AppColors.primary.withValues(alpha: 0.2),
                          width: 1.5),
                    ),
                    child: Center(
                      child: Text(
                        (userName).substring(0, 1).toUpperCase(),
                        style: authBodyStyle(
                          size: 18,
                          weight: FontWeight.w700,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Halo, $userName',
                          style: authBodyStyle(
                            size: 15,
                            weight: FontWeight.w700,
                            color: AuthPalette.textPrimary,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          'Mau kemana hari ini?',
                          style: authBodyStyle(size: 13),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Stack(
                children: [
                  IconButton(
                    icon: const Icon(Icons.notifications_outlined,
                        color: AuthPalette.textSecondary),
                    onPressed: () {},
                  ),
                  Positioned(
                    right: 12,
                    top: 10,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            'Cari Tiket Bus',
            style: authTitleStyle(size: 24),
          ),
          const SizedBox(height: 4),
          Text(
            'Temukan jadwal perjalanan Anda',
            style: authBodyStyle(),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

class _SearchCard extends StatelessWidget {
  const _SearchCard();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: AuthCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.search_rounded,
                    size: 16, color: AuthPalette.muted),
                const SizedBox(width: 8),
                Text(
                  'CARI JADWAL',
                  style: authBodyStyle(
                    size: 11,
                    weight: FontWeight.w700,
                    color: AuthPalette.muted,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _SearchField(
              icon: Icons.trip_origin_rounded,
              hint: 'Kota Asal',
            ),
            const SizedBox(height: 4),
            Center(
              child: Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.swap_vert_rounded,
                  color: AppColors.primary,
                  size: 18,
                ),
              ),
            ),
            const SizedBox(height: 4),
            _SearchField(
              icon: Icons.location_on_rounded,
              hint: 'Kota Tujuan',
            ),
            const SizedBox(height: 12),
            _SearchField(
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
    );
  }
}

class _SearchField extends StatelessWidget {
  final IconData icon;
  final String hint;

  const _SearchField({required this.icon, required this.hint});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
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
              hint,
              style: authBodyStyle(
                size: 14,
                color: AuthPalette.muted,
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

class _SectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback? onSeeAll;

  const _SectionHeader({required this.title, this.onSeeAll});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: authTitleStyle(size: 18)),
          if (onSeeAll != null)
            GestureDetector(
              onTap: onSeeAll,
              child: Row(
                children: [
                  Text(
                    'Lihat Semua',
                    style: authBodyStyle(
                      size: 13,
                      weight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(width: 2),
                  const Icon(Icons.chevron_right,
                      size: 16, color: AppColors.primary),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _RouteList extends StatelessWidget {
  const _RouteList();

  @override
  Widget build(BuildContext context) {
    final routes = [
      _RouteData('Surabaya', 'Banyuwangi', 'Rp 85.000', '2,5 jam'),
      _RouteData('Banyuwangi', 'Denpasar', 'Rp 120.000', '4 jam'),
      _RouteData('Surabaya', 'Denpasar', 'Rp 155.000', '6,5 jam'),
    ];

    return SizedBox(
      height: 160,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: routes.length,
        itemBuilder: (context, index) {
          final route = routes[index];
          return Container(
            width: 200,
            margin: const EdgeInsets.only(right: 12),
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AuthPalette.border),
              boxShadow: AppShadows.card,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.route_rounded,
                      color: AppColors.primary, size: 18),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(route.origin,
                        style: authBodyStyle(
                            size: 15,
                            weight: FontWeight.w700,
                            color: AuthPalette.textPrimary)),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        const Icon(Icons.arrow_forward_rounded,
                            size: 12, color: AuthPalette.muted),
                        const SizedBox(width: 4),
                        Text(route.destination,
                            style: authBodyStyle(
                                size: 15,
                                weight: FontWeight.w700,
                                color: AuthPalette.textPrimary)),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(route.price,
                            style: authBodyStyle(
                                size: 16,
                                weight: FontWeight.w700,
                                color: AppColors.primary)),
                        Row(
                          children: [
                            const Icon(Icons.schedule_rounded,
                                size: 12, color: AuthPalette.muted),
                            const SizedBox(width: 2),
                            Text(route.duration,
                                style: authBodyStyle(
                                    size: 11, color: AuthPalette.muted)),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _RouteData {
  final String origin;
  final String destination;
  final String price;
  final String duration;
  _RouteData(this.origin, this.destination, this.price, this.duration);
}

class _NewsCard extends StatelessWidget {
  final String image;
  final String title;
  final String excerpt;
  final String date;

  const _NewsCard({
    required this.image,
    required this.title,
    required this.excerpt,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AuthPalette.border),
      ),
      clipBehavior: Clip.antiAlias,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.horizontal(
                left: Radius.circular(20)),
            child: Image.asset(
              image,
              width: 100,
              height: 100,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                width: 100,
                height: 100,
                color: AuthPalette.background,
                child: const Icon(Icons.image_outlined,
                    color: AuthPalette.muted),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: authBodyStyle(
                        size: 13,
                        weight: FontWeight.w600,
                        color: AuthPalette.textPrimary),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    excerpt,
                    style: authBodyStyle(size: 11),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.calendar_today_rounded,
                          size: 11, color: AuthPalette.muted),
                      const SizedBox(width: 4),
                      Text(
                        date,
                        style: authBodyStyle(
                            size: 11, color: AuthPalette.muted),
                      ),
                    ],
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

class _FleetCard extends StatelessWidget {
  const _FleetCard();

  @override
  Widget build(BuildContext context) {
    return AuthCard(
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.asset(
              'assets/images/primadona.webp',
              width: 90,
              height: 100,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                width: 90,
                height: 100,
                color: AuthPalette.background,
                child: const Icon(Icons.directions_bus_rounded,
                    size: 36, color: AuthPalette.muted),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Armada Premium',
                    style: authBodyStyle(
                        size: 16,
                        weight: FontWeight.w700,
                        color: AuthPalette.textPrimary)),
                const SizedBox(height: 2),
                Text('Executive & Business Class',
                    style: authBodyStyle(size: 12)),
                const SizedBox(height: 10),
                Row(
                  children: [
                    _FacilityChip(
                        icon: Icons.airline_seat_recline_normal_rounded,
                        label: 'Kursi Ergonomis'),
                    const SizedBox(width: 10),
                    _FacilityChip(
                        icon: Icons.wifi_rounded, label: 'WiFi Gratis'),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FacilityChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _FacilityChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 12, color: AppColors.primary),
        const SizedBox(width: 4),
        Text(label,
            style: authBodyStyle(
                size: 10, color: AuthPalette.textSecondary)),
      ],
    );
  }
}
