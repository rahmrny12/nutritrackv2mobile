import 'package:flutter/material.dart';

class AddMealPage extends StatefulWidget {
  const AddMealPage({super.key});
  @override
  State<AddMealPage> createState() => _AddMealPageState();
}

class _AddMealPageState extends State<AddMealPage> {
  static const Color _teal = Color(0xFF2ABFB0);

  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _deskripsiController = TextEditingController();
  int _selectedCategory = 0;
  bool _isFavorit = true;

  final List<String> _categories = ['Sarapan', 'Makan Siang', 'Makan Malam'];
  final List<IconData> _categoryIcons = [
    Icons.wb_sunny_outlined,
    Icons.wb_cloudy_outlined,
    Icons.nights_stay_outlined,
  ];

  final List<Map<String, dynamic>> _bahanList = [
    {
      'name': 'Dada Ayam Tanpa Kulit',
      'kcal': 165,
      'protein': '31g',
      'karbo': '0g',
      'gram': 150,
    },
    {
      'name': 'Bayam Hijau Segar',
      'kcal': 23,
      'protein': '3g',
      'karbo': '3g',
      'gram': 100,
    },
    {
      'name': 'Beras Shirataki',
      'kcal': 15,
      'protein': '1g',
      'karbo': '3g',
      'gram': 120,
    },
  ];

  int get _totalKcal =>
      _bahanList.fold(0, (sum, b) => sum + (b['kcal'] as int));

  void _removeBahan(int index) {
    setState(() => _bahanList.removeAt(index));
  }

