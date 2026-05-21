import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nutritrack/view/pages/profile_page.dart';

// ─── Model ───────────────────────────────────────────────────────────────────

class SkriningState {
  // Riwayat
  String? riwayatKeluarga;      
  String? pernahAsamUrat;       
  String? konsumsiPurin;        
  String? minumanManis;         

  // Gejala
  String? nyeriSendi;           
  String? bengkakSendi;         
  String? nyeriIbuJari;         
  String? beratBadan;           
  String? hipertensiGinjal;     
  String? alkohol;              
}

// ─── Page ─────────────────────────────────────────────────────────────────────

class SkriningAsamUratPage extends StatefulWidget {
  const SkriningAsamUratPage({super.key});

  @override
  State<SkriningAsamUratPage> createState() => _SkriningAsamUratPageState();
}

class _SkriningAsamUratPageState extends State<SkriningAsamUratPage> {
  final SkriningState _state = SkriningState();

  // ── Warna ──────────────────────────────────────────────────────────────────
static const Color _primary = Color(0xFF0D3D38);        // teal-deep
static const Color _primaryLight = Color(0xFF165F57);   // teal-mid
static const Color _accent = Color(0xFF23A18F);         // teal-accent
static const Color _surface = Color(0xFFF8FAFA);        // bg-card
static const Color _cardBg = Color(0xFFFFFFFF);         // white
static const Color _borderColor = Color(0xFFE2EBE9);    // border
static const Color _textPrimary = Color(0xFF1A2E2B);    // text-main
static const Color _textSecondary = Color(0xFF5E7E79);  // text-sub
static const Color _selectedBg = Color(0xFF1A8A7A);     // teal-btn
static const Color _selectedText = Color(0xFFFFFFFF);   // white
static const Color _unselectedBg = Color(0xFFFFFFFF);   // white
static const Color _unselectedText = Color(0xFF1F3330); // text-label

