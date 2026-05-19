import 'package:flutter/material.dart';
import 'package:nutritrack/core/local_storage.dart';
import 'package:nutritrack/core/route_generator.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final ScrollController _scrollController = ScrollController();
  bool showCollapsedHeader = false;

  Map<String, dynamic>? _user;
  Map<String, dynamic>? _profile;

  Future<void> _loadUser() async {
    final data = await LocalStorage.getUser();
    if (!mounted) return;

    setState(() {
      _user = data;
    });
  }

  Future<void> _loadProfile() async {
    final data = await LocalStorage.getProfile();
    if (!mounted) return;

    setState(() {
      _profile = data;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadUser();
    _loadProfile();
    _scrollController.addListener(() {
      if (_scrollController.offset > 120 && !showCollapsedHeader) {
        setState(() => showCollapsedHeader = true);
      } else if (_scrollController.offset <= 120 && showCollapsedHeader) {
        setState(() => showCollapsedHeader = false);
      }
    });
  }

  String get userName => _user?['name'] ?? 'Guest';

  double get height => _profile?['tinggi_badan'] ?? 0;
  double get weight => _profile?['berat_badan'] ?? 0;
  double get bmi => _profile?['bmi'] ?? 0;
  String get location => _profile?['location'] ?? 'Unknown';

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F5F8),
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          // ================= APP BAR =================
          SliverAppBar(
            expandedHeight: 60,
            pinned: true,
            elevation: 0,
            backgroundColor: const Color(0xFF1E8076),
            automaticallyImplyLeading: false,
            title: showCollapsedHeader
                ? Row(
                    children: [
                      const CircleAvatar(
                        radius: 16,
                        backgroundColor: Colors.white,
                        child: Icon(
                          Icons.person,
                          size: 16,
                          color: Color(0xFF2DC653),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        userName,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  )
                : null,
            actions: showCollapsedHeader
                ? [
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.logout_rounded, color: Colors.red),
                    ),
                  ]
                : [],
            flexibleSpace: FlexibleSpaceBar(
              collapseMode: CollapseMode.pin,
              background: Container(
                color: const Color(0xFF1E8076),
                alignment: Alignment.center,
                child: const Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: Text(
                    'Profile',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),
          ),

          // ================= CONTENT (avatar lives here, scrolls naturally) =================
          SliverToBoxAdapter(
            child: Column(
              children: [
                // ── Green-to-white transition with avatar overlapping ──
                Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.topCenter,
                  children: [
                    // Green top portion behind avatar
                    Container(height: 60, color: const Color(0xFF1E8076)),

                    // White card body below
                    Padding(
                      padding: const EdgeInsets.only(top: 50),
                      child: Container(
                        width: double.infinity,
                        decoration: const BoxDecoration(
                          color: Color(0xFFF2F5F8),
                        ),
                        padding: const EdgeInsets.only(top: 60),
                        child: const SizedBox(),
                      ),
                    ),

                    // Avatar sits on the seam — scrolls with content naturally
                    if (!showCollapsedHeader)
                      Positioned(
                        top: 10,
                        child: // Avatar (smooth collapse like Instagram)
                        AnimatedPositioned(
                          duration: const Duration(milliseconds: 250),
                          curve: Curves.easeOut,
                          top: showCollapsedHeader ? -30 : 10,
                          child: AnimatedOpacity(
                            duration: const Duration(milliseconds: 200),
                            curve: Curves.easeOut,
                            opacity: showCollapsedHeader ? 0.0 : 1.0,
                            child: AnimatedScale(
                              duration: const Duration(milliseconds: 250),
                              curve: Curves.easeOut,
                              scale: showCollapsedHeader ? 0.7 : 1.0,
                              child: IgnorePointer(
                                ignoring: showCollapsedHeader,
                                child: Container(
                                  width: 100,
                                  height: 100,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black12,
                                        blurRadius: 16,
                                      ),
                                    ],
                                  ),
                                  child: const Icon(
                                    Icons.person,
                                    size: 50,
                                    color: Color(0xFF2DC653),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),

                // ── Profile info + cards ──
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      const SizedBox(height: 24),

                      Text(
                        userName,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                        ),
                      ),

                      const SizedBox(height: 4),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.location_on, size: 14, color: Colors.grey),
                          SizedBox(width: 4),
                          Text(
                            'Jember, Jawa Timur',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),

                      const SizedBox(height: 18),

                      SizedBox(
                        width: 180,
                        height: 44,
                        child: ElevatedButton(
                          onPressed: () {
                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(
                            //     builder: (_) => const EditProfileScreen(),
                            //   ),
                            // );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF1E8C6E),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                            ),
                          ),
                          child: const Text('Edit Profil'),
                        ),
                      ),

                      const SizedBox(height: 20),

                      _buildDailyCaloriesCard(),
                      const SizedBox(height: 16),

                      _buildBodyConditionCard(),
                      const SizedBox(height: 16),

                      _buildPremiumCard(context),
                      const SizedBox(height: 16),

                      _buildLogoutButton(),
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ================= DAILY CALORIES CARD =================
  Widget _buildDailyCaloriesCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Kalori Harian',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1A1A2E),
                  letterSpacing: -0.2,
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFF0FBF4),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.restaurant_rounded,
                  color: Color(0xFF2DC653),
                  size: 20,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildNutrientRow(
            label: 'Kalori',
            value: '1850 kcal',
            progress: 0.75,
            color: const Color(0xFF2DC653),
          ),
          const SizedBox(height: 16),
          _buildNutrientRow(
            label: 'Protein',
            value: '75 g',
            progress: 0.55,
            color: const Color(0xFF4A90D9),
          ),
          const SizedBox(height: 16),
          _buildNutrientRow(
            label: 'Lemak',
            value: '62 g',
            progress: 0.40,
            color: const Color(0xFFFFA500),
          ),
          const SizedBox(height: 16),
          _buildNutrientRow(
            label: 'Karbohidrat',
            value: '230 g',
            progress: 0.80,
            color: const Color(0xFF2DC653),
          ),
        ],
      ),
    );
  }

  Widget _buildNutrientRow({
    required String label,
    required String value,
    required double progress,
    required Color color,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF6B7280),
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF1A1A2E),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 7,
            backgroundColor: const Color(0xFFF0F0F0),
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
      ],
    );
  }

  // ================= BODY CONDITION CARD =================
  Widget _buildBodyConditionCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Kondisi Tubuh',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1A1A2E),
                  letterSpacing: -0.2,
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFF0FBF4),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.monitor_weight_outlined,
                  color: Color(0xFF2DC653),
                  size: 20,
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: _buildBodyStatBox(label: 'TINGGI', value: '${height.toStringAsFixed(0)} cm'),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: _buildBodyStatBox(label: 'BERAT', value: '${weight.toStringAsFixed(0)} kg'),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFB),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'BMI',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey[500],
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.8,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${bmi.toStringAsFixed(1)} - Normal',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1A1A2E),
                      ),
                    ),
                  ],
                ),
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: const Color(0xFF2DC653).withOpacity(0.12),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check_circle_outline_rounded,
                    color: Color(0xFF2DC653),
                    size: 22,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFB),
              borderRadius: BorderRadius.circular(14),
              border: const Border(
                left: BorderSide(color: Color(0xFFFFA500), width: 3.5),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'TARGET',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey[500],
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.8,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      '65 kg',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1A1A2E),
                      ),
                    ),
                  ],
                ),
                const Icon(
                  Icons.flag_outlined,
                  color: Color(0xFFFFA500),
                  size: 22,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBodyStatBox({required String label, required String value}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFB),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey[500],
              fontWeight: FontWeight.w600,
              letterSpacing: 0.8,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1A1A2E),
            ),
          ),
        ],
      ),
    );
  }

  // ================= PREMIUM CARD =================
  Widget _buildPremiumCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A2E),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1A1A2E).withOpacity(0.35),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFA500),
                  borderRadius: BorderRadius.circular(50),
                ),
                child: const Text(
                  'PREMIUM',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              const Icon(
                Icons.stars_rounded,
                color: Color(0xFFFFA500),
                size: 20,
              ),
            ],
          ),
          const SizedBox(height: 14),
          const Text(
            'Go Premium',
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Dapatkan rencana diet personal dan analisis nutrisi mendalam untuk hasil yang lebih cepat.',
            style: TextStyle(
              color: Colors.white.withOpacity(0.70),
              fontSize: 14,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFFA500),
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: const Text(
                'Upgrade Sekarang',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.2,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ================= LOGOUT BUTTON =================
  Widget _buildLogoutButton() {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton.icon(
        onPressed: () async {
          await LocalStorage.clear();

          if (!context.mounted) return;

          Navigator.pushNamedAndRemoveUntil(
            context,
            Routes.auth,
            (route) => false,
          );
        },
        icon: const Icon(Icons.logout_rounded),
        label: const Text(
          'Logout',
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
      ),
    );
  }
}
