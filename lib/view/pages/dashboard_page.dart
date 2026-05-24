import 'package:flutter/material.dart';
import 'package:nutritrack/core/local_storage.dart';
import 'package:nutritrack/core/route_generator.dart';
import 'package:nutritrack/view/viewmodel/navigation_state.dart';
import 'package:nutritrack/view/viewmodel/navigation_viewmodel.dart';
import 'package:nutritrack/view/viewmodel/theme_viewmodel.dart';
import 'widgets/bottom_nav.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage>
    with TickerProviderStateMixin {
  int _selectedDay = 5;
  late TabController _tabController;
  late NavigationViewModel _navigationViewModel;
  late ThemeViewModel _themeViewModel;
  late VoidCallback _themeListener;

  Map<String, dynamic>? _profile;
  Map<String, dynamic>? _user;

  Future<void> _loadUser() async {
    final data = await LocalStorage.getUser();
    if (!mounted) return;

    setState(() {
      _user = data;
    });
  }

  static const double _expandedHeight = 420.0;
  static const double _collapsedHeight = 70.0;

  final ScrollController _scrollController = ScrollController();
  bool _isCollapsed = false;

  final List<Map<String, dynamic>> _days = [
    {'label': 'Sun', 'date': 4},
    {'label': 'Mon', 'date': 5},
    {'label': 'Tue', 'date': 6},
    {'label': 'Wed', 'date': 7},
    {'label': 'Thu', 'date': 8},
    {'label': 'Fri', 'date': 9},
    {'label': 'Sat', 'date': 10},
  ];

  final List<String> _moodEmojis = ['😊', '😐', '😊', '😄', '😊', '😊', '😄'];

  final List<Map<String, dynamic>> _articles = [
    {
      'tag': 'Nutrisi',
      'tagColor': Color(0xFF2ABFB0),
      'title': 'Makanan Tinggi Protein untuk Pemula',
      'subtitle':
          'Temukan sumber protein terbaik untuk mendukung aktivitasmu sehari-hari.',
      'duration': '5 menit baca',
      'emoji': '🥩',
      'bgColor': Color(0xFFE8F8F7),
    },
    {
      'tag': 'Mental',
      'tagColor': Color(0xFF7C6FCD),
      'title': 'Cara Efektif Mengelola Stres Harian',
      'subtitle':
          'Tips sederhana yang terbukti membantu menjaga keseimbangan emosi.',
      'duration': '4 menit baca',
      'emoji': '🧘',
      'bgColor': Color(0xFFF0EEFF),
    },
    {
      'tag': 'Olahraga',
      'tagColor': Color(0xFFE07B39),
      'title': '10 Gerakan Peregangan Pagi Hari',
      'subtitle':
          'Mulai hari dengan tubuh segar dan otot yang siap beraktivitas.',
      'duration': '3 menit baca',
      'emoji': '🏃',
      'bgColor': Color(0xFFFFF3EC),
    },
    {
      'tag': 'Tidur',
      'tagColor': Color(0xFF3B82F6),
      'title': 'Pola Tidur Ideal untuk Kesehatan Optimal',
      'subtitle': 'Pelajari berapa jam tidur yang kamu butuhkan sesuai usiamu.',
      'duration': '6 menit baca',
      'emoji': '😴',
      'bgColor': Color(0xFFEEF4FF),
    },
  ];

  @override
  void initState() {
    super.initState();
    _navigationViewModel = NavigationViewModel();
    _themeViewModel = ThemeViewModel();
    _themeListener = () => setState(() {});
    _themeViewModel.addListener(_themeListener);
    _tabController = TabController(length: 3, vsync: this);

    _loadProfile();
    _loadUser();

    _scrollController.addListener(() {
      final collapsed =
          _scrollController.hasClients &&
          _scrollController.offset > (_expandedHeight - _collapsedHeight - 60);
      if (collapsed != _isCollapsed) {
        setState(() => _isCollapsed = collapsed);
      }
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
  void dispose() {
    _scrollController.dispose();
    _navigationViewModel.dispose();
    _themeViewModel.removeListener(_themeListener);
    _tabController.dispose();
    super.dispose();
  }

  String get _userName {
    return _user?['name'] ?? 'Guest';
  }

  double get _userHeight {
    return _profile?['tinggi_badan'] ?? 0;
  }

  double get _userWeight {
    return _profile?['berat_badan'] ?? 0;
  }

  double get _userBMI {
    return _profile?['bmi'] ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    final theme = _themeViewModel.currentTheme;
    final colors = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Column(
        children: [
          Expanded(
            child: CustomScrollView(
              controller: _scrollController,
              physics: const BouncingScrollPhysics(),
              slivers: [
                _buildSliverAppBar(context, colors, textTheme),
                SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 12),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: GestureDetector(
                          onTap: () {
                            // Navigator.pushNamed(
                            //   context,
                            //   Routes.aiRecipeRecommendation,
                            // );
                          },
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 14,
                            ),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [colors.primary, colors.secondary],
                              ),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: colors.onPrimary.withOpacity(0.18),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Icon(
                                    Icons.auto_awesome,
                                    color: colors.onPrimary,
                                  ),
                                ),

                                const SizedBox(width: 12),

                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Generate Resep AI',
                                        style: textTheme.labelLarge?.copyWith(
                                          color: colors.onPrimary,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        'Rekomendasi resep rendah purin untuk penderita asam urat',
                                        style: textTheme.bodyMedium?.copyWith(
                                          color: colors.onPrimary.withOpacity(
                                            0.8,
                                          ),
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                Icon(
                                  Icons.arrow_forward_ios,
                                  size: 16,
                                  color: colors.onPrimary,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      _buildMoodWeek(textTheme),
                      const SizedBox(height: 20),
                      _buildRingkasanCepat(textTheme),
                      const SizedBox(height: 24),
                      _buildArtikelSection(),
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

  // ─────────────────────────────────────────
  // SLIVER APP BAR
  // ─────────────────────────────────────────
  Widget _buildSliverAppBar(
    BuildContext context,
    ColorScheme colors,
    TextTheme textTheme,
  ) {
    return SliverAppBar(
      expandedHeight: _expandedHeight,
      collapsedHeight: _collapsedHeight,
      pinned: true,
      stretch: true,
      backgroundColor: colors.primary,
      elevation: _isCollapsed ? 4 : 0,
      automaticallyImplyLeading: false,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
      ),
      title: AnimatedOpacity(
        opacity: _isCollapsed ? 1.0 : 0.0,
        duration: const Duration(milliseconds: 200),
        child: Row(
          children: [
            const CircleAvatar(
              radius: 18,
              backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=47'),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Selamat pagi,',
                    style: TextStyle(
                      fontSize: 11,
                      color: _themeViewModel.currentTheme.colorScheme.onPrimary
                          .withOpacity(0.7),
                    ),
                  ),
                  Text(
                    _userName,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: _themeViewModel.currentTheme.colorScheme.onPrimary,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: _themeViewModel.currentTheme.colorScheme.onPrimary
                    .withOpacity(0.25),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '850 kcal tersisa',
                style: TextStyle(
                  fontSize: 12,
                  color: _themeViewModel.currentTheme.colorScheme.onPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(width: 8),
            _notificationButton(),
          ],
        ),
      ),
      flexibleSpace: FlexibleSpaceBar(
        stretchModes: const [StretchMode.zoomBackground],
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [colors.primary, colors.primary],
            ),
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(32),
              bottomRight: Radius.circular(32),
            ),
          ),
          child: SafeArea(
            bottom: false,
            child: AnimatedOpacity(
              opacity: _isCollapsed ? 0.0 : 1.0,
              duration: const Duration(milliseconds: 200),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const CircleAvatar(
                          radius: 22,
                          backgroundImage: NetworkImage(
                            'https://i.pravatar.cc/150?img=47',
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Selamat pagi,',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: _themeViewModel
                                      .currentTheme
                                      .colorScheme
                                      .onPrimary
                                      .withOpacity(0.7),
                                ),
                              ),
                              Text(
                                _userName,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: _themeViewModel
                                      .currentTheme
                                      .colorScheme
                                      .onPrimary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        _notificationButton(),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: List.generate(_days.length, (index) {
                        final isSelected = index == _selectedDay;
                        return GestureDetector(
                          onTap: () => setState(() => _selectedDay = index),
                          child: Column(
                            children: [
                              Text(
                                _days[index]['label'],
                                style: TextStyle(
                                  fontSize: 11,
                                  color: isSelected
                                      ? _themeViewModel
                                            .currentTheme
                                            .colorScheme
                                            .onPrimary
                                      : _themeViewModel
                                            .currentTheme
                                            .colorScheme
                                            .onPrimary
                                            .withOpacity(0.6),
                                  fontWeight: isSelected
                                      ? FontWeight.w600
                                      : FontWeight.normal,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Container(
                                width: 32,
                                height: 32,
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? _themeViewModel
                                            .currentTheme
                                            .colorScheme
                                            .onPrimary
                                      : Colors.transparent,
                                  shape: BoxShape.circle,
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  '${_days[index]['date']}',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: isSelected
                                        ? _themeViewModel
                                              .currentTheme
                                              .colorScheme
                                              .primary
                                        : _themeViewModel
                                              .currentTheme
                                              .colorScheme
                                              .onPrimary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: _themeViewModel
                            .currentTheme
                            .colorScheme
                            .onPrimary
                            .withOpacity(0.15),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: _themeViewModel
                              .currentTheme
                              .colorScheme
                              .onPrimary
                              .withOpacity(0.24),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Target Kalori',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: _themeViewModel
                                      .currentTheme
                                      .colorScheme
                                      .onPrimary,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: _themeViewModel
                                      .currentTheme
                                      .colorScheme
                                      .onPrimary
                                      .withOpacity(0.25),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  'Target Harian',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: _themeViewModel
                                        .currentTheme
                                        .colorScheme
                                        .onPrimary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Pantau target 2000 kcal dan sisa\nkebutuhan makan Anda untuk hari ini.',
                            style: textTheme.bodyMedium?.copyWith(
                              color: colors.onPrimary.withOpacity(0.7),
                              fontSize: 12,
                              height: 1.4,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Sisa kalori',
                            style: textTheme.bodyMedium?.copyWith(
                              color: colors.onPrimary.withOpacity(0.7),
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '850 kcal',
                            style: textTheme.headlineSmall?.copyWith(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: colors.onPrimary,
                            ),
                          ),
                          const SizedBox(height: 10),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: LinearProgressIndicator(
                              value: 850 / 2000,
                              backgroundColor: colors.onPrimary.withOpacity(
                                0.3,
                              ),
                              valueColor: AlwaysStoppedAnimation<Color>(
                                colors.onPrimary,
                              ),
                              minHeight: 6,
                            ),
                          ),
                          const SizedBox(height: 14),
                          GestureDetector(
                            onTap: () => Navigator.pushNamed(
                              context,
                              Routes.initialLogFood,
                            ),
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                color: colors.surface,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                'Catat Makanan',
                                style: textTheme.labelLarge?.copyWith(
                                  color: colors.primary,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _notificationButton() {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: _themeViewModel.currentTheme.colorScheme.onPrimary
                .withOpacity(0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            Icons.notifications_none,
            color: _themeViewModel.currentTheme.colorScheme.onPrimary,
            size: 22,
          ),
        ),
        Positioned(
          top: 5,
          right: 5,
          child: Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: _themeViewModel.currentTheme.colorScheme.error,
              shape: BoxShape.circle,
              border: Border.all(
                color: _themeViewModel.currentTheme.colorScheme.onPrimary,
                width: 1,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ─────────────────────────────────────────
  // MOOD WEEK
  // ─────────────────────────────────────────
  Widget _buildMoodWeek(TextTheme textTheme) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _themeViewModel.currentTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: _themeViewModel.currentTheme.shadowColor.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  'Bagaimana Perasaanmu Minggu Ini?',
                  style: _themeViewModel.currentTheme.textTheme.bodyLarge
                      ?.copyWith(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color:
                            _themeViewModel.currentTheme.colorScheme.onSurface,
                      ),
                ),
              ),
              GestureDetector(
                onTap: () => Navigator.pushNamed(context, Routes.mood),
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color:
                        _themeViewModel.currentTheme.colorScheme.surfaceVariant,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.chevron_right,
                    size: 18,
                    color: _themeViewModel.currentTheme.colorScheme.onSurface
                        .withOpacity(0.65),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(_days.length, (index) {
              final isSelected = index == _selectedDay;
              return GestureDetector(
                onTap: () => setState(() => _selectedDay = index),
                child: Column(
                  children: [
                    Text(
                      _days[index]['label'],
                      style: textTheme.bodyMedium?.copyWith(
                        fontSize: 10,
                        color: isSelected
                            ? _themeViewModel.currentTheme.colorScheme.primary
                            : _themeViewModel.currentTheme.colorScheme.onSurface
                                  .withOpacity(0.6),
                        fontWeight: isSelected
                            ? FontWeight.w600
                            : FontWeight.normal,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? _themeViewModel.currentTheme.colorScheme.primary
                                  .withOpacity(0.15)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        _moodEmojis[index],
                        style: const TextStyle(fontSize: 22),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────
  // RINGKASAN CEPAT
  // ─────────────────────────────────────────
  Widget _buildRingkasanCepat(TextTheme textTheme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: _themeViewModel.currentTheme.colorScheme.surface,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: _themeViewModel.currentTheme.shadowColor.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Ringkasan hari ini',
                  style: textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: _themeViewModel.currentTheme.colorScheme.onSurface,
                    fontSize: 15,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, Routes.history);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: _themeViewModel
                          .currentTheme
                          .colorScheme
                          .surfaceVariant,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.chevron_right,
                      size: 18,
                      color: _themeViewModel.currentTheme.colorScheme.onSurface
                          .withOpacity(0.65),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Mood',
                        style: _themeViewModel.currentTheme.textTheme.bodyMedium
                            ?.copyWith(
                              fontSize: 12,
                              color: _themeViewModel
                                  .currentTheme
                                  .colorScheme
                                  .onSurface
                                  .withOpacity(0.7),
                            ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Baik',
                        style: _themeViewModel.currentTheme.textTheme.bodyLarge
                            ?.copyWith(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: _themeViewModel
                                  .currentTheme
                                  .colorScheme
                                  .onSurface,
                            ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Sisa Target Kalori',
                        style: _themeViewModel.currentTheme.textTheme.bodyMedium
                            ?.copyWith(
                              fontSize: 12,
                              color: _themeViewModel
                                  .currentTheme
                                  .colorScheme
                                  .onSurface
                                  .withOpacity(0.7),
                            ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '850',
                        style: _themeViewModel.currentTheme.textTheme.bodyLarge
                            ?.copyWith(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: _themeViewModel
                                  .currentTheme
                                  .colorScheme
                                  .onSurface,
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () {
                _showScreeningSelectionDialog(context);
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                decoration: BoxDecoration(
                  color:
                      _themeViewModel.currentTheme.colorScheme.surfaceVariant,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: _themeViewModel.currentTheme.colorScheme.onSurface
                        .withOpacity(0.08),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.health_and_safety_outlined,
                      color: _themeViewModel.currentTheme.colorScheme.secondary,
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Mulai Skrining',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: _themeViewModel
                                  .currentTheme
                                  .colorScheme
                                  .onSurface,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Cek kondisi kesehatan dan rekomendasi nutrisi',
                            style: TextStyle(
                              fontSize: 12,
                              color: _themeViewModel
                                  .currentTheme
                                  .colorScheme
                                  .onSurface
                                  .withOpacity(0.65),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                      color: _themeViewModel.currentTheme.colorScheme.onSurface
                          .withOpacity(0.65),
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

  void _showScreeningSelectionDialog(BuildContext context) {
    final theme = _themeViewModel.currentTheme;
    final colors = theme.colorScheme;
    final options = [
      {
        'title': 'Skrining Asam Urat',
        'subtitle': 'Deteksi kondisi asam urat dan rekomendasi pola makan',
        'icon': Icons.health_and_safety_outlined,
        'route': Routes.gout_screening,
      },
      {
        'title': 'Skrining Diabetes',
        'subtitle': 'Cek risiko diabetes dan kebiasaan gula darah',
        'icon': Icons.monitor_heart_outlined,
        'route': Routes.diabetes_screening,
      },
      {
        'title': 'Skrining Jantung',
        'subtitle': 'Evaluasi risiko kesehatan jantung dan aktivitas harian',
        'icon': Icons.favorite_outline,
        'route': Routes.heart_screening,
      },
    ];

    showDialog<void>(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          insetPadding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 24,
          ),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 18,
                  ),
                  decoration: BoxDecoration(
                    color: colors.primary,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(18),
                      topRight: Radius.circular(18),
                    ),
                  ),
                  child: Text(
                    'Pilih Jenis Skrining',
                    style: theme.textTheme.headlineMedium?.copyWith(
                      color: colors.onPrimary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 18,
                  ),
                  child: Column(
                    children: options.map((option) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Material(
                          color: colors.surface,
                          borderRadius: BorderRadius.circular(16),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(16),
                            onTap: () {
                              Navigator.pop(context);
                              Navigator.pushNamed(
                                context,
                                option['route'] as String,
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: colors.surface,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: colors.onSurface.withOpacity(0.08),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: colors.primary.withOpacity(0.12),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      option['icon'] as IconData,
                                      size: 24,
                                      color: colors.primary,
                                    ),
                                  ),
                                  const SizedBox(width: 14),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          option['title'] as String,
                                          style: theme.textTheme.bodyLarge
                                              ?.copyWith(
                                                fontWeight: FontWeight.w600,
                                                color: colors.onSurface,
                                              ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          option['subtitle'] as String,
                                          style: theme.textTheme.bodyMedium
                                              ?.copyWith(
                                                color: colors.onSurface
                                                    .withOpacity(0.7),
                                              ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Icon(
                                    Icons.arrow_forward_ios,
                                    size: 16,
                                    color: colors.onSurface.withOpacity(0.55),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ─────────────────────────────────────────
  // ARTIKEL SECTION
  // ─────────────────────────────────────────
  Widget _buildArtikelSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section header
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Artikel Untukmu',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: _themeViewModel.currentTheme.colorScheme.onSurface,
                ),
              ),
              GestureDetector(
                onTap: () {},
                child: Text(
                  'Lihat semua',
                  style: TextStyle(
                    fontSize: 13,
                    color: _themeViewModel.currentTheme.colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 4),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'Konten pilihan sesuai kebutuhan kesehatanmu',
            style: TextStyle(
              fontSize: 12,
              color: _themeViewModel.currentTheme.colorScheme.onSurface
                  .withOpacity(0.6),
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Featured article (large card)
        _buildFeaturedArticle(_articles[0]),
        const SizedBox(height: 12),

        // Horizontal scroll — remaining articles
        SizedBox(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            physics: const BouncingScrollPhysics(),
            itemCount: _articles.length - 1,
            itemBuilder: (context, index) {
              return _buildSmallArticleCard(_articles[index + 1]);
            },
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  /// Large featured card
  Widget _buildFeaturedArticle(Map<String, dynamic> article) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: article['bgColor'] as Color,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: (article['tagColor'] as Color).withOpacity(0.15),
            width: 1,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Tag chip
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: (article['tagColor'] as Color).withOpacity(0.15),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      article['tag'],
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: article['tagColor'] as Color,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    article['title'],
                    style: _themeViewModel.currentTheme.textTheme.bodyLarge
                        ?.copyWith(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: _themeViewModel
                              .currentTheme
                              .colorScheme
                              .onSurface,
                          height: 1.3,
                        ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    article['subtitle'],
                    style: _themeViewModel.currentTheme.textTheme.bodyMedium
                        ?.copyWith(
                          fontSize: 12,
                          color: _themeViewModel
                              .currentTheme
                              .colorScheme
                              .onSurface
                              .withOpacity(0.7),
                          height: 1.4,
                        ),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Icon(
                        Icons.access_time_rounded,
                        size: 13,
                        color: _themeViewModel
                            .currentTheme
                            .colorScheme
                            .onSurface
                            .withOpacity(0.6),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        article['duration'],
                        style: _themeViewModel.currentTheme.textTheme.bodyMedium
                            ?.copyWith(
                              fontSize: 11,
                              color: _themeViewModel
                                  .currentTheme
                                  .colorScheme
                                  .onSurface
                                  .withOpacity(0.6),
                            ),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: article['tagColor'] as Color,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          'Baca',
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 14),
            // Emoji illustration
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: _themeViewModel.currentTheme.colorScheme.onSurface
                    .withOpacity(0.08),
                borderRadius: BorderRadius.circular(18),
              ),
              alignment: Alignment.center,
              child: Text(
                article['emoji'],
                style: const TextStyle(fontSize: 36),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Small card for horizontal scroll
  Widget _buildSmallArticleCard(Map<String, dynamic> article) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        width: 160,
        margin: const EdgeInsets.only(right: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: article['bgColor'] as Color,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: (article['tagColor'] as Color).withOpacity(0.15),
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Emoji box
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: _themeViewModel.currentTheme.colorScheme.onSurface
                    .withOpacity(0.08),
                borderRadius: BorderRadius.circular(12),
              ),
              alignment: Alignment.center,
              child: Text(
                article['emoji'],
                style: const TextStyle(fontSize: 22),
              ),
            ),
            const SizedBox(height: 10),
            // Tag
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: (article['tagColor'] as Color).withOpacity(0.15),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                article['tag'],
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: article['tagColor'] as Color,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              article['title'],
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: _themeViewModel.currentTheme.textTheme.bodyMedium
                  ?.copyWith(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: _themeViewModel.currentTheme.colorScheme.onSurface,
                    height: 1.3,
                  ),
            ),
            const Spacer(),
            Row(
              children: [
                Icon(
                  Icons.access_time_rounded,
                  size: 11,
                  color: _themeViewModel.currentTheme.colorScheme.onSurface
                      .withOpacity(0.6),
                ),
                const SizedBox(width: 3),
                Expanded(
                  child: Text(
                    article['duration'],
                    style: _themeViewModel.currentTheme.textTheme.bodySmall
                        ?.copyWith(
                          fontSize: 10,
                          color: _themeViewModel
                              .currentTheme
                              .colorScheme
                              .onSurface
                              .withOpacity(0.6),
                        ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _handleNavigation(int index) {
    // Handle navigation based on the selected index
    // index 0: Beranda (Dashboard) - already here
    // index 1: Diary
    // index 2: Progres
    // index 3: Profil
    switch (index) {
      case 0:
        // Already on dashboard
        break;
      case 1:
        // Navigate to Diary
        break;
      case 2:
        // Navigate to Progress
        break;
      case 3:
        // Navigate to Profile
        Navigator.pushNamed(context, Routes.profile);
        break;
      default:
        break;
    }
  }
}
