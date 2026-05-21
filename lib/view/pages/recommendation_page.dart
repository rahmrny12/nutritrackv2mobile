import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:nutritrack/view/viewmodel/insight_state.dart';
import 'package:nutritrack/view/viewmodel/insight_viewmodel.dart';

class RecommendationPage extends StatefulWidget {
  const RecommendationPage({super.key});

  @override
  State<RecommendationPage> createState() => _RecommendationPageState();
}

class _RecommendationPageState extends State<RecommendationPage> {
  late final InsightViewModel viewModel;
  int currentIndex = 0;

  // ── Design tokens (matches DashboardPage) ──────────────────────────────────
  static const Color _bg = Color(0xFFF2F6F5);
  static const Color _teal = Color(0xFF2ABFB0);
  static const Color _tealDark = Color(0xFF1A9E91);
  static const Color _dark = Color(0xFF1A1A1A);
  static const Color _grey = Color(0xFF888888);
  static const Color _lightGrey = Color(0xFF999999);

  // ── SliverAppBar dimensions (mirrors DashboardPage pattern) ───────────────
  static const double _expandedHeight = 200.0;

  final ScrollController _scrollController = ScrollController();
  bool _isCollapsed = false;

  // REPLACE initState with:
  @override
  void initState() {
    super.initState();
    viewModel = InsightViewModel();
    viewModel.fetchWeeklyInsights();
  }

  // REPLACE dispose with:
  @override
  void dispose() {
    viewModel.dispose();
    super.dispose();
  }

