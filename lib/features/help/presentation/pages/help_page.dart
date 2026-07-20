import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/config/app_theme.dart';
import '../../../../core/widgets/tj_page_header.dart';
import '../../../../core/widgets/tj_background.dart';

class HelpPage extends StatelessWidget {
  const HelpPage({super.key});

  Future<void> _launchWhatsApp() async {
    final Uri url = Uri.parse('https://wa.me/6281234567890?text=Halo%20Tunggal%20Jaya%20Transport,%20saya%20butuh%20bantuan');
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      debugPrint('Could not launch WhatsApp');
    }
  }

  @override
  Widget build(BuildContext context) {
    final faqs = [
      {
        'q': 'Bagaimana cara membatalkan tiket?',
        'a': 'Pembatalan tiket bisa dilakukan paling lambat 24 jam sebelum keberangkatan dengan potongan 25%. Hubungi CS via WhatsApp untuk proses pembatalan.'
      },
      {
        'q': 'Apakah ada biaya tambahan untuk bagasi?',
        'a': 'Setiap penumpang berhak mendapat bagasi gratis maksimal 20kg. Kelebihan bagasi akan dikenakan biaya tambahan sesuai kebijakan kru di lapangan.'
      },
      {
        'q': 'Bagaimana jika saya tertinggal bus?',
        'a': 'Tiket akan hangus dan tidak dapat di-refund jika penumpang tidak berada di titik penjemputan pada waktu keberangkatan.'
      },
      {
        'q': 'Metode pembayaran apa saja yang didukung?',
        'a': 'Kami menerima pembayaran melalui Virtual Account (BCA, Mandiri, BNI, BRI) dan e-Wallet (GoPay, OVO, Dana).'
      },
    ];

    return TjBackground(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const TjPageHeader(
            title: 'Pusat Bantuan',
            subtitle: 'Temukan jawaban atau hubungi kami',
            showBackButton: true,
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFFEEF0FF),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(LucideIcons.messageCircle, color: Color(0xFF10207A)),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Butuh Bantuan Langsung?', style: AppTextStyles.h3.copyWith(fontSize: 16, color: const Color(0xFF10207A))),
                        const SizedBox(height: 4),
                        Text('Customer Service kami siap membantu Anda 24/7.', style: AppTextStyles.body.copyWith(fontSize: 12, color: const Color(0xFF454652))),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _launchWhatsApp,
                icon: const Icon(LucideIcons.send, size: 18),
                label: Text('Hubungi via WhatsApp', style: AppTextStyles.bodyBold.copyWith(color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF25D366),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 0,
                ),
              ),
            ),
            const SizedBox(height: 32),
            Text('Pertanyaan Umum (FAQ)', style: AppTextStyles.h2.copyWith(fontSize: 18)),
            const SizedBox(height: 16),
            ...faqs.map((faq) => Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFE5E7EB)),
                  ),
                  child: Theme(
                    data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                    child: ExpansionTile(
                      title: Text(faq['q']!, style: AppTextStyles.bodyBold.copyWith(fontSize: 14)),
                      childrenPadding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                      children: [
                        Text(faq['a']!, style: AppTextStyles.body.copyWith(color: const Color(0xFF6B7280), height: 1.5)),
                      ],
                    ),
                  ),
                )),
          ],
        ),
      ),
    ),
  ],
),
);
}
}
