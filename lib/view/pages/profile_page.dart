import 'package:flutter/material.dart';
import 'package:nutritrack/core/api_service.dart';
import 'package:nutritrack/core/local_storage.dart';
import 'package:nutritrack/core/route_generator.dart';
import 'package:nutritrack/data/models/profile_model.dart';
import 'package:nutritrack/data/models/screening_result_model.dart';
import 'package:nutritrack/data/repository/profile_repository.dart';
import 'package:nutritrack/data/repository/screening_repository.dart';
import 'package:nutritrack/view/pages/edit_profile_page.dart';
import 'package:nutritrack/view/pages/screening/screening_selection_page.dart';
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

  Future<void> _loadScreening() async {
    await _screeningViewModel.fetchAllLatestResults();
  }

  @override
  void initState() {
    super.initState();

    _profileViewModel = ProfileViewModel(ProfileRepository(ApiService()));

    _screeningViewModel = ScreeningViewModel(ScreeningRepository(ApiService()));

    _profileViewModel.addListener(_onProfileStateChanged);

    _initialize();

    _scrollController.addListener(() {
      if (_scrollController.offset > 120 && !showCollapsedHeader) {
        setState(() => showCollapsedHeader = true);
      } else if (_scrollController.offset <= 120 && showCollapsedHeader) {
        setState(() => showCollapsedHeader = false);
      }
    });
  }

  Future<void> _initialize() async {
    await Future.wait([
      _loadUser(),
      _profileViewModel.getProfile(),
      _loadScreening(),
    ]);
  }

  void _onProfileStateChanged() {
    if (!mounted) return;

    setState(() {});
  }

  @override
  void dispose() {
    _scrollController.dispose();

    super.dispose();
  }

  // ================= GETTERS =================

  String get userName => _user?['name'] ?? 'Guest';

  double get height => _profile?.height ?? 0;

  double get weight => _profile?.weight ?? 0;

  double get bmi => _profile?.bmi ?? 0;

  double get bmr => _profile?.bmr ?? 0;

  double get tdee => _profile?.tdee ?? 0;

  double get targetCalories => _profile?.targetCalories ?? 0;

  double get proteinTarget => _profile?.proteinTarget ?? 0;

  double get fatTarget => _profile?.fatTarget ?? 0;

  double get carbohydrateTarget => _profile?.carbohydrateTarget ?? 0;

  int get age => _profile?.age ?? 0;

  String get gender {
    if (_profile?.gender == 'L') {
      return 'Laki-laki';
    }

    return 'Perempuan';
  }

  String get activityLevel {
    switch (_profile?.activityLevel) {
      case 'sedentary':
        return 'Sangat Jarang Aktivitas';

      case 'light':
        return 'Aktivitas Ringan';

      case 'moderate':
        return 'Aktivitas Sedang';

      case 'active':
        return 'Aktivitas Aktif';

      case 'very_active':
        return 'Sangat Aktif';

      default:
        return '-';
    }
  }

  // ================= HELPERS =================

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

  // ================= UI =================

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

                        _buildProfileInfoCard(),

                        const SizedBox(height: 16),

                        _buildScreeningSummaryCard(screeningState),

                        const SizedBox(height: 16),

                        _buildNutritionTargetCard(),

                        const SizedBox(height: 16),

                        _buildPremiumCard(),

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

  // ================= APP BAR =================

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
          ],
        ),
      ),
      flexibleSpace: FlexibleSpaceBar(
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
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
              child: Column(
                children: [
                  const SizedBox(height: 8),

                  Row(
                    children: [
                      Container(
                        width: 72,
                        height: 72,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
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
                              'Selamat datang,',
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
                            await _onRefresh();
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

  // ================= PROFILE INFO =================

  Widget _buildProfileInfoCard() {
    return Container(
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
            'Informasi Profil',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1A1A2E),
            ),
          ),

          const SizedBox(height: 18),

          Row(
            children: [
              Expanded(
                child: _buildInfoChip(
                  icon: Icons.cake_outlined,
                  label: 'Usia: $age Tahun',
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: _buildInfoChip(
                  icon: Icons.person_outline,
                  label: gender,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          Row(
            children: [
              Expanded(
                child: _buildInfoChip(
                  icon: Icons.local_fire_department_outlined,
                  label: 'BMR: ${bmr.toStringAsFixed(0)} kcal',
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: _buildInfoChip(
                  icon: Icons.directions_run,
                  label: activityLevel,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          _buildInfoChip(
            icon: Icons.bolt_outlined,
            label: 'TDEE: ${tdee.toStringAsFixed(0)} kcal',
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

  // ================= SCREENING =================

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
              ),
            ),

            const SizedBox(height: 12),

            if (state.status == ScreeningStatus.loading) ...[
              const Center(child: CircularProgressIndicator()),
            ] else if (state.errorMessage != null) ...[
              Text(
                state.errorMessage!,
                style: const TextStyle(color: Colors.red),
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
              ),

              const SizedBox(height: 10),

              Row(
                children: [
                  Expanded(
                    child: _buildInfoChip(
                      icon: Icons.score_outlined,
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
              const Text('Belum ada hasil skrining.'),
            ],
          ],
        ),
      ),
    );
  }

  // ================= NUTRITION =================

  Widget _buildNutritionTargetCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F8F6),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.restaurant_menu_rounded,
                  color: Color(0xFF2ABFB0),
                ),
              ),

              const SizedBox(width: 12),

              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Target Nutrisi Harian',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1A1A2E),
                      ),
                    ),

                    SizedBox(height: 2),

                    Text(
                      'Kebutuhan harian berdasarkan profil tubuh',
                      style: TextStyle(fontSize: 12, color: Color(0xFF6B7280)),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 22),

          // ================= KALORI =================
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF2ABFB0), Color(0xFF1FA89A)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Row(
              children: [
                Container(
                  width: 54,
                  height: 54,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.18),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.local_fire_department_rounded,
                    color: Colors.white,
                    size: 28,
                  ),
                ),

                const SizedBox(width: 16),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Kalori Harian',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),

                      const SizedBox(height: 6),

                      Text(
                        '${targetCalories.toStringAsFixed(0)} kcal',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 26,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 14),

          Row(
            children: [
              Expanded(
                child: _buildMacroCard(
                  title: 'Protein',
                  value: '${proteinTarget.toStringAsFixed(1)} g',
                  icon: Icons.fitness_center_rounded,
                  bgColor: const Color(0xFFEAF2FF),
                  iconColor: const Color(0xFF3B82F6),
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: _buildMacroCard(
                  title: 'Lemak',
                  value: '${fatTarget.toStringAsFixed(1)} g',
                  icon: Icons.opacity_rounded,
                  bgColor: const Color(0xFFFFF4E8),
                  iconColor: const Color(0xFFF59E0B),
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: _buildMacroCard(
                  title: 'Karbo',
                  value: '${carbohydrateTarget.toStringAsFixed(1)} g',
                  icon: Icons.rice_bowl_rounded,
                  bgColor: const Color(0xFFECFDF3),
                  iconColor: const Color(0xFF22C55E),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMacroCard({
    required String title,
    required String value,
    required IconData icon,
    required Color bgColor,
    required Color iconColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.9),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: 22),
          ),

          const SizedBox(height: 12),

          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Color(0xFF6B7280),
            ),
          ),

          const SizedBox(height: 6),

          Text(
            value,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w800,
              color: Color(0xFF111827),
            ),
          ),
        ],
      ),
    );
  }

  // ================= PREMIUM =================

  Widget _buildPremiumCard() {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A2E),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Go Premium',
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w700,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            'Dapatkan analisis nutrisi mendalam dan rekomendasi diet personal.',
            style: TextStyle(color: Colors.white.withOpacity(0.7)),
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
              ),
              child: const Text('Upgrade Sekarang'),
            ),
          ),
        ],
      ),
    );
  }

  // ================= LOGOUT =================

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

  // ================= REFRESH =================

  Future<void> _onRefresh() async {
    await Future.wait([
      _loadUser(),
      _profileViewModel.getProfile(),
      _loadScreening(),
    ]);
  }
}