  // ── Build ──────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          _buildSliverAppBar(),
          SliverToBoxAdapter(
            child: ValueListenableBuilder<InsightState>(
              valueListenable: viewModel,
              builder: (context, state, _) {
                if (state.isLoading) return _buildLoading();
                if (state.error != null) return _buildError(state.error!);
                if (!state.hasData) return _buildEmpty();
                return _buildContent(state);
              },
            ),
          ),
        ],
      ),
    );
  }

  // ── Sliver AppBar — expandable hero, mirrors DashboardPage exactly ─────────
  Widget _buildSliverAppBar() {
  return SliverAppBar(
    expandedHeight: _expandedHeight,
    pinned: false,
    floating: false,
    snap: false,
    stretch: true,
    backgroundColor: Colors.transparent,
    elevation: 0,
    automaticallyImplyLeading: false,
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
            bottomLeft: Radius.circular(32),
            bottomRight: Radius.circular(32),
          ),
        ),
        child: SafeArea(
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.arrow_back_ios_new_rounded,
                          size: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        'Analisis AI',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const Spacer(),
                    _refreshButton(),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Analisa Nutrisi\nMingguan',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              height: 1.25,
                            ),
                          ),
                          SizedBox(height: 6),
                          Text(
                            'Berdasarkan pola makanmu\n7 hari terakhir.',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.white70,
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: 72,
                      height: 72,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: Icon(Icons.auto_awesome_rounded, size: 40, color: Colors.white),
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

  Widget _refreshButton() {
    return GestureDetector(
      onTap: viewModel.fetchWeeklyInsights,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(Icons.refresh_rounded, size: 18, color: Colors.white),
      ),
    );
  }

  // ── Loading ────────────────────────────────────────────────────────────────
  Widget _buildLoading() {
    return SizedBox(
      height: 400,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 40,
              height: 40,
              child: CircularProgressIndicator(color: _teal, strokeWidth: 3),
            ),
            const SizedBox(height: 16),
            const Text(
              'Memuat analisa minggu ini…',
              style: TextStyle(fontSize: 13, color: _lightGrey),
            ),
          ],
        ),
      ),
    );
  }

  // ── Error ──────────────────────────────────────────────────────────────────
  Widget _buildError(String error) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.error_outline_rounded,
                size: 32,
                color: Colors.red.shade400,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Gagal memuat analisa',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: _dark,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              error,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12, color: _grey),
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: viewModel.fetchWeeklyInsights,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 28,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [_teal, _tealDark]),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'Coba Lagi',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Empty ──────────────────────────────────────────────────────────────────
  Widget _buildEmpty() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Container(
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: const BoxDecoration(
                color: Color(0xFFE6F7F6),
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: Text('🤖', style: TextStyle(fontSize: 32)),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Belum ada analisa',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: _dark,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Catat makananmu lebih banyak agar AI dapat\nmemberikan rekomendasi yang tepat.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: _grey, height: 1.5),
            ),
          ],
        ),
      ),
    );
  }

  // ── Main content ───────────────────────────────────────────────────────────
  Widget _buildContent(InsightState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),

        // ── Section header ───────────────────────────────────────────────────
        _buildSectionHeader(
          title: 'Rekomendasi Mingguan',
          subtitle: 'Geser kartu untuk melihat semua saran',
          icon: Icons.lightbulb_rounded,
        ),
        const SizedBox(height: 16),

        // ── Card swiper ──────────────────────────────────────────────────────
        SizedBox(
          height: 200,
          child: CardSwiper(
            cardsCount: state.recommendations.length,
            numberOfCardsDisplayed: state.recommendations.length > 3
                ? 3
                : state.recommendations.length,
            backCardOffset: const Offset(0, 12),
            padding: const EdgeInsets.symmetric(horizontal: 20),
            onSwipe: (prev, current, direction) {
              setState(() => currentIndex = current ?? 0);
              return true;
            },
            cardBuilder:
                (
                  context,
                  index,
                  horizontalThresholdPercentage,
                  verticalThresholdPercentage,
                ) {
                  return _recommendationCard(
                    state.recommendations[index],
                    index,
                  );
                },
          ),
        ),

        // ── Swipe hint ───────────────────────────────────────────────────────
        Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 12),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(Icons.swipe_rounded, size: 14, color: _lightGrey),
                SizedBox(width: 5),
                Text(
                  'Geser ke kiri atau kanan',
                  style: TextStyle(fontSize: 11, color: _lightGrey),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 28),

        // ── Menu recommendation section ───────────────────────────────────────
        _buildSectionHeader(
          title: 'Rekomendasi Menu',
          subtitle: 'Pilihan makanan sesuai kebutuhan nutrisimu',
          icon: Icons.restaurant_menu_rounded,
        ),
        const SizedBox(height: 16),
        _buildMenuRecommendations(),

        const SizedBox(height: 32),
      ],
    );
  }

  // ── Section header ─────────────────────────────────────────────────────────
  Widget _buildSectionHeader({
    required String title,
    required String subtitle,
    required IconData icon,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: const Color(0xFFE6F7F6),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 18, color: _teal),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: _dark,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(fontSize: 11, color: _lightGrey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Recommendation swipe card ──────────────────────────────────────────────
  Widget _recommendationCard(String recommendation, int index) {
    final List<List<Color>> gradients = [
      [const Color(0xFF2ABFB0), const Color(0xFF1A9E91)],
      [const Color(0xFF3B9EE8), const Color(0xFF2174C0)],
      [const Color(0xFF7C6FCD), const Color(0xFF5B4FB5)],
      [const Color(0xFFE07B39), const Color(0xFFBF5E20)],
    ];
    final gradient = gradients[index % gradients.length];

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: gradient,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: gradient[0].withOpacity(0.30),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.auto_awesome_rounded,
                  color: Colors.white,
                  size: 18,
                ),
              ),
              const SizedBox(width: 10),
              Text(
                'Insight #${index + 1}',
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.white70,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: Text(
              recommendation,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                height: 1.55,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(
                      Icons.chevron_left_rounded,
                      color: Colors.white70,
                      size: 16,
                    ),
                    SizedBox(width: 2),
                    Icon(
                      Icons.chevron_right_rounded,
                      color: Colors.white70,
                      size: 16,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── Menu recommendations list ──────────────────────────────────────────────
  Widget _buildMenuRecommendations() {
    final menus = [
      {
        'meal': 'Sarapan',
        'name': 'Oatmeal Buah Segar',
        'kcal': '320 kcal',
        'desc':
            'Oatmeal dengan pisang, stroberi, dan madu. Kaya serat dan energi pagi.',
        'emoji': '🥣',
        'tag': 'Tinggi Serat',
        'tagColor': const Color(0xFF22C55E),
        'bg': const Color(0xFFEEFBF3),
        'accentColor': const Color(0xFF22C55E),
      },
      {
        'meal': 'Makan Siang',
        'name': 'Nasi Merah Ayam Panggang',
        'kcal': '520 kcal',
        'desc':
            'Nasi merah dengan ayam panggang tanpa kulit, tumis brokoli, dan wortel.',
        'emoji': '🍱',
        'tag': 'Tinggi Protein',
        'tagColor': _teal,
        'bg': const Color(0xFFE6F7F6),
        'accentColor': _teal,
      },
      {
        'meal': 'Makan Malam',
        'name': 'Sup Ikan Sayur',
        'kcal': '380 kcal',
        'desc':
            'Sup ikan kakap dengan bayam, tomat, dan jahe. Rendah lemak, kaya omega-3.',
        'emoji': '🍲',
        'tag': 'Rendah Lemak',
        'tagColor': const Color(0xFF3B82F6),
        'bg': const Color(0xFFEEF4FF),
        'accentColor': const Color(0xFF3B82F6),
      },
      {
        'meal': 'Camilan',
        'name': 'Yogurt Granola',
        'kcal': '180 kcal',
        'desc':
            'Greek yogurt rendah lemak dengan granola dan irisan almond. Cocok untuk camilan sore.',
        'emoji': '🥛',
        'tag': 'Probiotik',
        'tagColor': const Color(0xFFE07B39),
        'bg': const Color(0xFFFFF3EC),
        'accentColor': const Color(0xFFE07B39),
      },
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: menus.map((menu) => _buildMenuCard(menu)).toList(),
      ),
    );
  }

  Widget _buildMenuCard(Map<String, dynamic> menu) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: menu['bg'] as Color,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: (menu['accentColor'] as Color).withOpacity(0.18),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left accent bar
          Container(
            width: 4,
            height: 72,
            decoration: BoxDecoration(
              color: menu['accentColor'] as Color,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(width: 14),
          // Main content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 9,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: (menu['accentColor'] as Color).withOpacity(0.15),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        menu['meal'] as String,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: menu['accentColor'] as Color,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 9,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        menu['tag'] as String,
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF666666),
                        ),
                      ),
                    ),
                    const Spacer(),
                    Text(
                      menu['kcal'] as String,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: menu['accentColor'] as Color,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  menu['name'] as String,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  menu['desc'] as String,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFF666666),
                    height: 1.45,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          // Emoji box
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.7),
              borderRadius: BorderRadius.circular(14),
            ),
            alignment: Alignment.center,
            child: Text(
              menu['emoji'] as String,
              style: const TextStyle(fontSize: 26),
            ),
          ),
        ],
      ),
    );
  }
}
