import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/config/app_theme.dart';
import '../../../../core/widgets/section_header.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final userName = authState.user?['name'] as String? ?? 'Penumpang';

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ========== HERO SECTION ==========
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF0B0B0B),
                    Color(0xFF1A1A1A),
                    Color(0xFF0B0B0B),
                  ],
                ),
              ),
              child: SafeArea(
                bottom: false,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // App Bar
                    Padding(
                      padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.asset(
                                    'assets/logo/logo.png',
                                    width: 40,
                                    height: 40,
                                    fit: BoxFit.contain,
                                    errorBuilder: (_, __, ___) => const Icon(
                                      Icons.directions_bus,
                                      size: 22,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Halo, $userName',
                                    style: AppTextStyles.body.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    'Mau kemana hari ini?',
                                    style: AppTextStyles.caption.copyWith(
                                      color: Colors.white70,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Stack(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.notifications_outlined, color: Colors.white),
                                onPressed: () {},
                              ),
                              Positioned(
                                right: 8,
                                top: 8,
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
                    ),
                    const SizedBox(height: 24),

                    // Hero Text
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Text(
                        'Perjalanan\nNyaman &',
                        style: AppTextStyles.heroTitle.copyWith(
                          fontSize: 32,
                          height: 1.1,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Row(
                        children: [
                          Text(
                            'Aman',
                            style: AppTextStyles.heroTitle.copyWith(
                              fontSize: 32,
                              color: AppColors.primary,
                              height: 1.1,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.accent.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              'PREMIUM',
                              style: AppTextStyles.caption.copyWith(
                                color: AppColors.accent,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 1.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Text(
                        'Bersama Tunggal Jaya Transport',
                        style: AppTextStyles.caption.copyWith(
                          color: Colors.white54,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Search Card
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: const Color(0x19FFFFFF),
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(color: const Color(0x33FFFFFF)),
                        ),
                        child: Column(
                          children: [
                            _SearchField(
                              icon: Icons.location_on_outlined,
                              hint: 'Kota Asal',
                            ),
                            const SizedBox(height: 8),
                              Container(
                                margin: const EdgeInsets.symmetric(horizontal: 16),
                                child: Icon(
                                  Icons.swap_vert,
                                  color: Colors.white.withValues(alpha: 0.5),
                                  size: 20,
                                ),
                              ),
                            const SizedBox(height: 8),
                            _SearchField(
                              icon: Icons.location_on_outlined,
                              hint: 'Kota Tujuan',
                            ),
                            const SizedBox(height: 12),
                            _SearchField(
                              icon: Icons.calendar_today_outlined,
                              hint: 'Tanggal Keberangkatan',
                            ),
                            const SizedBox(height: 20),
                            SizedBox(
                              width: double.infinity,
                              height: 54,
                              child: ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primary,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                  elevation: 0,
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(Icons.search, color: Colors.white, size: 20),
                                    const SizedBox(width: 8),
                                    Text(
                                      'Cari Tiket',
                                      style: AppTextStyles.button,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),

            // ========== SHORTCUT CATEGORIES ==========
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _CategoryItem(
                    icon: Icons.route_outlined,
                    label: 'Rute',
                    color: AppColors.primary,
                    onTap: () {},
                  ),
                  _CategoryItem(
                    icon: Icons.bus_alert_outlined,
                    label: 'Armada',
                    color: const Color(0xFF8B5CF6),
                    onTap: () {},
                  ),
                  _CategoryItem(
                    icon: Icons.percent_outlined,
                    label: 'Promo',
                    color: AppColors.accent,
                    onTap: () {},
                  ),
                  _CategoryItem(
                    icon: Icons.newspaper_outlined,
                    label: 'Berita',
                    color: AppColors.info,
                    onTap: () {},
                  ),
                ],
              ),
            ),

            // ========== FEATURED ROUTES ==========
            const SectionHeader(
              title: 'Rute Populer',
              actionLabel: 'Lihat Semua',
            ),
            SizedBox(
              height: 190,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 24),
                itemCount: 3,
                itemBuilder: (context, index) {
                  final routes = [
                    _RouteData('Surabaya', 'Banyuwangi', 'Rp 85.000', '2.5 jam', AppColors.primary),
                    _RouteData('Banyuwangi', 'Denpasar', 'Rp 120.000', '4 jam', const Color(0xFF8B5CF6)),
                    _RouteData('Surabaya', 'Denpasar', 'Rp 155.000', '6.5 jam', const Color(0xFF0EA5E9)),
                  ];
                  final route = routes[index];
                  return Container(
                    width: 200,
                    margin: const EdgeInsets.only(right: 12),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          route.color,
                          route.color.withValues(alpha: 0.7),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.route, color: Colors.white, size: 20),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${route.origin} → ${route.destination}',
                              style: AppTextStyles.body.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Text(
                                  route.price,
                                  style: AppTextStyles.bodyBold.copyWith(
                                    color: Colors.white,
                                    fontSize: 18,
                                  ),
                                ),
                                const Spacer(),
                                Icon(Icons.schedule, color: Colors.white.withValues(alpha: 0.7), size: 14),
                                const SizedBox(width: 4),
                                Text(
                                  route.duration,
                                  style: AppTextStyles.caption.copyWith(color: Colors.white70),
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
            ),

            const SizedBox(height: 8),

            // ========== NEWS SECTION ==========
            const SectionHeader(
              title: 'Berita Terbaru',
              actionLabel: 'Lihat Semua',
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  _NewsCard(
                    image: 'assets/images/bentas01.webp',
                    title: 'Info Jadwal Perjalanan Terbaru & Terupdate',
                    excerpt: 'Dapatkan informasi lengkap mengenai jadwal keberangkatan terbaru armada Tunggal Jaya Transport.',
                    date: '05 Mar 2026',
                  ),
                  const SizedBox(height: 12),
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

            // ========== FLEET PREVIEW ==========
            const SectionHeader(
              title: 'Armada Kami',
              actionLabel: 'Lihat Semua',
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.darkBg,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.asset(
                          'assets/images/primadona.webp',
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => const Icon(
                            Icons.directions_bus,
                            size: 40,
                            color: Colors.white54,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Armada Premium',
                            style: AppTextStyles.h4.copyWith(color: Colors.white),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Executive & Business Class',
                            style: AppTextStyles.caption.copyWith(color: Colors.white54),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              const Icon(Icons.airline_seat_recline_extra, size: 16, color: AppColors.accent),
                              const SizedBox(width: 4),
                              Text('Kursi Ergonomis', style: AppTextStyles.caption.copyWith(color: Colors.white70, fontSize: 11)),
                              const SizedBox(width: 12),
                              const Icon(Icons.wifi, size: 16, color: AppColors.accent),
                              const SizedBox(width: 4),
                              Text('WiFi', style: AppTextStyles.caption.copyWith(color: Colors.white70, fontSize: 11)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
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
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.white.withValues(alpha: 0.5)),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              readOnly: true,
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.4), fontSize: 14),
                border: InputBorder.none,
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 14),
              ),
              style: TextStyle(color: Colors.white, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _CategoryItem({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 8),
          Text(label, style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.w600)),
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
  final Color color;

  _RouteData(this.origin, this.destination, this.price, this.duration, this.color);
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
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.border),
      ),
      clipBehavior: Clip.antiAlias,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.horizontal(left: Radius.circular(24)),
            child: Image.asset(
              image,
              width: 120,
              height: 120,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                width: 120,
                height: 120,
                color: AppColors.roseLight,
                child: const Icon(Icons.image_outlined, color: AppColors.disabled),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.bodyMedium.copyWith(fontSize: 14),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    excerpt,
                    style: AppTextStyles.caption.copyWith(fontSize: 11),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.calendar_today, size: 12, color: AppColors.disabled),
                      const SizedBox(width: 4),
                      Text(date, style: AppTextStyles.caption.copyWith(fontSize: 11)),
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
