import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


class MembershipPage extends StatefulWidget {
  const MembershipPage({super.key});

  @override
  State<MembershipPage> createState() => _MembershipPageState();
}

class _MembershipPageState extends State<MembershipPage> {
  bool _isYearlySelected = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F0),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeroSection(),
            _buildFeaturesSection(),
            _buildPlanSection(),
            _buildCTASection(),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

 Widget _buildHeroSection() {
  return Container(
    width: double.infinity,
    decoration: const BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color(0xFF165F57),
          Color(0xFF1E8076),
          Color(0xFF23A18F),
        ],
      ),
    ),
    child: Stack(
      children: [

        // Back Button
        Positioned(
          top: 40,
          left: 16,
          child: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.arrow_back_ios_new_rounded,
                color: Colors.white,
                size: 18,
              ),
            ),
          ),
        ),
        // Lingkaran kanan atas
        Positioned(
          right: -40,
          top: -20,
          child: Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(0.04),
            ),
          ),
        ),

        // Lingkaran kiri bawah
        Positioned(
          left: -30,
          bottom: 30,
          child: Container(
            width: 140,
            height: 140,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(0.04),
            ),
          ),
        ),

        Padding(
          padding: const EdgeInsets.fromLTRB(20, 60, 20, 36),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Badge
              Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.25),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.star, color: Colors.amber, size: 14),
                      const SizedBox(width: 6),
                      const Text(
                        'KEANGGOTAAN PREMIUM',
                        style: TextStyle(
                          color: Colors.amber,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.5,
                          fontFamily: 'Georgia',
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Logo
              Center(
                child: Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    color: const Color(0xFF4CAF50).withOpacity(0.2),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFF81C784).withOpacity(0.4),
                      width: 2,
                    ),
                  ),
                  child: Image.asset(
                    'assets/images/logo_nutritrack.png',
                    width: 36,
                    height: 36,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              const Center(
                child: Text(
                  'NutriTrack',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 36,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Georgia',
                    letterSpacing: 1,
                  ),
                ),
              ),

              const SizedBox(height: 4),

              Center(
                child: Text(
                  'Premium',
                  style: TextStyle(
                    color: const Color(0xFF81C784).withOpacity(0.9),
                    fontSize: 20,
                    fontFamily: 'Georgia',
                    letterSpacing: 3,
                  ),
                ),
              ),

              const SizedBox(height: 16),

              Text(
                'Kuasai metabolisme Anda dan raih performa puncak dengan alat-alat presisi.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.70),
                  fontSize: 14,
                  height: 1.6,
                  fontFamily: 'Georgia',
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

  Widget _buildFeaturesSection() {
    final features = [
      _FeatureItem(
        icon: Icons.restaurant_menu_rounded,
        iconColor: const Color(0xFF4CAF50),
        iconBg: const Color(0xFFE8F5E9),
        title: 'Rencana Makan yang Dipersonalisasi',
        subtitle:
            'Nutrisi berbasis AI yang disesuaikan dengan tujuan dan preferensi unik Anda.',
      ),
      _FeatureItem(
        icon: Icons.analytics_rounded,
        iconColor: const Color(0xFF1976D2),
        iconBg: const Color(0xFFE3F2FD),
        title: 'Analisis Nutrisi Tingkat Lanjut',
        subtitle:
            'Analisis mendalam tentang makronutrien, hidrasi, riwayat kalori, dan banyak lagi.',
      ),
      _FeatureItem(
        icon: Icons.support_agent_rounded,
        iconColor: const Color(0xFF7B1FA2),
        iconBg: const Color(0xFFF3E5F5),
        title: 'Obrolan Prioritas',
        subtitle:
            'Dapatkan konsultasi dan umpan balik nyata dari AI yang terverifikasi.',
      ),
      _FeatureItem(
        icon: Icons.block_rounded,
        iconColor: const Color(0xFFE64A19),
        iconBg: const Color(0xFFFBE9E7),
        title: 'Tidak Ada Iklan',
        subtitle:
            'Pengalaman yang sepenuhnya fokus dan bebas gangguan di semua perangkat Anda.',
      ),
    ];

    return Container(
      color: const Color(0xFFF5F5F0),
      padding: const EdgeInsets.fromLTRB(20, 32, 20, 16),
      child: Column(
        children: features
            .map((f) => Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: _buildFeatureCard(f),
                ))
            .toList(),
      ),
    );
  }

  Widget _buildFeatureCard(_FeatureItem item) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: item.iconBg,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(item.icon, color: item.iconColor, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1A2E1A),
                    fontFamily: 'Georgia',
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  item.subtitle,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey[600],
                    height: 1.5,
                    fontFamily: 'Georgia',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlanSection() {
    return Container(
      color: const Color(0xFFF5F5F0),
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Pilih Paket Anda',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1A2E1A),
              fontFamily: 'Georgia',
            ),
          ),
          const SizedBox(height: 16),

          // Yearly Plan
          GestureDetector(
            onTap: () => setState(() => _isYearlySelected = true),
            child: _buildPlanCard(
              isSelected: _isYearlySelected,
              label: 'Tahunan',
              sublabel: 'Sasaran tahunan yang fleksibel',
              price: '\Rp. 61.880',
              period: '/bulan',
              badge: 'Hemat 48% dibandingkan dengan harga bulanan',
              badgeColor: const Color(0xFF165F57),
              badgeBg: const Color(0xFFE8F5E9),
              footerNote: 'Ditagih setiap tahun sebesar \Rp. 742.560',
            ),
          ),
          const SizedBox(height: 12),

          // Monthly Plan
          GestureDetector(
            onTap: () => setState(() => _isYearlySelected = false),
            child: _buildPlanCard(
              isSelected: !_isYearlySelected,
              label: 'Bulanan',
              sublabel: 'Akses bulanan yang fleksibel',
              price: '\Rp. 119.000',
              period: '/bulan',
              badge: null,
              badgeColor: null,
              badgeBg: null,
              footerNote: '',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlanCard({
    required bool isSelected,
    required String label,
    required String sublabel,
    required String price,
    required String period,
    String? badge,
    Color? badgeColor,
    Color? badgeBg,
    required String footerNote,
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFF05423C) : Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isSelected
              ? const Color(0xFF1E8076)
              : Colors.grey.withOpacity(0.2),
          width: isSelected ? 2 : 1,
        ),
        boxShadow: isSelected
            ? [
                BoxShadow(
                  color: const Color(0xFF05423C).withOpacity(0.25),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                )
              ]
            : [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                )
              ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  // Radio
                  Container(
                    width: 22,
                    height: 22,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isSelected
                            ? const Color(0xFF23A18F)
                            : Colors.grey[400]!,
                        width: 2,
                      ),
                    ),
                    child: isSelected
                        ? Center(
                            child: Container(
                              width: 10,
                              height: 10,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color(0xFF23A18F),
                              ),
                            ),
                          )
                        : null,
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        label,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: isSelected ? Colors.white : const Color(0xFF1A2E1A),
                          fontFamily: 'Georgia',
                        ),
                      ),
                      Text(
                        sublabel,
                        style: TextStyle(
                          fontSize: 12,
                          color: isSelected
                              ? Colors.white.withOpacity(0.55)
                              : Colors.grey[500],
                          fontFamily: 'Georgia',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              // Price
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    price,
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w800,
                      color: isSelected
                          ? const Color(0xFF81C784)
                          : const Color(0xFF1A2E1A),
                      fontFamily: 'Georgia',
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 3),
                    child: Text(
                      period,
                      style: TextStyle(
                        fontSize: 13,
                        color: isSelected
                            ? Colors.white.withOpacity(0.6)
                            : Colors.grey[500],
                        fontFamily: 'Georgia',
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          if (badge != null) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color(0xFF4CAF50).withOpacity(0.2)
                    : badgeBg,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                badge,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: isSelected ? const Color(0xFF81C784) : badgeColor,
                  fontFamily: 'Georgia',
                ),
              ),
            ),
          ],
          const SizedBox(height: 10),
          Text(
            footerNote,
            style: TextStyle(
              fontSize: 11,
              color: isSelected
                  ? Colors.white.withOpacity(0.45)
                  : Colors.grey[400],
              fontFamily: 'Georgia',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCTASection() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 28, 20, 0),
      child: Column(
        children: [
          // Main CTA Button
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF1E8C6E),
                foregroundColor: Colors.white,
                elevation: 4,
                shadowColor: const Color(0xFF2E7D32).withOpacity(0.4),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.rocket_launch_rounded, size: 20),
                  SizedBox(width: 8),
                  Text(
                    'Mulai Uji Coba Gratis',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Georgia',
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Fine print
          Text(
            'Tidak ada biaya hingga masa percobaan berakhir. Batalkan kapan saja.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[500],
              fontFamily: 'Georgia',
            ),
          ),

          const SizedBox(height: 20),

          // Terms
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 4,
            children: [
              TextButton(
                onPressed: () {},
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(
                  'Ketentuan Layanan',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[500],
                    decoration: TextDecoration.underline,
                    fontFamily: 'Georgia',
                  ),
                ),
              ),
              Text('·',
                  style: TextStyle(fontSize: 12, color: Colors.grey[400])),
              TextButton(
                onPressed: () {},
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(
                  'Kebijakan Privasi',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[500],
                    decoration: TextDecoration.underline,
                    fontFamily: 'Georgia',
                  ),
                ),
              ),
              Text('·',
                  style: TextStyle(fontSize: 12, color: Colors.grey[400])),
              TextButton(
                onPressed: () {},
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(
                  'Kembalikan Pembelian',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[500],
                    decoration: TextDecoration.underline,
                    fontFamily: 'Georgia',
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _FeatureItem {
  final IconData icon;
  final Color iconColor;
  final Color iconBg;
  final String title;
  final String subtitle;

  _FeatureItem({
    required this.icon,
    required this.iconColor,
    required this.iconBg,
    required this.title,
    required this.subtitle,
  });
}