import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nutritrack/view/pages/skriningdiabetes_page.dart';


// ─── Model ───────────────────────────────────────────────────────────────────

class SkriningState {
  // Riwayat medis & keluarga
  String? riwayatKeluarga;     // Ya | Tidak | Tidak Tahu
  String? hipertensi;          // Pernah | Tidak Pernah
  String? kolesterol;          // Pernah | Tidak Pernah
  String? riwayatDiabetes;     // Ya | Tidak

  // Gejala
  String? nyeriDada;           // Tidak | Kadang | Sering
  String? sesakNapas;          // Tidak | Kadang | Sering
  String? jantungBerdebar;     // Tidak | Kadang | Sering
  String? cepatLelah;          // Tidak | Kadang | Sering
  String? pusing;              // Tidak | Kadang | Sering
  String? kakiBengkak;         // Ya | Tidak
}

// ─── Page ─────────────────────────────────────────────────────────────────────

class SkriningJantungPage extends StatefulWidget {
  const SkriningJantungPage({super.key});

  @override
  State<SkriningJantungPage> createState() => _SkriningJantungPageState();
}

class _SkriningJantungPageState extends State<SkriningJantungPage> {
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
                            'Apakah ada anggota keluarga inti (orang tua atau saudara kandung) yang memiliki riwayat penyakit jantung?',
                        options: const ['Ya', 'Tidak', 'Tidak Tahu'],
                        selected: _state.riwayatKeluarga,
                        onSelected: (v) =>
                            setState(() => _state.riwayatKeluarga = v),
                      ),

                      const _SectionDivider(),

                      _buildQuestion(
                        number: 2,
                        question:
                            'Apakah Anda pernah didiagnosis memiliki tekanan darah tinggi (hipertensi)?',
                        options: const ['Pernah', 'Tidak Pernah'],
                        selected: _state.hipertensi,
                        onSelected: (v) =>
                        setState(() => _state.hipertensi = v),                        
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
                            'Apakah Anda pernah didiagnosis memiliki kolesterol tinggi?',
                        options: const ['Pernah', 'Tidak Pernah'],
                        selected: _state.kolesterol,
                        onSelected: (v) =>
                        setState(() => _state.kolesterol = v),
                      ),
                      const _SectionDivider(),
                      _buildQuestion(
                        number: 4,
                        question:
                            'Apakah Anda memiliki riwayat diabetes atau gula darah tinggi?',
                        options: const ['Ya', 'Tidak'],
                       selected: _state.riwayatDiabetes,
                        onSelected: (v) =>
                            setState(() => _state.riwayatDiabetes = v),
                      ),
                      const _SectionDivider(),
                      _buildQuestion(
                        number: 5,
                        question:
                            'Apakah Anda pernah merasakan nyeri, tekanan, atau rasa tidak nyaman di dada?',
                        options: const ['Tidak', 'Kadang', 'Sering'],
                        selected: _state.nyeriDada,
                        onSelected: (v) =>
                            setState(() => _state.nyeriDada = v),
                      ),
                      const _SectionDivider(),
                      _buildQuestion(
                        number: 6,
                        question:
                            'Apakah Anda mudah merasa sesak napas saat aktivitas ringan?',
                        options: const ['Tidak', 'Kadang', 'Sering'],
                        selected: _state.sesakNapas,
                        onSelected: (v) =>
                            setState(() => _state.sesakNapas = v),
                      ),
                      const _SectionDivider(),
                      _buildQuestion(
                        number: 7,
                        question:
                            'Apakah Anda sering merasakan jantung berdebar atau detak jantung tidak teratur?',
                        options: const ['Tidak', 'Kadang', 'Sering'],
                        selected: _state.jantungBerdebar,
                        onSelected: (v) =>
                            setState(() => _state.jantungBerdebar = v),
                      ),
                      const _SectionDivider(),
                      _buildQuestion(
                        number: 8,
                        question:
                            'Apakah Anda sering merasa cepat lelah meskipun melakukan aktivitas ringan?',
                        options: const ['Tidak', 'Kadang', 'Sering'],
                        selected: _state.cepatLelah,
                        onSelected: (v) =>
                            setState(() => _state.cepatLelah = v),
                      ),
                      const _SectionDivider(),
                      _buildQuestion(
                        number: 9,
                        question:
                            'Apakah Anda pernah mengalami pusing atau hampir pingsan secara tiba-tiba?',
                        options: const ['Tidak', 'Kadang', 'Sering'],
                        selected: _state.pusing,
                        onSelected: (v) =>
                            setState(() => _state.pusing = v),                     
                      ),
                      const _SectionDivider(),
                      _buildQuestion(
                        number: 10,
                        question:
                            'Apakah kaki atau pergelangan kaki Anda sering tampak bengkak?',
                        options: const ['Ya', 'Tidak'],
                        selected: _state.kakiBengkak,
                        onSelected: (v) =>
                            setState(() => _state.kakiBengkak = v),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
          _buildBottomButton(),
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
      automaticallyImplyLeading: false, 
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
                  'Skrining Jantung',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Lengkapi data riwayat dan gejala klinis untuk mengetahui risiko jantung dari luar faktor gizi.',
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
    _state.hipertensi != null &&
    _state.kolesterol != null &&
    _state.riwayatDiabetes != null &&
    _state.nyeriDada != null &&
    _state.sesakNapas != null &&
    _state.jantungBerdebar != null &&
    _state.cepatLelah != null &&
    _state.pusing != null &&
    _state.kakiBengkak != null;

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
    if (_state.hipertensi == 'Pernah') skor += 3;
    if (_state.kolesterol == 'Pernah') skor += 2;
    if (_state.riwayatDiabetes == 'Ya') skor += 2;
    if (_state.nyeriDada == 'Sering') skor += 2;
    if (_state.nyeriDada == 'Kadang') skor += 1;
    if (_state.sesakNapas == 'Sering') skor += 2;
    if (_state.sesakNapas == 'Kadang') skor += 1;
    if (_state.jantungBerdebar == 'Sering') skor += 2;
    if (_state.jantungBerdebar == 'Kadang') skor += 1;
    if (_state.cepatLelah == 'Sering') skor += 2;
    if (_state.cepatLelah == 'Kadang') skor += 1;
    if (_state.pusing == 'Sering') skor += 2;
    if (_state.pusing == 'Kadang') skor += 1;
    if (_state.kakiBengkak == 'Ya') skor += 2;
    String level;
    Color color;
    if (skor <= 3) {
      level = 'Risiko Rendah';
      color = Colors.green;
    } else if (skor <= 7) {
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
    MaterialPageRoute(builder: (_) => const SkriningDiabetesPage()),
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
            'Skor Skrining: $skor / 21',
            style: const TextStyle(fontSize: 14, color: Colors.grey),
          ),
          const SizedBox(height: 12),
          Text(
            skor <= 3
                ? 'Berdasarkan jawaban Anda, risiko jantung Anda tergolong rendah. Tetap jaga pola hidup sehat.'
                : skor <= 7
                    ? 'Anda memiliki beberapa faktor risiko. Disarankan untuk melakukan pemeriksaan lebih lanjut.'
                    : 'Anda memiliki risiko tinggi. Segera konsultasikan dengan dokter untuk pemeriksaan lanjutan.',
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 14, height: 1.5, color: Colors.black87),
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