  // ── Build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _surface,
      appBar: _buildAppBar(),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  const SizedBox(height: 16),
                  _buildSectionCard(
                    title: 'Riwayat Medis & Keluarga',
                    children: [
                      _buildQuestion(
                      number: 1,
                      question:
                          'Apakah ada anggota keluarga inti yang memiliki riwayat asam urat?',
                      options: const ['Ya', 'Tidak', 'Tidak Tahu'],
                      selected: _state.riwayatKeluarga,
                      onSelected: (v) =>
                          setState(() => _state.riwayatKeluarga = v),
                    ),

                    const _SectionDivider(),

                    _buildQuestion(
                      number: 2,
                      question:
                          'Apakah Anda pernah didiagnosis memiliki kadar asam urat tinggi?',
                      options: const ['Pernah', 'Tidak Pernah'],
                      selected: _state.pernahAsamUrat,
                      onSelected: (v) =>
                          setState(() => _state.pernahAsamUrat = v),
                    ),
                  ],
                  ),
                  const SizedBox(height: 16),
                  _buildSectionCard(
                    title: 'Gejala yang Dirasakan (1 Bulan Terakhir)',
                    children: [
                    _buildQuestion(
                      number: 3,
                      question:
                          'Seberapa sering Anda mengonsumsi makanan tinggi purin (jeroan, seafood, daging merah)?',
                      options: const ['Jarang', 'Kadang', 'Sering'],
                      selected: _state.konsumsiPurin,
                      onSelected: (v) =>
                          setState(() => _state.konsumsiPurin = v),
                    ),

                    const _SectionDivider(),

                    _buildQuestion(
                      number: 4,
                      question:
                          'Apakah Anda sering mengonsumsi minuman manis atau bersoda?',
                      options: const ['Tidak', 'Kadang', 'Sering'],
                      selected: _state.minumanManis,
                      onSelected: (v) =>
                          setState(() => _state.minumanManis = v),
                    ),

                    const _SectionDivider(),

                    _buildQuestion(
                      number: 5,
                      question:
                          'Apakah Anda pernah mengalami nyeri sendi mendadak terutama malam hari?',
                      options: const ['Tidak', 'Kadang', 'Sering'],
                      selected: _state.nyeriSendi,
                      onSelected: (v) =>
                          setState(() => _state.nyeriSendi = v),
                    ),

                    const _SectionDivider(),

                    _buildQuestion(
                      number: 6,
                      question:
                          'Apakah sendi Anda pernah bengkak, merah, atau terasa panas?',
                      options: const ['Tidak', 'Kadang', 'Sering'],
                      selected: _state.bengkakSendi,
                      onSelected: (v) =>
                          setState(() => _state.bengkakSendi = v),
                    ),

                    const _SectionDivider(),

                    _buildQuestion(
                      number: 7,
                      question:
                          'Apakah nyeri sering terjadi pada ibu jari kaki?',
                      options: const ['Tidak', 'Kadang', 'Sering'],
                      selected: _state.nyeriIbuJari,
                      onSelected: (v) =>
                          setState(() => _state.nyeriIbuJari = v),
                    ),

                    const _SectionDivider(),

                    _buildQuestion(
                      number: 8,
                      question:
                          'Apakah Anda memiliki berat badan berlebih?',
                      options: const ['Ya', 'Tidak'],
                      selected: _state.beratBadan,
                      onSelected: (v) =>
                          setState(() => _state.beratBadan = v),
                    ),

                    const _SectionDivider(),

                    _buildQuestion(
                      number: 9,
                      question:
                          'Apakah Anda memiliki hipertensi atau gangguan ginjal?',
                      options: const ['Ya', 'Tidak'],
                      selected: _state.hipertensiGinjal,
                      onSelected: (v) =>
                          setState(() => _state.hipertensiGinjal = v),
                    ),

                    const _SectionDivider(),

                    _buildQuestion(
                      number: 10,
                      question:
                          'Apakah Anda mengonsumsi alkohol?',
                      options: const ['Tidak', 'Kadang', 'Sering'],
                      selected: _state.alkohol,
                      onSelected: (v) =>
                          setState(() => _state.alkohol = v),
                    ),
                    ],
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
          _buildBottomButton()
        ],
      ),
    );
  }

  // ── AppBar ─────────────────────────────────────────────────────────────────

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: _primary,
      foregroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
        onPressed: () => Navigator.maybePop(context),
      ),
      title: const Text(
        'Parameter Khusus',
        style: TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
      centerTitle: false,
    );
  }

  // ── Header ─────────────────────────────────────────────────────────────────

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
        colors: [Color(0xFF165F57), Color(0xFF1E7B6E)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: _primary.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.monitor_heart_rounded,
              color: Colors.white,
              size: 28,
            ),
          ),
          const SizedBox(width: 14),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Skrining Asam Urat',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Lengkapi data riwayat dan gejala klinis untuk mengetahui risiko asam urat dari luar faktor gizi.',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 12.5,
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

  // ── Section Card ───────────────────────────────────────────────────────────

  Widget _buildSectionCard({
    required String title,
    required List<Widget> children,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: _cardBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _borderColor, width: 1.2),
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
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFFEAF6F3),
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(13)),
              border: Border(
                bottom: BorderSide(color: _borderColor, width: 1),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 4,
                  height: 18,
                  decoration: BoxDecoration(
                    color: _primaryLight,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: _primary,
                  ),
                ),
              ],
            ),
          ),
          ...children,
        ],
      ),
    );
  }

  // ── Question ───────────────────────────────────────────────────────────────

  Widget _buildQuestion({
    required int number,
    required String question,
    required List<String> options,
    required String? selected,
    required ValueChanged<String> onSelected,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 22,
                height: 22,
                alignment: Alignment.center,
                margin: const EdgeInsets.only(top: 1, right: 8),
                decoration: BoxDecoration(
                  color: selected != null
                                ? _primary
                                  : Color(0xFFC8D8D6),
                  shape: BoxShape.circle,
                ),
                child: Text(
                  '$number',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: selected != null ? Colors.white : _primary,
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  question,
                  style: const TextStyle(
                    fontSize: 13.5,
                    height: 1.45,
                    color: _textPrimary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: options
                .map((opt) => _buildOptionChip(
                      label: opt,
                      isSelected: selected == opt,
                      onTap: () => onSelected(opt),
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }

  // ── Option Chip ────────────────────────────────────────────────────────────

  Widget _buildOptionChip({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? _selectedBg : _unselectedBg,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? _primary : _borderColor,
            width: isSelected ? 1.5 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: _primary.withOpacity(0.25),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  )
                ]
              : [],
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
            color: isSelected ? _selectedText : _unselectedText,
          ),
        ),
      ),
    );
  }

  // ── Bottom Button ──────────────────────────────────────────────────────────

  Widget _buildBottomButton() {
    final allAnswered =
    _state.riwayatKeluarga != null &&
    _state.pernahAsamUrat != null &&
    _state.konsumsiPurin != null &&
    _state.minumanManis != null &&
    _state.nyeriSendi != null &&
    _state.bengkakSendi != null &&
    _state.nyeriIbuJari != null &&
    _state.beratBadan != null &&
    _state.hipertensiGinjal != null &&
    _state.alkohol != null;

    return Container(
      padding: EdgeInsets.fromLTRB(
        16,
        12,
        16,
        12 + MediaQuery.of(context).padding.bottom,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFE0E0E0))),
      ),
      child: SizedBox(
        width: double.infinity,
        height: 50,
        child: ElevatedButton(
          onPressed: allAnswered ? _onHitungRisiko : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: _primary,
            disabledBackgroundColor: Color(0xFFC8D8D6),
            foregroundColor: Colors.white,
            disabledForegroundColor: Colors.white70,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: allAnswered ? 4 : 0,
            shadowColor: _primary.withOpacity(0.4),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.calculate_rounded, size: 20),
              const SizedBox(width: 8),
              const Text(
                'Simpan & Lanjut',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.3,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Handler ────────────────────────────────────────────────────────────────

  void _onHitungRisiko() {
    // Hitung skor sederhana
    int skor = 0;
    if (_state.riwayatKeluarga == 'Ya') skor += 2;
    if (_state.pernahAsamUrat == 'Pernah') skor += 3;
    if (_state.konsumsiPurin == 'Sering') skor += 2;
    if (_state.konsumsiPurin == 'Kadang') skor += 1;
    if (_state.minumanManis == 'Sering') skor += 2;
    if (_state.minumanManis == 'Kadang') skor += 1;
    if (_state.nyeriSendi == 'Sering') skor += 2;
    if (_state.nyeriSendi == 'Kadang') skor += 1;
    if (_state.bengkakSendi == 'Sering') skor += 2;
    if (_state.bengkakSendi == 'Kadang') skor += 1;
    if (_state.nyeriIbuJari == 'Sering') skor += 2;
    if (_state.nyeriIbuJari == 'Kadang') skor += 1;
    if (_state.beratBadan == 'Ya') skor += 1;
    if (_state.hipertensiGinjal == 'Ya') skor += 2;
    if (_state.alkohol == 'Sering') skor += 2;
    if (_state.alkohol == 'Kadang') skor += 1;
    
    String level;
    Color color;
    if (skor <= 4) {
    level = 'Risiko Rendah';
    color = Colors.green;
  } else if (skor <= 8) {
    level = 'Risiko Sedang';
    color = Colors.orange;
  } else {
    level = 'Risiko Tinggi';
    color = Colors.red;
  }

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => _ResultSheet(
      level: level,
      skor: skor,
      color: color,
      onNext: () => Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const ProfileScreen()), // sesuaikan nama class dashboard kamu
      ),
    ),
    );
  }
}

