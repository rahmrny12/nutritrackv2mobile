import 'package:flutter/material.dart';
import 'package:nutritrack/core/api_service.dart';
import 'package:nutritrack/data/repository/ingredient_repository.dart';
import 'package:nutritrack/view/viewmodel/log_food_viewmodel.dart';
import 'package:nutritrack/view/viewmodel/log_food_state.dart';

class ConfirmLogFood extends StatefulWidget {
  const ConfirmLogFood({super.key});

  @override
  State<ConfirmLogFood> createState() => _ConfirmLogFoodState();
}

class _ConfirmLogFoodState extends State<ConfirmLogFood> {
  static const Color _teal = Color(0xFF2ABFB0);

  // Menggunakan global singleton instance
  late final LogFoodViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    // Menggunakan global singleton instance
    _viewModel = LogFoodViewModel(repo: IngredientRepository(ApiService()));
  }

  @override
  void dispose() {
    // Jangan dispose global instance di sini
    // _viewModel.dispose(); // Commented out
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<LogFoodState>(
      valueListenable: _viewModel,
      builder: (context, state, _) {
        return Scaffold(
          backgroundColor: const Color(0xFFF8F9FA),
          body: Column(
            children: [
              _buildAppBar(),
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildActionToSaveMealBanner(),
                      const SizedBox(height: 24),
                      _buildIngredientList(state),
                      const SizedBox(height: 24),
                      _buildRingkasanGizi(state),
                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ),
              _buildSimpanButton(),
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
                onTap: () => Navigator.pop(context),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF2F2F2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.arrow_back,
                    size: 18,
                    color: Color(0xFF333333),
                  ),
                ),
              ),
              const Expanded(
                child: Center(
                  child: Text(
                    'Tambah Menu',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1A1A1A),
                    ),
                  ),
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
                  child: const Icon(
                    Icons.crop_free,
                    size: 18,
                    color: Color(0xFF2ABFB0),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Ide Ditemukan Banner ─────────────────
  Widget _buildActionToSaveMealBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFE8F8F7),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFB2E8E4), width: 1),
      ),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: _teal.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.tips_and_updates_outlined,
              color: _teal,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Simpan Menu Favoritmu?',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1A6B64),
                  ),
                ),
                SizedBox(height: 3),
                Text(
                  'Kamu bisa menyimpan menu kesukaanmu untuk pencatatan berikutnya.',
                  style: TextStyle(
                    fontSize: 11,
                    color: Color(0xFF3D8C86),
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIngredientList(LogFoodState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Pilihan Bahan Makanan',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1A1A1A),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Berikut adalah ${state.selectedFoods.length} bahan makanan yang kamu pilih.',
          style: const TextStyle(fontSize: 12, color: Color(0xFF999999)),
        ),
        const SizedBox(height: 12),
        ...List.generate(state.selectedFoods.length, (index) {
          return _buildIngredientCard(state.selectedFoods[index]);
        }),
      ],
    );
  }

  Widget _buildIngredientCard(ingredient) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
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
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: const Color(0xFFF5F5F5),
              borderRadius: BorderRadius.circular(12),
            ),
            alignment: Alignment.center,
            child: Text(ingredient.emoji ?? '🍽️',
                style: const TextStyle(fontSize: 26)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        ingredient.name,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1A1A1A),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    _MetaChip(
                      icon: Icons.scale,
                      label:
                          '${ingredient.portion?.toInt() ?? 100}g',
                      color: const Color(0xFF999999),
                    ),
                    const SizedBox(width: 16),
                    _MetaChip(
                      icon: Icons.local_fire_department_outlined,
                      label: '${ingredient.totalKcal} kcal',
                      color: const Color(0xFF999999),
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

  Widget _buildRingkasanGizi(LogFoodState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Ringkasan Gizi Bahan',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1A1A1A),
          ),
        ),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFEEEEEE)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Total estimasi gizi dari ${state.selectedFoods.length} bahan:',
                style: const TextStyle(fontSize: 12, color: Color(0xFF999999)),
              ),
              const SizedBox(height: 14),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  _GiziItem(
                    label: 'PROTEIN',
                    value: '${state.totalProtein.toStringAsFixed(1)}g',
                  ),
                  const SizedBox(width: 36),
                  _GiziItem(
                    label: 'KARBO',
                    value: '${state.totalCarbs.toStringAsFixed(1)}g',
                  ),
                  const SizedBox(width: 36),
                  _GiziItem(
                    label: 'LEMAK',
                    value: '${state.totalFat.toStringAsFixed(1)}g',
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ── Simpan Button ────────────────────────
  Widget _buildSimpanButton() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 12,
        bottom: MediaQuery.of(context).padding.bottom + 16,
      ),
      child: SizedBox(
        width: double.infinity,
        child: GestureDetector(
          onTap: () {},
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              color: _teal,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: _teal.withOpacity(0.35),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            alignment: Alignment.center,
            child: const Text(
              'Simpan',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ── Helper Widgets ───────────────────────

class _MetaChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  const _MetaChip({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 13, color: color),
        const SizedBox(width: 4),
        Text(label, style: TextStyle(fontSize: 11, color: color)),
      ],
    );
  }
}

class _GiziItem extends StatelessWidget {
  final String label;
  final String value;
  const _GiziItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 10,
            color: Color(0xFF999999),
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1A1A1A),
          ),
        ),
      ],
    );
  }
}
