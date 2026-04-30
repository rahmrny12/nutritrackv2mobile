import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nutritrack/core/route_generator.dart';
import 'package:nutritrack/data/models/ingredient_model.dart';
import 'package:nutritrack/view/viewmodel/log_food_viewmodel.dart';
import 'package:nutritrack/view/viewmodel/log_food_state.dart';
import 'package:nutritrack/data/repository/ingredient_repository.dart';
import 'package:nutritrack/core/api_service.dart';
import 'dart:io';

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

  @override
  void initState() {
    super.initState();
    viewModel = LogFoodViewModel(repo: IngredientRepository(ApiService()));

    viewModel.fetchIngredients();
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
                      _buildFoodList(state),
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
                  child: const Icon(
                    Icons.arrow_back,
                    size: 18,
                    color: Color(0xFF333333),
                  ),
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
                        color: Color(0xFF1A1A1A),
                      ),
                    ),
                    Text(
                      'Target: 600 kcal',
                      style: TextStyle(fontSize: 12, color: Color(0xFF999999)),
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
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.white38, width: 1),
                      ),
                      child: const Text(
                        '12 Menu Kustomisasi',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: () => Navigator.pushNamed(context, Routes.addMeal),
                      child: Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.25),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.chevron_right,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
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
              style: TextStyle(fontSize: 13, color: Color(0xFFBBBBBB)),
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
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFF2ABFB0) : Colors.white,
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
                  color: isSelected ? Colors.white : const Color(0xFF666666),
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
          color: Color(0xFF1A1A1A),
        ),
      ),
    );
  }

  // ── Food List ────────────────────────────
  Widget _buildFoodList(LogFoodState state) {
    final ingredients = state.ingredients;

    if (state.error != null) {
      return Center(child: Text(state.error!));
    }

    if (ingredients.isEmpty) {
      return const Center(child: Text("Tidak ada data"));
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: ingredients.length,
      separatorBuilder: (_, __) =>
          const Divider(height: 1, color: Color(0xFFF0F0F0), indent: 72),
      itemBuilder: (context, index) {
        final ingredient = ingredients[index];
        final isSelected = viewModel.isFoodSelected(ingredient.id);

        return _buildFoodItem(
          ingredient: ingredient,
          isSelected: isSelected,
          onToggle: () => viewModel.toggleSelectedFood(ingredient), // ✅ FIX
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
                color: const Color.fromARGB(255, 101, 101, 101),
                borderRadius: BorderRadius.circular(12),
              ),
              alignment: Alignment.center,
              child: Text(
                ingredient.emoji ?? '🍽️',
                style: const TextStyle(fontSize: 26),
              ),
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
                      color: Color(0xFF1A1A1A),
                    ),
                  ),
                  const SizedBox(height: 3),
                  Row(
                    children: [
                      Text(
                        '${ingredient.portion?.toInt() ?? 100}g',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF999999),
                        ),
                      ),
                      const Text(
                        ' • ',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF999999),
                        ),
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
                color: isSelected ? const Color(0xFF2ABFB0) : Colors.white,
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
                color: isSelected ? Colors.white : const Color(0xFF999999),
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
                style: TextStyle(fontSize: 11, color: Color(0xFF999999)),
              ),
              const SizedBox(height: 1),
              Text(
                '${state.totalKcal} kcal',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A1A1A),
                ),
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
          GestureDetector(
            onTap: () => showAddIngredientSheet(context, viewModel),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
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
                    'Tambah Bahan',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 6),
                  const Icon(
                    Icons.arrow_forward,
                    color: Colors.white,
                    size: 16,
                  ),
                ],
              ),
            ),
          ),
          const Spacer(),
          GestureDetector(
            onTap: () => Navigator.pushNamed(context, Routes.confirmLogFood),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
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
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 6),
                  const Icon(
                    Icons.arrow_forward,
                    color: Colors.white,
                    size: 16,
                  ),
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
        Text(
          label,
          style: const TextStyle(fontSize: 10, color: Color(0xFF999999)),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Helper: show the sheet from anywhere
// ─────────────────────────────────────────────────────────────────────────────
Future<void> showAddIngredientSheet(
  BuildContext context,
  LogFoodViewModel viewModel,
) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => AddIngredientSheet(viewModel: viewModel),
  );
}

// ─────────────────────────────────────────────────────────────────────────────
// Sheet Widget
// ─────────────────────────────────────────────────────────────────────────────
class AddIngredientSheet extends StatefulWidget {
  final LogFoodViewModel viewModel;

  const AddIngredientSheet({super.key, required this.viewModel});

  @override
  State<AddIngredientSheet> createState() => _AddIngredientSheetState();
}

class _AddIngredientSheetState extends State<AddIngredientSheet> {
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();

  static const Color _teal = Color(0xFF2ABFB0);
  static const Color _bg = Color(0xFFF8F9FA);

  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _caloriesController = TextEditingController();
  final TextEditingController _proteinController = TextEditingController();
  final TextEditingController _carbsController = TextEditingController();
  final TextEditingController _fatController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _caloriesController.dispose();
    _proteinController.dispose();
    _carbsController.dispose();
    _fatController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picked = await _picker.pickImage(source: ImageSource.gallery);