// ─── Section Divider ─────────────────────────────────────────────────────────

class _SectionDivider extends StatelessWidget {
  const _SectionDivider();

  @override
  Widget build(BuildContext context) {
    return const Divider(
    height: 1,
    thickness: 1,
    color: Color(0xFFD4E4E1),
    indent: 16,
    endIndent: 16,
    );
  }
}

// ─── Result Sheet ─────────────────────────────────────────────────────────────

class _ResultSheet extends StatelessWidget {
  final String level;
  final int skor;
  final Color color;
  final VoidCallback? onNext; 

  const _ResultSheet({
    required this.level,
    required this.skor,
    required this.color,
    this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              skor <= 3
                  ? Icons.check_circle_rounded
                  : skor <= 7
                      ? Icons.warning_rounded
                      : Icons.dangerous_rounded,
              color: color,
              size: 52,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            level,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 8),
Text(
  'Skor Skrining: $skor / 20',
  style: const TextStyle(
    fontSize: 14,
    color: Colors.grey,
  ),
),

const SizedBox(height: 12),

Text(
  skor <= 4
      ? 'Berdasarkan jawaban Anda, risiko asam urat Anda tergolong rendah. Tetap jaga pola hidup sehat.'
      : skor <= 8
          ? 'Anda memiliki beberapa faktor risiko asam urat. Disarankan untuk melakukan pemeriksaan kadar asam urat lebih lanjut.'
          : 'Anda memiliki risiko tinggi terkena asam urat. Segera konsultasikan dengan dokter untuk evaluasi dan penanganan lebih lanjut.',
    textAlign: TextAlign.center,
    style: const TextStyle(
    fontSize: 14,
    height: 1.5,
    color: Colors.black87,
  ),
),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
              Navigator.pop(context);
              onNext?.call();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1A8A7A),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Tutup', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}