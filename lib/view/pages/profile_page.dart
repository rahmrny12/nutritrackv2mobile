import 'package:flutter/material.dart';
import 'package:nutritrack/core/api_service.dart';
import 'package:nutritrack/core/local_storage.dart';
import 'package:nutritrack/core/route_generator.dart';
import 'package:nutritrack/data/models/profile_model.dart';
import 'package:nutritrack/data/repository/profile_repository.dart';
import 'package:nutritrack/data/models/screening_result_model.dart';
import 'package:nutritrack/data/repository/screening_repository.dart';
import 'package:nutritrack/view/pages/edit_profile_page.dart';
import 'package:nutritrack/view/pages/screening/screening_selection_page.dart';
import 'package:nutritrack/view/viewmodel/navigation_viewmodel.dart';
import 'package:nutritrack/view/viewmodel/profile_view_model.dart';
import 'package:nutritrack/view/viewmodel/screening_state.dart';
import 'package:nutritrack/view/viewmodel/screening_viewmodel.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key, this.onTabSelected});

  final void Function(int)? onTabSelected;

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final ScrollController _scrollController = ScrollController();
  bool showCollapsedHeader = false;

  Map<String, dynamic>? _user;
  Map<String, dynamic>? _profileLocation;
  late final ProfileViewModel _profileViewModel;
  late final ScreeningViewModel _screeningViewModel;

  ProfileModel? get _profile => _profileViewModel.value.profile;

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
      _profileLocation = data;
    });
  }

  Future<void> _loadScreening() async {
    await _screeningViewModel.fetchAllLatestResults();
  }

  Color _levelColor(String? level) {
    switch (level?.toLowerCase()) {
      case 'risiko rendah':
        return Colors.green;

      case 'risiko sedang':
        return Colors.orange;

      case 'risiko tinggi':
        return Colors.red;

      default:
        return const Color(0xFF111827);
    }
  }

  @override
  void initState() {
    super.initState();
    _profileViewModel = ProfileViewModel(ProfileRepository(ApiService()));
    _profileViewModel.addListener(_onProfileStateChanged);
    _screeningViewModel = ScreeningViewModel(ScreeningRepository(ApiService()));
    _loadUser();
    _loadProfile();
    _profileViewModel.getProfile();
    _loadScreening();
    _scrollController.addListener(() {
      if (_scrollController.offset > 120 && !showCollapsedHeader) {
        setState(() => showCollapsedHeader = true);
      } else if (_scrollController.offset <= 120 && showCollapsedHeader) {
        setState(() => showCollapsedHeader = false);
      }
    });
  }

  void _onProfileStateChanged() {
    if (!mounted) return;
    setState(() {});
  }

  String get userName => _user?['name'] ?? 'Guest';

  double get height => _profile?.tinggiBadan ?? 0;
  double get weight => _profile?.beratBadan ?? 0;
  double get bmi => _profile?.bmi ?? 0;
  String get location => _profileLocation?['location'] ?? 'Unknown';

  @override
  void dispose() {
    _scrollController.dispose();
    _screeningViewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ScreeningState>(
      valueListenable: _screeningViewModel,
      builder: (context, screeningState, _) {
        return Scaffold(
          backgroundColor: const Color(0xFFF2F5F8),
          body: RefreshIndicator(
            onRefresh: _onRefresh,
            child: CustomScrollView(
              controller: _scrollController,
              physics: const BouncingScrollPhysics(),
              slivers: [
                _buildSliverAppBar(),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: [
                        const SizedBox(height: 20),
                        _buildScreeningSummaryCard(screeningState),
                        const SizedBox(height: 16),
                        _buildDailyCaloriesCard(),
                        const SizedBox(height: 16),
                        _buildPremiumCard(context),
                        const SizedBox(height: 20),
                        _buildLogoutButton(),
                        const SizedBox(height: 30),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 240,
      collapsedHeight: 72,
      pinned: true,
      stretch: true,
      elevation: 0,
      automaticallyImplyLeading: false,
      backgroundColor: const Color(0xFF2ABFB0),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(12),
          bottomRight: Radius.circular(12),
        ),
      ),
      title: AnimatedOpacity(
        duration: const Duration(milliseconds: 200),
        opacity: showCollapsedHeader ? 1.0 : 0.0,
        child: Row(
          children: [
            const CircleAvatar(
              radius: 18,
              backgroundColor: Colors.white,
              child: Icon(Icons.person, color: Color(0xFF2ABFB0), size: 20),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Halo, $userName',
                    style: const TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                  const SizedBox(height: 2),
                  const Text(
                    'Profil Saya',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.notifications_none, color: Colors.white),
            ),
          ],
        ),
      ),
      flexibleSpace: FlexibleSpaceBar(
        stretchModes: const [StretchMode.zoomBackground],
        background: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF2ABFB0), Color(0xFF1A9E91)],
            ),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(12),
              bottomRight: Radius.circular(12),
            ),
          ),
          child: SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Container(
                        width: 72,
                        height: 72,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                        child: const Icon(
                          Icons.person,
                          size: 38,
                          color: Color(0xFF2ABFB0),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Selamat pagi,',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 13,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              userName,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              location,
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () async {
                          final updated = await Navigator.push<bool>(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const EditProfilePage(),
                            ),
                          );

                          if (!mounted) return;
                          if (updated == true) {
                            await _loadUser();
                            await _loadProfile();
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.18),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Icon(
                            Icons.edit,
                            color: Colors.white,
                            size: 22,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 22),
                  Row(
                    children: [
                      Expanded(
                        child: _buildProfileMetric(
                          label: 'Tinggi',
                          value: height > 0
                              ? '${height.toStringAsFixed(0)} cm'
                              : '-',
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildProfileMetric(
                          label: 'Berat',
                          value: weight > 0
                              ? '${weight.toStringAsFixed(0)} kg'
                              : '-',
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildProfileMetric(
                          label: 'BMI',
                          value: bmi > 0 ? bmi.toStringAsFixed(1) : '-',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileMetric({required String label, required String value}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.18),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              color: Colors.white70,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip({required IconData icon, required String label}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFB),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: const BoxDecoration(
              color: Color(0xFFE8F8F6),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 18, color: const Color(0xFF2ABFB0)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1F2937),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScreeningSummaryCard(ScreeningState state) {
    final screening = state.latestResult;
    final screeningType = screening?.screeningType;
    final screeningLevel = screening?.level;
    final screeningScore = screening?.totalScore.toString();
    final screeningDate = screening != null
        ? _formatScreeningDate(screening)
        : null;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const ScreeningSelectionPage()),
        );
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Skrining Terakhir',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1A1A2E),
                letterSpacing: -0.2,
              ),
            ),
            const SizedBox(height: 12),
            if (state.status == ScreeningStatus.loading) ...[
              const Center(
                child: SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(strokeWidth: 2.5),
                ),
              ),
            ] else if (state.errorMessage != null) ...[
              Text(
                'Gagal memuat hasil skrining: ${state.errorMessage}',
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFFEF4444),
                  height: 1.4,
                ),
              ),
            ] else if (screening != null) ...[
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: '${_screeningTypeLabel(screeningType)} • ',
                      style: const TextStyle(
                        color: Color(0xFF111827),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    TextSpan(
                      text: screeningLevel ?? '-',
                      style: TextStyle(
                        color: _levelColor(screeningLevel),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                style: const TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: _buildInfoChip(
                      icon: Icons.check_circle_outline,
                      label: 'Skor: ${screeningScore ?? '-'}',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildInfoChip(
                      icon: Icons.calendar_today,
                      label: screeningDate ?? '-',
                    ),
                  ),
                ],
              ),
            ] else ...[
              const Text(
                'Belum ada hasil skrining tersimpan. Lakukan skrining untuk melihat ringkasan di sini.',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF6B7280),
                  height: 1.4,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _screeningTypeLabel(String? type) {
    switch (type) {
      case 'gout':
        return 'Skrining Asam Urat';
      case 'diabetes':
        return 'Skrining Diabetes';
      case 'heart':
        return 'Skrining Jantung';
      default:
        return 'Skrining';
    }
  }

  String _formatScreeningDate(ScreeningResultModel screening) {
    final date = screening.timestamp.toLocal();
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
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
                'Nutrisi Harian',
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
                child: Icon(
                  Icons.restaurant_rounded,
                  color: Theme.of(context).colorScheme.primary,
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
            color: const Color.fromARGB(255, 198, 45, 45),
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
          backgroundColor: Colors.grey[200],
          foregroundColor: Colors.black87,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
      ),
    );
  }

  Future<void> _onRefresh() async {
    await Future.wait([
      _loadUser(),
      _loadProfile(),
      _profileViewModel.getProfile(),
      _loadScreening(),
    ]);
  }
}
