import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/config/app_theme.dart';
import '../../../auth/presentation/pages/auth_shared.dart';
import '../../../../core/widgets/tj_page_header.dart';
import '../../../../core/widgets/tj_background.dart';

class CharterLandingPage extends StatelessWidget {
  const CharterLandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: TjBackground(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const TjPageHeader(
                title: 'Sewa Pariwisata',
                subtitle: 'Layanan charter bus premium',
                showBackButton: true,
              ),
              // Hero
              Container(
                height: 220,
                width: double.infinity,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/heroImg.jpg'), // using existing heroImg
                    fit: BoxFit.cover,
                  ),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.black.withValues(alpha: 0.7), Colors.transparent],
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                    ),
                  ),
                  padding: const EdgeInsets.all(20),
                  alignment: Alignment.bottomLeft,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.8),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          'Premium Service',
                          style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Sewa Bus Pariwisata',
                        style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
              
              // Content
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Kenapa Memilih Kami?', style: authTitleStyle(size: 20)),
                    const SizedBox(height: 16),
                    const _FeatureItem(
                      icon: Icons.directions_bus_rounded,
                      title: 'Armada Terbaru',
                      desc: 'Fasilitas premium dengan Big Bus (50 seat) & Medium Bus (31 seat).',
                    ),
                    const SizedBox(height: 12),
                    const _FeatureItem(
                      icon: Icons.person_pin_circle_rounded,
                      title: 'Kru Profesional',
                      desc: 'Pengemudi handal dan ramah menemani perjalanan wisata Anda.',
                    ),
                    const SizedBox(height: 12),
                    const _FeatureItem(
                      icon: Icons.security_rounded,
                      title: 'Aman & Terawat',
                      desc: 'Perawatan rutin sebelum dan sesudah perjalanan.',
                    ),
                    const SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      height: 54,
                      child: AuthPrimaryButton(
                        label: 'Minta Penawaran Harga',
                        onPressed: () {
                          context.push('/charter/request');
                        },
                      ),
                    ),
                    const SizedBox(height: 40),
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

class _FeatureItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String desc;

  const _FeatureItem({required this.icon, required this.title, required this.desc});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: AppColors.primary, size: 24),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: authTitleStyle(size: 16)),
              const SizedBox(height: 4),
              Text(desc, style: authBodyStyle(size: 14)),
            ],
          ),
        ),
      ],
    );
  }
}
