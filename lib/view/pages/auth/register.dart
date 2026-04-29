import 'package:flutter/material.dart';
import 'package:nutritrack/core/api_service.dart';
import 'package:nutritrack/data/repository/auth_repository.dart';
import 'package:nutritrack/view/viewmodel/auth_viewmodel.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Daftar Akun',
      home: const RegisterScreen(), 
    );
  }
}

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  late final AuthViewModel viewModel;

  bool _showPassword = false;
  bool _showKonfirmasi = false;

  static const Color teal = Color(0xFF1AAA8A);
  static const Color tealDark = Color(0xFF178F77);

  @override
  void initState() {
    super.initState();
    viewModel = AuthViewModel(AuthRepository(ApiService()));
  }

  @override
  void dispose() {
    viewModel.nameController.dispose();
    viewModel.emailController.dispose();
    viewModel.usernameController.dispose();
    viewModel.passwordController.dispose();
    viewModel.passwordConfirmController.dispose();
    super.dispose();
  }

  void _handleSubmit() async {
    if (_formKey.currentState!.validate()) {
      try {
        await viewModel.register();
        if (viewModel.value.error != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Pendaftaran gagal: ${viewModel.value.error}'),
              backgroundColor: Colors.red,
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Pendaftaran berhasil!'),
              backgroundColor: teal,
            ),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _handleGoogle() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Lanjutkan dengan Google ditekan')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            child: Container(
              width: double.infinity,
              constraints: const BoxConstraints(maxWidth: 360),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(28),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 24,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 28),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Pill handle
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        margin: const EdgeInsets.only(bottom: 24),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE0E0E0),
                          borderRadius: BorderRadius.circular(99),
                        ),
                      ),
                    ),

                    // Title
                    const Text(
                      'Buat Akun',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF111111),
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Daftarkan diri Anda untuk mulai',
                      style: TextStyle(
                        fontSize: 13,
                        color: Color(0xFF9E9E9E),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Nama Lengkap
                    _buildField(
                      label: 'Nama Lengkap',
                      hint: 'Masukkan Nama Lengkap',
                      controller: viewModel.nameController,
                      validator: (v) =>
                          v == null || v.trim().isEmpty ? 'Nama tidak boleh kosong' : null,
                    ),

                    // Email
                    _buildField(
                      label: 'Email',
                      hint: 'Masukkan Email',
                      controller: viewModel.emailController,
                      keyboardType: TextInputType.emailAddress,
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) return 'Email tidak boleh kosong';

                        final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
                        if (!emailRegex.hasMatch(v)) return 'Format email tidak valid';
                        return null;
                      },
                    ),

                    // Username
                    _buildField(
                      label: 'Username',
                      hint: 'Masukkan Username',
                      controller: viewModel.usernameController,
                      validator: (v) =>
                          v == null || v.trim().isEmpty ? 'Username tidak boleh kosong' : null,
                    ),

                    // Kata Sandi
                    _buildPasswordField(
                      label: 'Kata Sandi',
                      hint: 'Masukkan Kata Sandi',
                      controller: viewModel.passwordController,
                      isVisible: _showPassword,
                      onToggle: () => setState(() => _showPassword = !_showPassword),
                      validator: (v) {
                        if (v == null || v.isEmpty) return 'Kata sandi tidak boleh kosong';
                        if (v.length < 6) return 'Minimal 6 karakter';
                        return null;
                      },
                    ),

                    // Konfirmasi Kata Sandi
                    _buildPasswordField(
                      label: 'Konfirmasi Kata Sandi',
                      hint: 'Masukkan Konfirmasi Kata Sandi',
                      controller: viewModel.passwordConfirmController,
                      isVisible: _showKonfirmasi,
                      onToggle: () => setState(() => _showKonfirmasi = !_showKonfirmasi),
                      validator: (v) {
                        if (v == null || v.isEmpty) return 'Konfirmasi tidak boleh kosong';
                        if (v != viewModel.passwordController.text) return 'Kata sandi tidak cocok';
                        return null;
                      },
                    ),

                    const SizedBox(height: 8),

                    // Tombol Masuk
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _handleSubmit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: teal,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          elevation: 0,
                        ),
                        child: const Text(
                          'Masuk',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.2,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Divider
                    Row(
                      children: const [
                        Expanded(child: Divider(color: Color(0xFFE0E0E0), thickness: 0.5)),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Text(
                            'Atau',
                            style: TextStyle(fontSize: 12, color: Color(0xFFBBBBBB)),
                          ),
                        ),
                        Expanded(child: Divider(color: Color(0xFFE0E0E0), thickness: 0.5)),
                      ],
                    ),

                    const SizedBox(height: 14),

                    // Tombol Google
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: _handleGoogle,
                        icon: _GoogleLogo(),
                        label: const Text(
                          'Lanjutkan dengan Google',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF333333),
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          backgroundColor: const Color(0xFFF5F5F3),
                          side: BorderSide.none,
                          padding: const EdgeInsets.symmetric(vertical: 13),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 18),

                    // Footer
                    Center(
                      child: RichText(
                        text: TextSpan(
                          style: const TextStyle(fontSize: 12.5, color: Color(0xFFAAAAAA)),
                          children: [
                            const TextSpan(text: 'Sudah punya akun? '),
                            WidgetSpan(
                              child: GestureDetector(
                                onTap: () {
                                  // Navigasi ke halaman login
                                },
                                child: const Text(
                                  'Masuk',
                                  style: TextStyle(
                                    fontSize: 12.5,
                                    color: teal,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
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

  Widget _buildField({
    required String label,
    required String hint,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Color(0xFF444444),
              letterSpacing: 0.1,
            ),
          ),
          const SizedBox(height: 6),
          TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            validator: validator,
            style: const TextStyle(fontSize: 13, color: Color(0xFF333333)),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(fontSize: 13, color: Color(0xFFAAAAAA)),
              filled: true,
              fillColor: const Color(0xFFF5F5F3),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.redAccent, width: 1),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.redAccent, width: 1),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPasswordField({
    required String label,
    required String hint,
    required TextEditingController controller,
    required bool isVisible,
    required VoidCallback onToggle,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Color(0xFF444444),
              letterSpacing: 0.1,
            ),
          ),
          const SizedBox(height: 6),
          TextFormField(
            controller: controller,
            obscureText: !isVisible,
            validator: validator,
            style: const TextStyle(fontSize: 13, color: Color(0xFF333333)),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(fontSize: 13, color: Color(0xFFAAAAAA)),
              filled: true,
              fillColor: const Color(0xFFF5F5F3),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.redAccent, width: 1),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.redAccent, width: 1),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              suffixIcon: GestureDetector(
                onTap: onToggle,
                child: Icon(
                  isVisible ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                  size: 18,
                  color: isVisible ? const Color(0xFF1AAA8A) : const Color(0xFFBBBBBB),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Widget logo Google dengan SVG warna asli
class _GoogleLogo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 18,
      height: 18,
      child: CustomPaint(painter: _GoogleLogoPainter()),
    );
  }
}

class _GoogleLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final double w = size.width;
    final double h = size.height;

    final paintBlue = Paint()..color = const Color(0xFF4285F4);
    final paintGreen = Paint()..color = const Color(0xFF34A853);
    final paintYellow = Paint()..color = const Color(0xFFFBBC05);
    final paintRed = Paint()..color = const Color(0xFFEA4335);

    // Blue path (top-right)
    final pathBlue = Path()
      ..moveTo(w * 0.940, h * 0.510)
      ..lineTo(w * 0.500, h * 0.510)
      ..lineTo(w * 0.500, h * 0.688)
      ..lineTo(w * 0.747, h * 0.688)
      ..cubicTo(w * 0.636, h * 0.860, w * 0.387, h * 0.958, w * 0.042, h * 0.792)
      ..lineTo(w * 0.042, h * 0.500)
      ..cubicTo(w * 0.167, h * 0.229, w * 0.479, h * 0.042, w * 0.500, h * 0.042)
      ..cubicTo(w * 0.640, h * 0.042, w * 0.768, h * 0.094, w * 0.867, h * 0.177)
      ..lineTo(w * 0.999, h * 0.045)
      ..cubicTo(w * 0.894, h * 0.049, w * 0.727, h * 0.000, w * 0.500, h * 0.000)
      ..cubicTo(w * 0.292, h * 0.000, w * 0.104, h * 0.083, w * 0.000, h * 0.232)
      ..close();

    // Draw simplified colored blocks instead for clarity
    // Blue (top-right quadrant area)
    final rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, w, h),
      Radius.circular(w * 0.1),
    );

    // Simple 4-color quadrant representation
    final bluePaint = Paint()..color = const Color(0xFF4285F4);
    final greenPaint = Paint()..color = const Color(0xFF34A853);
    final yellowPaint = Paint()..color = const Color(0xFFFBBC05);
    final redPaint = Paint()..color = const Color(0xFFEA4335);

    canvas.save();
    canvas.clipRRect(rrect);

    // Top-right blue
    canvas.drawRect(Rect.fromLTWH(w * 0.5, 0, w * 0.5, h * 0.5), bluePaint);
    // Bottom-right green
    canvas.drawRect(Rect.fromLTWH(w * 0.5, h * 0.5, w * 0.5, h * 0.5), greenPaint);
    // Bottom-left yellow
    canvas.drawRect(Rect.fromLTWH(0, h * 0.5, w * 0.5, h * 0.5), yellowPaint);
    // Top-left red
    canvas.drawRect(Rect.fromLTWH(0, 0, w * 0.5, h * 0.5), redPaint);

    // White center circle
    canvas.drawCircle(
      Offset(w * 0.5, h * 0.5),
      w * 0.28,
      Paint()..color = Colors.white,
    );

    // Colored dot in center (G shape simplified)
    canvas.drawCircle(
      Offset(w * 0.5, h * 0.5),
      w * 0.18,
      bluePaint,
    );

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}