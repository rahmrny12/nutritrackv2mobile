import 'package:flutter/material.dart';
import 'package:nutritrack/core/route_generator.dart';
import 'package:nutritrack/data/models/ingredient_model.dart';
import 'package:nutritrack/view/viewmodel/log_food_viewmodel.dart';
import 'package:nutritrack/view/viewmodel/log_food_state.dart';

class InitialLogFood extends StatefulWidget {
  const InitialLogFood({super.key});
  @override
  State<InitialLogFood> createState() => _InitialLogFoodState();
}

class _InitialLogFoodState extends State<InitialLogFood> {
  static const Color _teal = Color(0xFF2ABFB0);

  int _selectedTab = 0;
  final List<String> _tabs = ['Sering Dimakan', 'Terbaru', 'Resepku'];
  late final LogFoodViewModel viewModel;

  // Sample ingredients data
  final List<IngredientModel> ingredients = [
    IngredientModel(
      id: 1,
      name: 'Nasi Putih',
      caloriesPer100g: 130,
      protein: 2.7,
      carbs: 28,
      fat: 0.3,
      emoji: '🍚',
      portion: 100,
    ),
    IngredientModel(
      id: 2,
      name: 'Ayam Goreng Dada',
      caloriesPer100g: 260,
      protein: 35,
      carbs: 0,
      fat: 12,
      emoji: '🍗',
      portion: 100,
    ),
    IngredientModel(
      id: 3,
      name: 'Tempe Goreng',
      caloriesPer100g: 236,
      protein: 19,
      carbs: 9,
      fat: 15,
      emoji: '🟫',
      portion: 50,
    ),
    IngredientModel(
      id: 4,
      name: 'Sayur Bayam Bening',
      caloriesPer100g: 30,
      protein: 3,
      carbs: 3,
      fat: 0.4,
      emoji: '🥬',
      portion: 150,
    ),
    IngredientModel(
      id: 5,
      name: 'Telur Dadar',
      caloriesPer100g: 186,
      protein: 13,
      carbs: 1.1,
      fat: 14,
      emoji: '🍳',
      portion: 50,
    ),
  ];

  @override
  void initState() {
    super.initState();
    viewModel = LogFoodViewModel();
    // Add selected foods to viewModel
    _initializeSelectedFoods();
  }

  void _initializeSelectedFoods() {
    // Add first two ingredients as selected by default
    viewModel.addFood(ingredients[0]); // Nasi Putih
    viewModel.addFood(ingredients[1]); // Ayam Goreng Dada
  }

