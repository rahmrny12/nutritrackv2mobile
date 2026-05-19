import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nutritrack/core/api_service.dart';
import 'package:nutritrack/core/local_storage.dart';
import 'package:nutritrack/core/route_generator.dart';
import 'package:nutritrack/data/repository/auth_repository.dart';
import 'package:nutritrack/view/viewmodel/auth_state.dart';
import 'package:nutritrack/view/viewmodel/auth_viewmodel.dart';

class VerifyOtpPage extends StatefulWidget {
  const VerifyOtpPage({super.key});

  @override
  State<VerifyOtpPage> createState() => _VerifyOtpPageState();
}

class _VerifyOtpPageState extends State<VerifyOtpPage> {
  late AuthViewModel viewModel;
  Map<String, dynamic>? _user;

  static const int _otpLength = 6;

  Future<void> _loadUser() async {
    final data = await LocalStorage.getUser();
    if (!mounted) return;

    setState(() {
      _user = data;
    });
  }

  final List<TextEditingController> _controllers =
      List.generate(_otpLength, (_) => TextEditingController());
  final List<FocusNode> _focusNodes =
      List.generate(_otpLength, (_) => FocusNode());

  @override
  void initState() {
    super.initState();
    viewModel = AuthViewModel(repo: AuthRepository(ApiService()));

    _loadUser();

    // Sync OTP controllers to viewModel.otpController
    for (final c in _controllers) {
      c.addListener(_syncOtp);
    }

    // Auto-focus first box
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(_focusNodes[0]);
    });
  }

  void _syncOtp() {
    final otp = _controllers.map((c) => c.text).join();
    viewModel.otpController.text = otp;
  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c.removeListener(_syncOtp);
      c.dispose();
    }
    for (final f in _focusNodes) {
      f.dispose();
    }
    viewModel.otpController.dispose();
    super.dispose();
  }

  void _onOtpChanged(String value, int index) {
    if (value.length == 1) {
      // Move to next field
      if (index < _otpLength - 1) {
        FocusScope.of(context).requestFocus(_focusNodes[index + 1]);
      } else {
        // Last digit — close keyboard
        _focusNodes[index].unfocus();
      }
    } else if (value.isEmpty && index > 0) {
      // Backspace — move to previous field
      FocusScope.of(context).requestFocus(_focusNodes[index - 1]);
    }
  }

  Future<void> _submit() async {
    final otp = _controllers.map((c) => c.text).join();
    if (otp.length < _otpLength) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Masukkan 6 digit kode OTP')),
      );
      return;
    }

    await viewModel.verifyOtp(_user?['email'] ?? '');

    if (!mounted) return;

    final s = viewModel.value;
    if (s.error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(s.error!)),
      );
      return;
    }

    if (s.otpSuccess) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(s.otpMessage ?? 'Verifikasi berhasil')),
      );
      Navigator.pushReplacementNamed(context, Routes.auth);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F9F8),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.topCenter,
              children: [
                _buildHeader(),
                Padding(
                  padding: const EdgeInsets.only(
                      top: 180, left: 20, right: 20, bottom: 30),
                  child: Card(
                    elevation: 8,
                    shadowColor: Colors.black12,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24)),
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Verifikasi OTP',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF0D3D38),
                            ),
                          ),
                          const SizedBox(height: 6),
                          const Text(
                            'Masukkan 6 digit kode yang dikirimkan ke email Anda.',
                            style: TextStyle(
                              fontSize: 13,
                              color: Color(0xFF6B8F8A),
                            ),
                          ),
                          const SizedBox(height: 24),

                          // 6-digit OTP boxes
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: List.generate(_otpLength, (i) {
                              final isLast = i == _otpLength - 1;
                              return _OtpBox(
                                controller: _controllers[i],
                                focusNode: _focusNodes[i],
                                textInputAction: isLast
                                    ? TextInputAction.done
                                    : TextInputAction.next,
                                onChanged: (val) => _onOtpChanged(val, i),
                                onEditingComplete: isLast ? _submit : null,
                              );
                            }),
                          ),

                          const SizedBox(height: 24),

                          ValueListenableBuilder<AuthState>(
                            valueListenable: viewModel,
                            builder: (context, state, child) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  // Error message
                                  if (state.error != null)
                                    _buildMessage(
                                      icon: Icons.error_outline_rounded,
                                      text: state.error!,
                                      color: const Color(0xFFD32F2F),
                                      bgColor: const Color(0xFFFDECEC),
                                    ),

                                  // Success message
                                  if (state.otpMessage != null)
                                    _buildMessage(
                                      icon: Icons.check_circle_outline_rounded,
                                      text: state.otpMessage!,
                                      color: const Color(0xFF1B7F6E),
                                      bgColor: const Color(0xFFE6F5F2),
                                    ),

                                  if (state.error != null ||
                                      state.otpMessage != null)
                                    const SizedBox(height: 16),

                                  _buildVerifyButton(state.isLoading, _submit),
                                ],
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      height: 220,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF0D3D38), Color(0xFF165F57), Color(0xFF1E7B6E)],
        ),
      ),
      child: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(62.0),
            child: SizedBox.expand(
              child: Image.asset(
                'assets/images/logo_nutritrack_horizontal.png',
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMessage({
    required IconData icon,
    required String text,
    required Color color,
    required Color bgColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 13,
                color: color,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVerifyButton(bool isLoading, VoidCallback onPressed) {
    return Container(
      width: double.infinity,
      height: 54,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
            colors: [Color(0xFF165F57), Color(0xFF23A18F)]),
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1E7B6E).withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
        child: isLoading
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                    strokeWidth: 2, color: Colors.white),
              )
            : const Text(
                'Verifikasi',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
      ),
    );
  }
}

// ─── Single OTP digit box ───────────────────────────────────────────────────

class _OtpBox extends StatelessWidget {
  const _OtpBox({
    required this.controller,
    required this.focusNode,
    required this.textInputAction,
    required this.onChanged,
    this.onEditingComplete,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final TextInputAction textInputAction;
  final ValueChanged<String> onChanged;
  final VoidCallback? onEditingComplete;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 44,
      height: 54,
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        textInputAction: textInputAction,
        maxLength: 1,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        style: const TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: Color(0xFF0D3D38),
        ),
        decoration: InputDecoration(
          counterText: '',
          filled: true,
          fillColor: const Color(0xFFF1F5F4),
          contentPadding: EdgeInsets.zero,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide:
                const BorderSide(color: Color(0xFF23A18F), width: 2),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
                color: Color(0xFFD0E5E2), width: 1.5),
          ),
        ),
        onChanged: onChanged,
        onEditingComplete: onEditingComplete,
      ),
    );
  }
}