    if (picked != null) {
      setState(() {
        _imageFile = File(picked.path);
      });
    }
  }

  void _removeImage() {
    setState(() {
      _imageFile = null;
    });
  }

  Widget _buildPhotoInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Foto (Opsional)', style: Theme.of(context).textTheme.bodyMedium),
        const SizedBox(height: 8),

        GestureDetector(
          onTap: _pickImage,
          child: Container(
            height: 140,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: _imageFile == null
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(
                        Icons.camera_alt_outlined,
                        size: 28,
                        color: Colors.grey,
                      ),
                      SizedBox(height: 6),
                      Text('Tambah Foto', style: TextStyle(color: Colors.grey)),
                    ],
                  )
                : Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.file(
                          _imageFile!,
                          width: double.infinity,
                          height: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned(
                        top: 8,
                        right: 8,
                        child: GestureDetector(
                          onTap: _removeImage,
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.6),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.close,
                              size: 16,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.9,
      minChildSize: 0.5,
      maxChildSize: 1,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              _buildHandle(),
              _buildHeader(),
              const Divider(height: 1),

              Expanded(
                child: Form(
                  key: _formKey,
                  child: ListView(
                    controller: scrollController,
                    padding: const EdgeInsets.all(20),
                    children: [
                      _buildPhotoInput(),

                      const SizedBox(height: 16),

                      _buildTextField(
                        controller: _nameController,
                        label: 'Nama Bahan',
                        hint: 'Contoh: Nasi Putih',
                      ),

                      const SizedBox(height: 16),

                      _buildNumberField(
                        controller: _caloriesController,
                        label: 'Kalori (per 100g)',
                      ),

                      const SizedBox(height: 16),

                      Row(
                        children: [
                          Expanded(
                            child: _buildNumberField(
                              controller: _proteinController,
                              label: 'Protein (g)',
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildNumberField(
                              controller: _carbsController,
                              label: 'Karbo (g)',
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      _buildNumberField(
                        controller: _fatController,
                        label: 'Lemak (g)',
                      ),

                      const SizedBox(height: 24),

                      _buildPreviewCard(),
                    ],
                  ),
                ),
              ),

              _buildSubmitButton(),
            ],
          ),
        );
      },
    );
  }

  // ── Handle ──
  Widget _buildHandle() {
    return Padding(
      padding: const EdgeInsets.only(top: 12, bottom: 6),
      child: Container(
        width: 40,
        height: 4,
        decoration: BoxDecoration(
          color: const Color(0xFFDDDDDD),
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }

  // ── Header ──
  Widget _buildHeader() {
    return const Padding(
      padding: EdgeInsets.fromLTRB(20, 8, 20, 16),
      child: Row(
        children: [
          Expanded(
            child: Text(
              'Tambah Bahan Makanan',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  // ── Text Field ──
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 12)),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          validator: (v) => v == null || v.isEmpty ? 'Wajib diisi' : null,
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: _bg,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }

  // ── Number Field ──
  Widget _buildNumberField({
    required TextEditingController controller,
    required String label,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 12)),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          keyboardType: TextInputType.number,
          validator: (v) {
            if (v == null || v.isEmpty) return 'Wajib';
            if (double.tryParse(v) == null) return 'Angka';
            return null;
          },
          decoration: InputDecoration(
            filled: true,
            fillColor: _bg,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }

  // ── Preview Card ──
  Widget _buildPreviewCard() {
    final calories = double.tryParse(_caloriesController.text) ?? 0;
    final protein = double.tryParse(_proteinController.text) ?? 0;
    final carbs = double.tryParse(_carbsController.text) ?? 0;
    final fat = double.tryParse(_fatController.text) ?? 0;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _bg,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Preview', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(
            _nameController.text.isEmpty ? 'Nama bahan' : _nameController.text,
          ),
          const SizedBox(height: 6),
          Text('$calories kcal / 100g'),
          const SizedBox(height: 6),
          Row(
            children: [
              _macro('P', protein),
              _macro('K', carbs),
              _macro('L', fat),
            ],
          ),
        ],
      ),
    );
  }

  Widget _macro(String label, double value) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: _teal.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text('$label ${value.toStringAsFixed(0)}g'),
    );
  }

  // ── Submit Button ──
  Widget _buildSubmitButton() {
    return Container(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 12,
        bottom: MediaQuery.of(context).padding.bottom + 12,
      ),
      child: GestureDetector(
        onTap: _submit,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: _teal,
            borderRadius: BorderRadius.circular(16),
          ),
          alignment: Alignment.center,
          child: const Text(
            'Simpan Bahan',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final ingredient = IngredientModel(
      id: 0,
      name: _nameController.text,
      caloriesPer100g: double.parse(_caloriesController.text),
      protein: double.parse(_proteinController.text),
      carbs: double.parse(_carbsController.text),
      fat: double.parse(_fatController.text),
      portion: 100,
    );

    // 👉 nanti bisa kirim ke API atau ViewModel
    widget.viewModel.addSelectedFood(ingredient);

    Navigator.pop(context);
  }
}