  @override
  void dispose() {
    _namaController.dispose();
    _deskripsiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                  _buildPhotoUpload(),
                  _buildFormSection(),
                  _buildBahanMakanan(),
                  const SizedBox(height: 16),
                  _buildNutritionSummary(),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
          _buildSimpanButton(),
        ],
      ),
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
                  child: const Icon(Icons.arrow_back,
                      size: 18, color: Color(0xFF333333)),
                ),
              ),
              const Expanded(
                child: Center(
                  child: Text(
                    'Tambah Menu Baru',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1A1A1A)),
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
                  child: const Icon(Icons.more_vert,
                      size: 18, color: Color(0xFF333333)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Photo Upload ─────────────────────────
  Widget _buildPhotoUpload() {
    return GestureDetector(
      onTap: () {},
      child: Container(
        color: Colors.white,
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 28),
        child: Column(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: const Color(0xFFF2F2F2),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(Icons.camera_alt_outlined,
                  color: Color(0xFF999999), size: 26),
            ),
            const SizedBox(height: 10),
            const Text(
              'Tambahkan Foto Sampul Resep',
              style: TextStyle(
                  fontSize: 13,
                  color: Color(0xFF666666),
                  fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }

  // ── Form Section ─────────────────────────
  Widget _buildFormSection() {
    return Container(
      color: Colors.white,
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Nama Resep
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              RichText(
                text: const TextSpan(
                  text: 'Nama Resep ',
                  style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1A1A1A)),
                  children: [
                    TextSpan(
                      text: '*',
                      style: TextStyle(color: Colors.red),
                    ),
                  ],
                ),
              ),
              const Text('Maks 50 kar',
                  style:
                      TextStyle(fontSize: 11, color: Color(0xFFBBBBBB))),
            ],
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _namaController,
            style: const TextStyle(fontSize: 13, color: Color(0xFF1A1A1A)),
            decoration: InputDecoration(
              hintText: 'Contoh: Nasi Goreng Shirataki',
              hintStyle: const TextStyle(
                  fontSize: 13, color: Color(0xFFCCCCCC)),
              filled: true,
              fillColor: const Color(0xFFF8F9FA),
              contentPadding: const EdgeInsets.symmetric(
                  horizontal: 14, vertical: 12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFFE8E8E8)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFFE8E8E8)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide:
                    const BorderSide(color: Color(0xFF2ABFB0), width: 1.5),
              ),
            ),
          ),
          const SizedBox(height: 18),

          // Deskripsi
          const Text('Deskripsi Singkat',
              style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1A1A1A))),
          const SizedBox(height: 8),
          TextField(
            controller: _deskripsiController,
            maxLines: 3,
            style: const TextStyle(fontSize: 13, color: Color(0xFF1A1A1A)),
            decoration: InputDecoration(
              hintText:
                  'Ceritakan sedikit tentang keunikan atau manfaat kesehatan dari resep ini...',
              hintStyle: const TextStyle(
                  fontSize: 12, color: Color(0xFFCCCCCC)),
              filled: true,
              fillColor: const Color(0xFFF8F9FA),
              contentPadding: const EdgeInsets.symmetric(
                  horizontal: 14, vertical: 12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFFE8E8E8)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFFE8E8E8)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide:
                    const BorderSide(color: Color(0xFF2ABFB0), width: 1.5),
              ),
            ),
          ),
          const SizedBox(height: 18),

          // Kategori Makanan
          const Text('Kategori Menu',
              style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1A1A1A))),
          const SizedBox(height: 10),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(_categories.length, (index) {
                final isSelected = _selectedCategory == index;
                return GestureDetector(
                  onTap: () =>
                      setState(() => _selectedCategory = index),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected ? _teal : Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isSelected
                            ? _teal
                            : const Color(0xFFE0E0E0),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(_categoryIcons[index],
                            size: 14,
                            color: isSelected
                                ? Colors.white
                                : const Color(0xFF666666)),
                        const SizedBox(width: 6),
                        Text(
                          _categories[index],
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: isSelected
                                  ? Colors.white
                                  : const Color(0xFF666666)),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
          const SizedBox(height: 18),

          // Tandai Favorit
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text('Tandai sebagai Favorit',
                        style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF1A1A1A))),
                    SizedBox(height: 2),
                    Text('Simpan resep ini ke daftar akses cepat',
                        style: TextStyle(
                            fontSize: 11, color: Color(0xFF999999))),
                  ],
                ),
              ),
              Switch(
                value: _isFavorit,
                onChanged: (v) => setState(() => _isFavorit = v),
                activeColor: _teal,
                activeTrackColor: _teal.withOpacity(0.3),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── Bahan Makanan ────────────────────────
  Widget _buildBahanMakanan() {
    return Container(
      color: Colors.white,
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Bahan Makanan',
                  style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1A1A1A))),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 18, vertical: 6),
                decoration: BoxDecoration(
                  color: _teal,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '$_totalKcal kcal',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      height: 1.2),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          const Text('Tambahkan dan atur sesuai takaran (gram)',
              style:
                  TextStyle(fontSize: 11, color: Color(0xFF999999))),
          const SizedBox(height: 16),

          // Bahan items
          ...List.generate(_bahanList.length, (index) {
            return _buildBahanItem(index);
          }),

          const SizedBox(height: 4),

          // Tambah Bahan button
          GestureDetector(
            onTap: () {},
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 13),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: _teal,
                  width: 1.5,
                  style: BorderStyle.solid,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.add, color: _teal, size: 16),
                  SizedBox(width: 6),
                  Text('Tambah Bahan Makanan',
                      style: TextStyle(
                          fontSize: 13,
                          color: _teal,
                          fontWeight: FontWeight.w600)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBahanItem(int index) {
    final bahan = _bahanList[index];
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFEEEEEE)),
      ),
      child: Row(
        children: [
          // Food icon circle
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFFE8E8E8)),
            ),
            alignment: Alignment.center,
            child: Text(
              index == 0
                  ? '🍗'
                  : index == 1
                      ? '🥬'
                      : '🍚',
              style: const TextStyle(fontSize: 20),
            ),
          ),
          const SizedBox(width: 10),
          // Name & nutrition
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(bahan['name'],
                    style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1A1A1A))),
                const SizedBox(height: 3),
                Row(
                  children: [
                    Text('${bahan['kcal']} kcal',
                        style: const TextStyle(
                            fontSize: 11, color: Color(0xFF999999))),
                    const SizedBox(width: 6),
                    _NutriBadge(
                        label: 'Protein ${bahan['protein']}',
                        color: _teal),
                    const SizedBox(width: 4),
                    _NutriBadge(
                        label: 'Karbo ${bahan['karbo']}',
                        color: const Color(0xFFFF9500)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          // Gram input
          Container(
            width: 52,
            height: 36,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFFE0E0E0)),
            ),
            alignment: Alignment.center,
            child: Text('${bahan['gram']} g',
                style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF333333))),
          ),
          const SizedBox(width: 8),
          // Delete button
          GestureDetector(
            onTap: () => _removeBahan(index),
            child: Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.close,
                  color: Colors.red, size: 16),
            ),
          ),
        ],
      ),
    );
  }

  // ── Nutrition Summary ────────────────────
  Widget _buildNutritionSummary() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFEEEEEE)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _SummaryItem(
              value: '$_totalKcal',
              label: 'Kcal',
              dotColor: Colors.transparent,
              showDot: false),
          _SummaryItem(
              value: '38g',
              label: '● Protein',
              dotColor: _teal,
              showDot: true),
          _SummaryItem(
              value: '24g',
              label: '● Karbo',
              dotColor: const Color(0xFFFF9500),
              showDot: true),
          _SummaryItem(
              value: '8g',
              label: '● Lemak',
              dotColor: const Color(0xFFFF6B6B),
              showDot: true),
        ],
      ),
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
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.bookmark_outline,
                    color: Colors.white, size: 18),
                SizedBox(width: 8),
                Text(
                  'Simpan Resep Kustom',
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ── Helper Widgets ───────────────────────

class _NutriBadge extends StatelessWidget {
  final String label;
  final Color color;
  const _NutriBadge({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(label,
          style: TextStyle(
              fontSize: 10,
              color: color,
              fontWeight: FontWeight.w600)),
    );
  }
}

class _SummaryItem extends StatelessWidget {
  final String value;
  final String label;
  final Color dotColor;
  final bool showDot;
  const _SummaryItem(
      {required this.value,
      required this.label,
      required this.dotColor,
      required this.showDot});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(value,
            style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1A1A1A))),
        const SizedBox(height: 2),
        Row(
          children: [
            if (showDot) ...[
              Container(
                width: 7,
                height: 7,
                decoration:
                    BoxDecoration(color: dotColor, shape: BoxShape.circle),
              ),
              const SizedBox(width: 4),
            ],
            Text(
              showDot ? label.substring(2) : label,
              style: const TextStyle(
                  fontSize: 10, color: Color(0xFF999999)),
            ),
          ],
        ),
      ],
    );
  }
}