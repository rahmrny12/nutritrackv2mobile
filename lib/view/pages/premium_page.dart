import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


class PremiumScreen extends StatefulWidget {
  const PremiumScreen({super.key});

  @override
  State<PremiumScreen> createState() => _PremiumScreenState();
}

class _PremiumScreenState extends State<PremiumScreen> {
  int _selectedPlan = 0; // 0 = Annual, 1 = Monthly
  int _selectedNav = 2;  // 2 = Premium tab

  static const Color kGreen = Color(0xFF1E8C6E);
  static const Color kGreenLight = Color(0xFFE8F5F1);
  static const Color kOrange = Color(0xFFFF9500);
  static const Color kBg = Color(0xFFF2F4F7);
  static const Color kCard = Colors.white;
  static const Color kText = Color(0xFF1A1A2E);
  static const Color kSubText = Color(0xFF8A8FA3);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBg,
      appBar: _buildAppBar(),
      body: _buildBody(),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: kBg,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      leading: Padding(
        padding: const EdgeInsets.only(left: 16),
        child: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: kGreen,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Image.asset(
              'assets/images/logo_nutritrack.png',
              width: 20,
              height: 20,
              fit: BoxFit.contain,
            ),
            ),
            const SizedBox(width: 8),
            const Text(
              'NutriTrack',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: kText,
              ),
            ),
          ],
        ),
      ),
      leadingWidth: 160,
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16),
          child: IconButton(
            onPressed: () {},
            icon: const Icon(Icons.settings_outlined, color: kSubText),
          ),
        ),
      ],
    );
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          const SizedBox(height: 8),
          _buildHeroCard(),
          const SizedBox(height: 12),
          _buildFullWidthFeature(),
          const SizedBox(height: 12),
          _buildTwoColumnFeatures(),
          const SizedBox(height: 12),
          _buildNoAdsFeature(),
          const SizedBox(height: 16),
          _buildPricingPlans(),
          const SizedBox(height: 20),
          _buildCTAButton(),
          const SizedBox(height: 8),
          const Text(
            'Paket diperpanjang otomatis. Batalkan melalui Google Play.',
            style: TextStyle(fontSize: 12, color: kSubText),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildHeroCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      decoration: BoxDecoration(
        color: kCard,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Icon
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: kGreen,
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Icon(Icons.star_rounded, color: Colors.white, size: 36),
          ),
          const SizedBox(height: 20),
          // Title
          const Text(
            'Buka Potensi Penuh Anda',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w800,
              color: kText,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 10),
          // Subtitle
          const Text(
            'Kuasai kesehatan Anda dengan alat-alat presisi dan panduan ahli.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: kSubText,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 20),
          // Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF0DC),
              borderRadius: BorderRadius.circular(50),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(Icons.workspace_premium_outlined,
                    size: 16, color: Color(0xFFB76E00)),
                SizedBox(width: 6),
                Text(
                  'NutriTrack Premium',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFFB76E00),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFullWidthFeature() {
    return _featureCard(
      icon: Icons.restaurant_menu_outlined,
      iconBg: const Color(0xFFE8F5F1),
      iconColor: kGreen,
      title: 'Rencana Nutrisi yang Dipersonalisasi',
      subtitle: 'Disesuaikan dengan tujuan Anda.',
      isFullWidth: true,
    );
  }

  Widget _buildTwoColumnFeatures() {
    return Row(
      children: [
        Expanded(
          child: _featureCard(
            icon: Icons.bar_chart_rounded,
            iconBg: const Color(0xFFECEEFF),
            iconColor: const Color(0xFF5B69FF),
            title: 'Analisis Wawasan Mendalam',
            isFullWidth: false,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _featureCard(
            icon: Icons.chat_bubble_outline_rounded,
            iconBg: const Color(0xFFF3EEFF),
            iconColor: const Color(0xFF8B5CF6),
            title: 'Obrolan Pelatih Prioritas',
            isFullWidth: false,
          ),
        ),
      ],
    );
  }

  Widget _buildNoAdsFeature() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: kCard,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: const Color(0xFFFFEEE8),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.block_rounded,
                color: Color(0xFFFF4B26), size: 22),
          ),
          const SizedBox(width: 14),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                'Tidak Ada Iklan',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: kText,
                ),
              ),
              SizedBox(height: 2),
              Text(
                'Fokus pada kesehatan tanpa gangguan.',
                style: TextStyle(fontSize: 13, color: kSubText),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _featureCard({
    required IconData icon,
    required Color iconBg,
    required Color iconColor,
    required String title,
    String? subtitle,
    required bool isFullWidth,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: kCard,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: isFullWidth
          ? Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: iconBg,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: iconColor, size: 22),
                ),
                const SizedBox(width: 14),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: kText,
                      ),
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style:
                            const TextStyle(fontSize: 13, color: kSubText),
                      ),
                    ],
                  ],
                ),
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: iconBg,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: iconColor, size: 20),
                ),
                const SizedBox(height: 10),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: kText,
                    height: 1.3,
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildPricingPlans() {
    return Column(
      children: [
        _buildPlanCard(
          index: 0,
          title: 'Paket Tahunan',
          subtitle: 'Ditagih setiap tahun (\Rp599.000/tahun)',
          price: '\Rp.49.916,67',
          period: '/bulan',
          isBestValue: true,
        ),
        const SizedBox(height: 12),
        _buildPlanCard(
          index: 1,
          title: 'Bulanan',
          subtitle: 'Tidak ada komitmen',
          price: '\Rp.119.000',
          period: '/bulan',
          isBestValue: false,
        ),
      ],
    );
  }

  Widget _buildPlanCard({
    required int index,
    required String title,
    required String subtitle,
    required String price,
    required String period,
    required bool isBestValue,
  }) {
    final bool isSelected = _selectedPlan == index;

    return GestureDetector(
      onTap: () => setState(() => _selectedPlan = index),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            decoration: BoxDecoration(
              color: kCard,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isSelected ? kGreen : Colors.transparent,
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: isSelected
                      ? kGreen.withOpacity(0.12)
                      : Colors.black.withOpacity(0.04),
                  blurRadius: isSelected ? 16 : 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: kText,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style:
                          const TextStyle(fontSize: 13, color: kSubText),
                    ),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      price,
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        color: isSelected ? kGreen : kText,
                      ),
                    ),
                    Text(
                      period,
                      style: TextStyle(
                        fontSize: 14,
                        color: isSelected ? kGreen : kSubText,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (isBestValue)
            Positioned(
              top: -12,
              right: 20,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                decoration: BoxDecoration(
                  color: kOrange,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'BEST VALUE',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildCTAButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: kGreen,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text(
              'Jadi Premium',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(width: 8),
            Icon(Icons.arrow_forward_rounded, size: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNav() {
    final items = [
      {'icon': Icons.calendar_today_outlined, 'label': 'Today'},
      {'icon': Icons.add_circle_outline_rounded, 'label': 'Log'},
      {'icon': Icons.star_rounded, 'label': 'Premium'},
      {'icon': Icons.person_outline_rounded, 'label': 'Profile'},
    ];

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: SizedBox(
          height: 64,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(items.length, (index) {
              final isActive = _selectedNav == index;
              return GestureDetector(
                onTap: () => setState(() => _selectedNav = index),
                behavior: HitTestBehavior.opaque,
                child: SizedBox(
                  width: 72,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        items[index]['icon'] as IconData,
                        size: 22,
                        color: isActive ? kGreen : const Color(0xFFB0B5C4),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        items[index]['label'] as String,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: isActive
                              ? FontWeight.w700
                              : FontWeight.w400,
                          color:
                              isActive ? kGreen : const Color(0xFFB0B5C4),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}