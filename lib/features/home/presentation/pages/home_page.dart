import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

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
          const _SearchBar(),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text('Layanan', style: AppTextStyles.label),
          ),
          const SizedBox(height: 12),
          const _QuickLinks(),
          const SizedBox(height: 28),
          const _SectionHeader(title: 'Armada Kami'),
          const SizedBox(height: 14),
          const _FleetList(),
          const SizedBox(height: 28),
          const _SectionHeader(title: 'Berita Terbaru'),
          const SizedBox(height: 14),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                _NewsCard(image: 'assets/images/bentas01.webp', title: 'Info Jadwal Perjalanan Terbaru & Terupdate', date: '05 Mar 2026'),
                SizedBox(height: 12),
                _NewsCard(image: 'assets/images/bentas02.webp', title: 'Jelajahi Rute & Armada Kelas Premium', date: '05 Mar 2026'),
              ],
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}

class _Header extends ConsumerWidget {
  final String userName;
  const _Header({required this.userName});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: AppColors.borderStrong)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44, height: 44,
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
                child: Center(
                  child: Text(
                    (userName).substring(0, 1).toUpperCase(),
                    style: authTitleStyle(size: 18, color: AppColors.primary),
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Halo, $userName', style: authBodyStyle(size: 15, weight: FontWeight.w700)),
                    Text('Mau kemana hari ini?', style: authBodyStyle(size: 13)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

class _SearchBar extends StatelessWidget {
  const _SearchBar();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GestureDetector(
        onTap: () => context.push('/search'),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppRadius.md),
            border: Border.all(color: AppColors.borderStrong),
            boxShadow: AppShadows.soft,
          ),
          child: Row(
            children: [
              const Icon(Icons.search_rounded, size: 20, color: AppColors.muted),
              const SizedBox(width: 12),
              Text('Cari tujuan...', style: authBodyStyle(size: 15, color: AppColors.muted)),
            ],
          ),
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
      ('Cari Tiket', Icons.directions_bus_rounded, '/search'),
      ('Sewa Wisata', Icons.beach_access_rounded, '/charter'),
      ('Pesanan', Icons.confirmation_number_rounded, '/bookings'),
      ('Armada', Icons.directions_bus_filled_rounded, '/fleet'),
      ('Rute', Icons.alt_route_rounded, '/routes'),
      ('Hubungi', Icons.headset_mic_rounded, '/contact'),
    ];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3, crossAxisSpacing: 12, mainAxisSpacing: 12, childAspectRatio: 1.0,
        ),
        itemCount: links.length,
        itemBuilder: (_, i) {
          final (label, icon, route) = links[i];
          return GestureDetector(
            onTap: () => context.push(route),
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(AppRadius.lg),
                border: Border.all(color: AppColors.borderStrong),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icon, size: 28, color: AppColors.primary),
                  const SizedBox(height: 8),
                  Text(label, style: authBodyStyle(size: 12, weight: FontWeight.w600)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback? onTap;
  const _SectionHeader({required this.title, this.onTap});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: authTitleStyle(size: 18)),
          if (onTap != null)
            GestureDetector(
              onTap: onTap,
              child: Row(
                children: [
                  Text('Lihat Semua', style: authBodyStyle(size: 13, weight: FontWeight.w600, color: AppColors.primary)),
                  const SizedBox(width: 2),
                  const Icon(Icons.chevron_right, size: 16, color: AppColors.primary),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _FleetList extends StatelessWidget {
  const _FleetList();
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 160,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: 3,
        itemBuilder: (_, i) {
          return Container(
            width: 200, margin: const EdgeInsets.only(right: 12),
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppRadius.lg),
              border: Border.all(color: AppColors.borderStrong),
              boxShadow: AppShadows.card,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.route_rounded, color: AppColors.primary, size: 18),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Surabaya', style: authBodyStyle(size: 15, weight: FontWeight.w700)),
                    const SizedBox(height: 2),
                    Row(children: [
                      const Icon(Icons.arrow_forward_rounded, size: 12, color: AppColors.muted),
                      const SizedBox(width: 4),
                      Text('Banyuwangi', style: authBodyStyle(size: 15, weight: FontWeight.w700)),
                    ]),
                    const SizedBox(height: 6),
                    Text('Rp 85.000', style: authBodyStyle(size: 16, weight: FontWeight.w700, color: AppColors.primary)),
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

class _NewsCard extends StatelessWidget {
  final String image; final String title; final String date;
  const _NewsCard({required this.image, required this.title, required this.date});
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.borderStrong),
      ),
      clipBehavior: Clip.antiAlias,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.horizontal(left: Radius.circular(AppRadius.lg)),
            child: Image.asset(image, width: 100, height: 100, fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                width: 100, height: 100, color: AppColors.primaryLight,
                child: const Icon(Icons.image_outlined, color: AppColors.muted),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: authBodyStyle(size: 13, weight: FontWeight.w600), maxLines: 2, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 8),
                  Row(children: [
                    const Icon(Icons.calendar_today_rounded, size: 11, color: AppColors.muted),
                    const SizedBox(width: 4),
                    Text(date, style: authBodyStyle(size: 11, color: AppColors.muted)),
                  ]),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
