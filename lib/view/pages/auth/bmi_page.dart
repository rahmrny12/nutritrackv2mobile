import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nutritrack/view/pages/dashboard_page.dart';

class BMIPage extends StatefulWidget {
  const BMIPage({super.key});

  @override
  State<BMIPage> createState() => _BMIPageState();
}

class _BMIPageState extends State<BMIPage> {
  final _bbController     = TextEditingController();
  final _tbController     = TextEditingController();
  final _usiaController   = TextEditingController();
  final _lingkarController   = TextEditingController();
  String _selectedGender  = 'laki';

  @override
  void dispose() {
    _bbController.dispose();
    _tbController.dispose();
    _usiaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // ── HEADER ──
          _buildHeader(0.0),

          // ── FORM CARD ──
          Expanded(
            child: Container(
              width: double.infinity,
              color: const Color(0xFFF8FAFA),
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(22, 16, 22, 36),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // drag handle
                    Center(
                      child: Container(
                        width: 38,
                        height: 4,
                        margin: const EdgeInsets.only(bottom: 24),
                        decoration: BoxDecoration(
                          color: const Color(0xFFD4E4E1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                    // Berat & Tinggi Badan
                    Row(
                    children: [
                      Expanded(
                        child: _buildField(
                          label: 'Berat Badan',
                          hint: 'Masukkan BB',
                          controller: _bbController,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildField(
                          label: 'Tinggi Badan',
                          hint: 'Masukkan TB',
                          controller: _tbController,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                    Row(
                    children: [
                      Expanded(
                        child: _buildField(
                          label: 'Lingkar Pinggang',
                          hint: 'Masukkan Lingkar Pinggang',
                          controller: _lingkarController,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildField(
                          label: 'Usia',
                          hint: 'Masukkan Usia',
                          controller: _usiaController,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                    // Jenis Kelamin
                    _buildGenderField(),
                    const SizedBox(height: 28),

                    // Tombol Masuk
                    _buildMasukButton(),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── HEADER ──────────────────────────────────────────────
  Widget _buildHeader(double progress) {
  return Container(
    width: double.infinity,
    height: 260, 
    decoration: const BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color(0xFF0D3D38),
          Color(0xFF165F57),
          Color(0xFF1E7B6E),
          ],
          stops: [0.0, 0.5, 1.0],
        ),
      ),
      child: Stack(
      children: [
        SafeArea(
          child: Align(
            alignment: Alignment(0, -0.1 - (progress * 0.9)),
            child: Transform.scale(
              scale: 1 - (progress * 0.25),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // 🔥 Animated Logo
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 400),
                    transitionBuilder: (child, animation) {
                      return FadeTransition(
                        opacity: animation,
                        child: ScaleTransition(
                          scale: animation,
                          child: child,
                        ),
                      );
                    },
                    child: progress < 0.6
                        ? Image.asset(
                            "assets/images/logo_nutritrack.png",
                            key: const ValueKey("logo_vertical"),
                            height: 160,
                          )
                        : Image.asset(
                            "assets/images/logo_nutritrack_horizontal.png",
                            key: const ValueKey("logo_horizontal"),
                            height: 70,
                          ),
                  ),

                  const SizedBox(height: 16),

                  // 🔥 Tagline
                  Opacity(
                    opacity: 1 - progress,
                    child: const Text(
                      "Hidup Sehat\nMulai dari —\nGizi yang Tepat",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

  // ── INPUT FIELD ─────────────────────────────────────────
  Widget _buildField({
  required String label,
  required String hint,
  required TextEditingController controller,
  TextInputType keyboardType = TextInputType.text,
  List<TextInputFormatter>? inputFormatters, 
})  {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 13.5,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1F3330),
          ),
        ),
        const SizedBox(height: 7),
        TextField(
        controller: controller,
        keyboardType: keyboardType,
        inputFormatters: inputFormatters,
          style: const TextStyle(
            fontSize: 14,
            color: Color(0xFF1A2E2B),
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(
              color: Color(0xFFA8BFBB),
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
            filled: true,
            fillColor: const Color(0xFFF1F5F4),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 14,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                color: Colors.transparent,
                width: 1.5,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                color: Color(0xFF23A18F),
                width: 1.5,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ── JENIS KELAMIN ────────────────────────────────────────
  Widget _buildGenderField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Jenis Kelamin',
          style: TextStyle(
            fontSize: 13.5,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1F3330),
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            _buildRadioOption(label: 'Laki-laki', value: 'laki'),
            const SizedBox(width: 24),
            _buildRadioOption(label: 'Perempuan', value: 'perempuan'),
          ],
        ),
      ],
    );
  }

  Widget _buildRadioOption({
    required String label,
    required String value,
  }) {
    final bool isSelected = _selectedGender == value;
    return GestureDetector(
      onTap: () => setState(() => _selectedGender = value),
      child: Row(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            width: 22,
            height: 22,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isSelected
                  ? const Color(0xFF2BAA97)
                  : Colors.transparent,
              border: Border.all(
                color: isSelected
                    ? const Color(0xFF2BAA97)
                    : const Color(0xFFC8D8D6),
                width: 2,
              ),
            ),
            child: isSelected
                ? const Center(
                    child: CircleAvatar(
                      radius: 5,
                      backgroundColor: Colors.white,
                    ),
                  )
                : null,
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: isSelected
                  ? const Color(0xFF1A2E2B)
                  : const Color(0xFF5E7E79),
            ),
          ),
        ],
      ),
    );
  }

  // ── TOMBOL MASUK ─────────────────────────────────────────
  Widget _buildMasukButton() {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF165F57), Color(0xFF23A18F)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF1E7B6E).withOpacity(0.35),
              blurRadius: 18,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: ElevatedButton(
          onPressed: () {
          // 1. Cek dulu input
          if (_bbController.text.isEmpty ||
              _tbController.text.isEmpty ||
              _usiaController.text.isEmpty ||
              _lingkarController.text.isEmpty) {

            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Isi semua data dulu ya')),
            );
            return;
          }

          // 2. Kalau sudah diisi → pindah halaman
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DashboardPage(),
            ),
          );
        },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: const Text(
            'Submit',
            style: TextStyle(
              fontSize: 15.5,
              fontWeight: FontWeight.w700,
              color: Colors.white,
              letterSpacing: 0.2,
            ),
          ),
        ),
      ),
    );
  }

  // ── DIVIDER ATAU ─────────────────────────────────────────
  Widget _buildDivider() {
    return Row(
      children: [
        const Expanded(
          child: Divider(color: Color(0xFFD4E4E1), thickness: 1),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            'Atau',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Colors.grey[400],
            ),
          ),
        ),
        const Expanded(
          child: Divider(color: Color(0xFFD4E4E1), thickness: 1),
        ),
      ],
    );
  }

  // ── TOMBOL GOOGLE ────────────────────────────────────────
  Widget _buildGoogleButton() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: OutlinedButton(
        onPressed: () {
          // TODO: handle Google login
        },
        style: OutlinedButton.styleFrom(
          backgroundColor: Colors.white,
          side: const BorderSide(color: Color(0xFFE2EBE9), width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Google G icon (inline painter)
            CustomPaint(
              size: const Size(20, 20),
              painter: _GoogleIconPainter(),
            ),
            const SizedBox(width: 10),
            const Text(
              'Lanjutkan dengan Google',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1A2E2B),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── FOOTER ───────────────────────────────────────────────
  Widget _buildFooter() {
    return Center(
      child: RichText(
        text: const TextSpan(
          style: TextStyle(
            fontSize: 13.5,
            fontWeight: FontWeight.w500,
            color: Color(0xFF5E7E79),
          ),
          children: [
            TextSpan(text: 'Sudah punya akun? '),
            TextSpan(
              text: 'Login',
              style: TextStyle(
                color: Color(0xFF23A18F),
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── LOGO PAINTER ─────────────────────────────────────────────
class _LogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.2
      ..strokeCap = StrokeCap.round;

    final cx = size.width / 2;
    final cy = size.height / 2;

    // outer circle
    canvas.drawCircle(Offset(cx, cy), size.width * 0.44, paint);
    // inner circle
    canvas.drawCircle(Offset(cx, cy), size.width * 0.22, paint);

    // crosshair lines
    canvas.drawLine(Offset(0, cy), Offset(size.width * 0.30, cy), paint);
    canvas.drawLine(Offset(size.width * 0.70, cy), Offset(size.width, cy), paint);
    canvas.drawLine(Offset(cx, 0), Offset(cx, size.height * 0.30), paint);
    canvas.drawLine(Offset(cx, size.height * 0.70), Offset(cx, size.height), paint);

    // leaf/stem
    final leafPaint = Paint()
      ..color = Colors.white.withOpacity(0.9)
      ..style = PaintingStyle.fill;

    final leafPath = Path()
      ..moveTo(cx, size.height * 0.06)
      ..quadraticBezierTo(cx + 7, 0, cx + 12, size.height * 0.05)
      ..quadraticBezierTo(cx + 8, size.height * 0.16, cx, size.height * 0.06)
      ..close();

    canvas.drawPath(leafPath, leafPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ── GOOGLE ICON PAINTER ───────────────────────────────────────
class _GoogleIconPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Blue part (right arc)
    final bluePaint = Paint()..color = const Color(0xFF1976D2);
    final bluePath = Path()
      ..moveTo(w * 0.91, h * 0.42)
      ..lineTo(w * 0.875, h * 0.42)
      ..lineTo(w * 0.875, h * 0.5)
      ..lineTo(w, h * 0.5)
      ..arcTo(
        Rect.fromLTWH(0, 0, w, h),
        -0.35,
        0.7,
        false,
      );
    // Use simpler colored circles approach
    _drawG(canvas, size);
  }

  void _drawG(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final cx = w / 2;
    final cy = h / 2;
    final r  = w / 2;

    // Red (top-left)
    final redPaint = Paint()..color = const Color(0xFFEA4335);
    final redPath  = Path()
      ..moveTo(cx, cy)
      ..arcTo(Rect.fromCircle(center: Offset(cx, cy), radius: r),
          _deg(225), _deg(90), false)
      ..close();
    canvas.drawPath(redPath, redPaint);

    // Yellow (top-right)
    final yellowPaint = Paint()..color = const Color(0xFFFBBC05);
    final yellowPath  = Path()
      ..moveTo(cx, cy)
      ..arcTo(Rect.fromCircle(center: Offset(cx, cy), radius: r),
          _deg(315), _deg(90), false)
      ..close();
    canvas.drawPath(yellowPath, yellowPaint);

    // Green (bottom-right)
    final greenPaint = Paint()..color = const Color(0xFF34A853);
    final greenPath  = Path()
      ..moveTo(cx, cy)
      ..arcTo(Rect.fromCircle(center: Offset(cx, cy), radius: r),
          _deg(45), _deg(90), false)
      ..close();
    canvas.drawPath(greenPath, greenPaint);

    // Blue (bottom-left)
    final bluePaint = Paint()..color = const Color(0xFF4285F4);
    final bluePath  = Path()
      ..moveTo(cx, cy)
      ..arcTo(Rect.fromCircle(center: Offset(cx, cy), radius: r),
          _deg(135), _deg(90), false)
      ..close();
    canvas.drawPath(bluePath, bluePaint);

    // White center + G cutout
    final whitePaint = Paint()..color = Colors.white;
    canvas.drawCircle(Offset(cx, cy), r * 0.6, whitePaint);

    // G bar (blue rectangle on right side)
    final gPaint = Paint()..color = const Color(0xFF4285F4);
    canvas.drawRect(
      Rect.fromLTWH(cx, cy - r * 0.13, r * 0.95, r * 0.26),
      gPaint,
    );
  }

  double _deg(double deg) => deg * 3.14159265 / 180;

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}