  @override
  void dispose() {
    viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<LogFoodState>(
      valueListenable: viewModel,
      builder: (context, state, _) {
        return Scaffold(
          backgroundColor: const Color(0xFFF8F9FA),
          body: Column(
            children: [
              _buildAppBar(),
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildBanner(),
                      const SizedBox(height: 16),
                      _buildSearchBar(),
                      const SizedBox(height: 14),
                      _buildTabs(),
                      const SizedBox(height: 20),
                      _buildRecommendationHeader(),
                      const SizedBox(height: 12),
                      _buildFoodList(),
                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ),
              _buildBottomBar(state),
            ],
          ),
        );
      },
    );
  }

  // ── App Bar ──────────────────────────────
  Widget _buildAppBar() {
    return Container(
      color: Colors.white,
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              GestureDetector(
                onTap: () {},
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF2F2F2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.arrow_back,
                      size: 18, color: Color(0xFF333333)),
                ),
              ),
              const Expanded(
                child: Column(
                  children: [
                    Text(
                      'Makan Siang',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1A1A1A)),
                    ),
                    Text(
                      'Target: 600 kcal',
                      style: TextStyle(
                          fontSize: 12, color: Color(0xFF999999)),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {},
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF2F2F2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.crop_free,
                      size: 18, color: Color(0xFF2ABFB0)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Banner ───────────────────────────────
  Widget _buildBanner() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      height: 130,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [Color(0xFF1A5C52), Color(0xFF2ABFB0)],
        ),
      ),
      child: Stack(
        children: [
          // Background food image placeholder (right side)
          Positioned(
            right: 0,
            top: 0,
            bottom: 0,
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
              child: Container(
                width: 140,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [Color(0x002ABFB0), Color(0x882ABFB0)],
                  ),
                ),
                alignment: Alignment.center,
                child: const Text('🍽️', style: TextStyle(fontSize: 60)),
              ),
            ),
          ),
          // Text content
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Atur Sendiri Menu Favoritmu',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Sesuaikan pilihan makanan sesuai selera dan\nkebutuhan gizimu setiap hari.',
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.white70,
                    height: 1.4,
                  ),
                ),
                const Spacer(),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                        border:
                            Border.all(color: Colors.white38, width: 1),
                      ),
                      child: const Text(
                        '12 Menu Kustomisasi',
                        style: TextStyle(
                            fontSize: 11,
                            color: Colors.white,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.25),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.chevron_right,
                          color: Colors.white, size: 18),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Search Bar ───────────────────────────
  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFE8E8E8)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: const Row(
          children: [
            Icon(Icons.search, color: Color(0xFFAAAAAA), size: 20),
            SizedBox(width: 10),
            Text(
              'Cari makanan atau resep...',
              style: TextStyle(
                  fontSize: 13, color: Color(0xFFBBBBBB)),
            ),
          ],
        ),
      ),
    );
  }

  // ── Tabs ─────────────────────────────────
  Widget _buildTabs() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: List.generate(_tabs.length, (index) {
          final isSelected = index == _selectedTab;
          return GestureDetector(
            onTap: () => setState(() => _selectedTab = index),
            child: Container(
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(
                  horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color:
                    isSelected ? const Color(0xFF2ABFB0) : Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected
                      ? const Color(0xFF2ABFB0)
                      : const Color(0xFFE0E0E0),
                ),
              ),
              child: Text(
                _tabs[index],
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: isSelected
                      ? Colors.white
                      : const Color(0xFF666666),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  // ── Recommendation Header ────────────────
  Widget _buildRecommendationHeader() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Text(
        'Rekomendasi untukmu',
        style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1A1A1A)),
      ),
    );
  }

  // ── Food List ────────────────────────────
  Widget _buildFoodList() {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: ingredients.length,
      separatorBuilder: (_, __) => const Divider(
        height: 1,
        color: Color(0xFFF0F0F0),
        indent: 72,
      ),
      itemBuilder: (context, index) {
        final ingredient = ingredients[index];
        final isSelected = viewModel.isFoodSelected(ingredient.id);
        return _buildFoodItem(
          ingredient: ingredient,
          isSelected: isSelected,
          onToggle: () => viewModel.toggleFood(ingredient),
        );
      },
    );
  }

  Widget _buildFoodItem({
    required IngredientModel ingredient,
    required bool isSelected,
    required VoidCallback onToggle,
  }) {
    return GestureDetector(
      onTap: onToggle,
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            const SizedBox(width: 12),
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: const Color(0xFFF5F5F5),
                borderRadius: BorderRadius.circular(12),
              ),
              alignment: Alignment.center,
              child: Text(ingredient.emoji ?? '', style: const TextStyle(fontSize: 26)),
            ),
            const SizedBox(width: 12),
            // Name & portion
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    ingredient.name,
                    style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1A1A1A)),
                  ),
                  const SizedBox(height: 3),
                  Row(
                    children: [
                      Text(
                        '${ingredient.portion?.toInt() ?? 100}g',
                        style: const TextStyle(
                            fontSize: 12, color: Color(0xFF999999)),
                      ),
                      const Text(
                        ' • ',
                        style: TextStyle(
                            fontSize: 12, color: Color(0xFF999999)),
                      ),
                      Text(
                        '${ingredient.totalKcal} kcal',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF2ABFB0),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            // Toggle button
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color(0xFF2ABFB0)
                    : Colors.white,
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected
                      ? const Color(0xFF2ABFB0)
                      : const Color(0xFFDDDDDD),
                  width: 1.5,
                ),
              ),
              child: Icon(
                isSelected ? Icons.check : Icons.add,
                size: 16,
                color: isSelected
                    ? Colors.white
                    : const Color(0xFF999999),
              ),
            ),
            const SizedBox(width: 12),
          ],
        ),
      ),
    );
  }

  // ── Bottom Bar ───────────────────────────
  Widget _buildBottomBar(LogFoodState state) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 16,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 14,
        bottom: MediaQuery.of(context).padding.bottom + 14,
      ),
      child: Row(
        children: [
          // Total calories info
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Total Kalori',
                style: TextStyle(
                    fontSize: 11, color: Color(0xFF999999)),
              ),
              const SizedBox(height: 1),
              Text(
                '${state.totalKcal} kcal',
                style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1A1A1A)),
              ),
              const SizedBox(height: 3),
              Row(
                children: [
                  _MacroDot(
                    color: const Color(0xFF2ABFB0),
                    label: '${state.totalCarbs.toStringAsFixed(0)}g Karbo',
                  ),
                  const SizedBox(width: 8),
                  _MacroDot(
                    color: const Color(0xFFFF6B6B),
                    label: '${state.totalProtein.toStringAsFixed(0)}g Pro',
                  ),
                ],
              ),
            ],
          ),
          const Spacer(),
          // Selesai button
          GestureDetector(
            onTap: () => Navigator.pushNamed(
              context,
              Routes.confirmLogFood,
            ),
            child: Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 24, vertical: 14),
              decoration: BoxDecoration(
                color: const Color(0xFF2ABFB0),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF2ABFB0).withOpacity(0.35),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Text(
                    'Selesai (${state.totalItems})',
                    style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  const SizedBox(width: 6),
                  const Icon(Icons.arrow_forward,
                      color: Colors.white, size: 16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Macro dot widget ─────────────────────
class _MacroDot extends StatelessWidget {
  final Color color;
  final String label;
  const _MacroDot({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 7,
          height: 7,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Text(label,
            style: const TextStyle(fontSize: 10, color: Color(0xFF999999))),
      ],
    );
  }
}