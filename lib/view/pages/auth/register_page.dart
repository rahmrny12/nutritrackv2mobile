import 'package:flutter/material.dart';
import 'package:nutritrack/core/api_service.dart';
import 'package:nutritrack/core/route_generator.dart';
import 'package:nutritrack/data/repository/auth_repository.dart';
import 'package:nutritrack/view/viewmodel/auth_viewmodel.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
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

          Navigator.pushNamed(context, Routes.auth);
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
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
      backgroundColor: const Color(0xFFF5F5F5), // biar beda dari card
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(
                20,
              ), // lebih kecil biar natural
            ),
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // TITLE
                  const Text(
                    'Registrasi',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF111111),
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Buat akun baru untuk mulai melacak nutrisi harianmu',
                    style: TextStyle(fontSize: 13, color: Color(0xFF9E9E9E)),
                  ),
                  const SizedBox(height: 24),

                  // Nama
                  _buildField(
                    label: 'Nama Lengkap',
                    hint: 'Masukkan Nama Lengkap',
                    controller: viewModel.nameController,
                    validator: (v) => v == null || v.trim().isEmpty
                        ? 'Nama tidak boleh kosong'
                        : null,
                  ),

                  // Email
                  _buildField(
                    label: 'Email',
                    hint: 'Masukkan Email',
                    controller: viewModel.emailController,
                    keyboardType: TextInputType.emailAddress,
                    validator: (v) {
                      if (v == null || v.trim().isEmpty)
                        return 'Email tidak boleh kosong';
                      final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
                      if (!emailRegex.hasMatch(v))
                        return 'Format email tidak valid';
                      return null;
                    },
                  ),

                  // Username
                  _buildField(
                    label: 'Username',
                    hint: 'Masukkan Username',
                    controller: viewModel.usernameController,
                    validator: (v) => v == null || v.trim().isEmpty
                        ? 'Username tidak boleh kosong'
                        : null,
                  ),

                  // Password
                  _buildPasswordField(
                    label: 'Kata Sandi',
                    hint: 'Masukkan Kata Sandi',
                    controller: viewModel.passwordController,
                    isVisible: _showPassword,
                    onToggle: () =>
                        setState(() => _showPassword = !_showPassword),
                    validator: (v) {
                      if (v == null || v.isEmpty)
                        return 'Kata sandi tidak boleh kosong';
                      if (v.length < 6) return 'Minimal 6 karakter';
                      return null;
                    },
                  ),

                  // Konfirmasi
                  _buildPasswordField(
                    label: 'Konfirmasi Kata Sandi',
                    hint: 'Masukkan Konfirmasi Kata Sandi',
                    controller: viewModel.passwordConfirmController,
                    isVisible: _showKonfirmasi,
                    onToggle: () =>
                        setState(() => _showKonfirmasi = !_showKonfirmasi),
                    validator: (v) {
                      if (v == null || v.isEmpty)
                        return 'Konfirmasi tidak boleh kosong';
                      if (v != viewModel.passwordController.text)
                        return 'Kata sandi tidak cocok';
                      return null;
                    },
                  ),

                  const SizedBox(height: 12),

                  // BUTTON REGISTER
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
                      ),
                      child: const Text(
                        'Daftar',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  Row(
                    children: const [
                      Expanded(
                        child: Divider(
                          thickness: 0.8,
                          color: Color(0xFFE0E0E0),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        child: Text(
                          'Atau',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFF9E9E9E),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Divider(
                          thickness: 0.8,
                          color: Color(0xFFE0E0E0),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 18),

                  // ───── Google Button ─────
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: _handleGoogle,
                      icon: Icon(Icons.account_circle),
                      label: const Text(
                        'Lanjutkan dengan Google',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF333333),
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        backgroundColor: const Color(0xFFF7F7F7),
                        side: const BorderSide(color: Color(0xFFE0E0E0)),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // ───── Footer ─────
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Sudah punya akun? ',
                        style: TextStyle(
                          fontSize: 13,
                          color: Color(0xFF9E9E9E),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          // navigate login
                        },
                        child: const Text(
                          'Masuk',
                          style: TextStyle(
                            fontSize: 13,
                            color: teal,
                            fontWeight: FontWeight.w600,
                          ),
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
              hintStyle: const TextStyle(
                fontSize: 13,
                color: Color(0xFFAAAAAA),
              ),
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
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 12,
              ),
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
              hintStyle: const TextStyle(
                fontSize: 13,
                color: Color(0xFFAAAAAA),
              ),
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
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 12,
              ),
              suffixIcon: GestureDetector(
                onTap: onToggle,
                child: Icon(
                  isVisible
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                  size: 18,
                  color: isVisible
                      ? const Color(0xFF1AAA8A)
                      : const Color(0xFFBBBBBB),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
