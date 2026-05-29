import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nutritrack/core/route_generator.dart';
import 'package:nutritrack/data/repository/profile_repository.dart';
import 'package:nutritrack/core/api_service.dart';
import 'package:nutritrack/view/viewmodel/profile_view_model.dart';

class BMIPage extends StatefulWidget {
  const BMIPage({super.key});

  @override
  State<BMIPage> createState() => _BMIPageState();
}

class _BMIPageState extends State<BMIPage> {
  late final ProfileViewModel viewModel;

  @override
  void initState() {
    super.initState();

    viewModel = ProfileViewModel(ProfileRepository(ApiService()));

    viewModel.getProfile();

    viewModel.addListener(() {
      final profile = viewModel.value.profile;

      if (profile == null) return;

      _bbController.text = profile.weight?.toString() ?? '';

      _tbController.text = profile.height?.toString() ?? '';

      _usiaController.text = profile.age?.toString() ?? '';

      _lingkarController.text = profile.waistCircumference?.toString() ?? '';

      _selectedGender = profile.gender ?? 'L';

      setState(() {});
    });
  }

  final _bbController = TextEditingController();
  final _tbController = TextEditingController();
  final _usiaController = TextEditingController();
  final _lingkarController = TextEditingController();

  String _selectedGender = 'L';

  @override
  void dispose() {
    _bbController.dispose();
    _tbController.dispose();
    _usiaController.dispose();
    _lingkarController.dispose();

    super.dispose();
  }

  void _handleSubmit() async {
    if (_bbController.text.isEmpty ||
        _tbController.text.isEmpty ||
        _usiaController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Semua data wajib diisi'),
          backgroundColor: Colors.red,
        ),
      );

      return;
    }

    try {
      viewModel.weightController.text = _bbController.text;

      viewModel.heightController.text = _tbController.text;

      viewModel.ageController.text = _usiaController.text;

      viewModel.waistController.text = _lingkarController.text;

      viewModel.gender = _selectedGender;

      await viewModel.updateProfile();

      if (viewModel.value.error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal: ${viewModel.value.error}'),
            backgroundColor: Colors.red,
          ),
        );

        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Profile berhasil disimpan'),
          backgroundColor: Color(0xFF1AAA8A),
        ),
      );

      Navigator.pushNamed(context, Routes.activity);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
      );
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
                    top: 180,
                    left: 20,
                    right: 20,
                    bottom: 30,
                  ),
                  child: Card(
                    elevation: 8,
                    shadowColor: Colors.black12,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Informasi Tubuh",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF0D3D38),
                            ),
                          ),

                          const SizedBox(height: 24),

                          _buildForm(),
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
                "assets/images/logo_nutritrack_horizontal.png",
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildForm() {
    return ValueListenableBuilder(
      valueListenable: viewModel,
      builder: (context, value, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: _buildField(
                    label: 'Berat Badan (kg)',
                    hint: 'Contoh: 65',
                    controller: _bbController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: _buildField(
                    label: 'Tinggi Badan (cm)',
                    hint: 'Contoh: 170',
                    controller: _tbController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            Row(
              children: [
                Expanded(
                  child: _buildField(
                    label: 'Lingkar Pinggang (Opsional)',
                    hint: 'Dalam cm',
                    controller: _lingkarController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: _buildField(
                    label: 'Usia',
                    hint: 'Contoh: 24',
                    controller: _usiaController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            _buildGenderField(),

            const SizedBox(height: 32),

            _buildSubmitButton(viewModel.value.isLoading),
          ],
        );
      },
    );
  }

  Widget _buildField({
    required String label,
    required String hint,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
    List<TextInputFormatter>? inputFormatters,
  }) {
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
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: Color(0xFFA8BFBB), fontSize: 14),
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

        const SizedBox(height: 12),

        Row(
          children: [
            _buildRadioOption(label: 'Laki-laki', value: 'L'),

            const SizedBox(width: 32),

            _buildRadioOption(label: 'Perempuan', value: 'P'),
          ],
        ),
      ],
    );
  }

  Widget _buildRadioOption({required String label, required String value}) {
    final bool isSelected = _selectedGender == value;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedGender = value;
        });
      },
      child: Row(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isSelected ? const Color(0xFF2BAA97) : Colors.transparent,
              border: Border.all(
                color: isSelected
                    ? const Color(0xFF2BAA97)
                    : const Color(0xFFC8D8D6),
                width: 2,
              ),
            ),
            child: isSelected
                ? const Icon(Icons.check, size: 12, color: Colors.white)
                : null,
          ),

          const SizedBox(width: 8),

          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              color: isSelected
                  ? const Color(0xFF1A2E2B)
                  : const Color(0xFF5E7E79),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubmitButton(bool isLoading) {
    return Container(
      width: double.infinity,
      height: 54,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF165F57), Color(0xFF23A18F)],
        ),
        borderRadius: BorderRadius.circular(14),
      ),
      child: ElevatedButton(
        onPressed: isLoading ? null : _handleSubmit,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        child: isLoading
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : const Text(
                'Simpan & Hitung BMI',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
      ),
    );
  }
}
