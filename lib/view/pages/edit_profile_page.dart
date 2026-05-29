import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nutritrack/core/api_service.dart';
import 'package:nutritrack/data/repository/profile_repository.dart';
import 'package:nutritrack/view/viewmodel/profile_view_model.dart';

// import 'package:image_picker/image_picker.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() =>
      _EditProfilePageState();
}

class _EditProfilePageState
    extends State<EditProfilePage> {
  File? _image;

  // final ImagePicker _picker = ImagePicker();

  late final ProfileViewModel _viewModel;

  final _fullNameController =
      TextEditingController();

  final _emailController =
      TextEditingController();

  final _locationController =
      TextEditingController();

  final _heightController =
      TextEditingController();

  final _ageController =
      TextEditingController();

  final _currentWeightController =
      TextEditingController();

  final _waistController =
      TextEditingController();

  String _selectedGender = 'L';

  bool _profileLoaded = false;

  @override
  void initState() {
    super.initState();

    _viewModel = ProfileViewModel(
      ProfileRepository(ApiService()),
    );

    _viewModel.addListener(
      _onViewModelChanged,
    );

    _viewModel.getProfile();
  }

  void _onViewModelChanged() {
    final profile =
        _viewModel.value.profile;

    if (profile != null &&
        !_profileLoaded) {
      _heightController.text =
          profile.height?.toString() ??
          '';

      _ageController.text =
          profile.age?.toString() ?? '';

      _currentWeightController.text =
          profile.weight?.toString() ??
          '';

      _waistController.text =
          profile.waistCircumference
                  ?.toString() ??
              '';

      _selectedGender =
          profile.gender == 'female'
              ? 'P'
              : 'L';

      _profileLoaded = true;

      setState(() {});
    }
  }

  void _saveProfile() async {
    final name =
        _fullNameController.text;

    final email =
        _emailController.text;

    if (name.isEmpty ||
        email.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(
        const SnackBar(
          content: Text(
            'Nama dan email tidak boleh kosong',
          ),
          backgroundColor: Colors.red,
        ),
      );

      return;
    }

    _viewModel.heightController.text =
        _heightController.text;

    _viewModel.weightController.text =
        _currentWeightController.text;

    _viewModel.ageController.text =
        _ageController.text;

    _viewModel.waistController.text =
        _waistController.text;

    _viewModel.gender =
        _selectedGender == 'L'
            ? 'male'
            : 'female';

    await _viewModel.updateProfile();

    if (_viewModel.value.error !=
        null) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(
        SnackBar(
          content: Text(
            'Gagal menyimpan profil: ${_viewModel.value.error}',
          ),
          backgroundColor: Colors.red,
        ),
      );

      return;
    }

    if (!mounted) return;

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(
      const SnackBar(
        content: Text(
          'Profil berhasil disimpan',
        ),
        backgroundColor: Colors.green,
      ),
    );

    Navigator.pop(context, true);
  }

  Future<void> _pickImage() async {
    // final pickedFile = await _picker.pickImage(
    //   source: ImageSource.gallery,
    // );

    // if (pickedFile != null) {
    //   setState(() {
    //     _image = File(
    //       pickedFile.path,
    //     );
    //   });
    // }
  }

  @override
  void dispose() {
    _fullNameController.dispose();

    _emailController.dispose();

    _locationController.dispose();

    _heightController.dispose();

    _ageController.dispose();

    _currentWeightController.dispose();

    _waistController.dispose();

    _viewModel.removeListener(
      _onViewModelChanged,
    );

    _viewModel.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          const Color(0xFFF0F2F8),

      appBar: AppBar(
        backgroundColor:
            const Color(0xFFF0F2F8),

        elevation: 0,

        leading: const BackButton(
          color: Colors.black87,
        ),

        title: const Text(
          'Edit Profile',
          style: TextStyle(
            color: Colors.black87,
            fontWeight:
                FontWeight.w600,
            fontSize: 18,
          ),
        ),
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 16),

            _buildProfileAvatar(),

            const SizedBox(height: 12),

            const Text(
              'Syahidah',
              style: TextStyle(
                fontSize: 20,
                fontWeight:
                    FontWeight.w700,
                color: Colors.black87,
              ),
            ),

            const SizedBox(height: 4),

            const Text(
              'Premium Member',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),

            const SizedBox(height: 28),

            _buildSectionHeader(
              icon:
                  Icons.person_outline,
              title:
                  'Personal Information',
            ),

            const SizedBox(height: 12),

            _buildPersonalInfoCard(),

            const SizedBox(height: 24),

            _buildSectionHeader(
              icon:
                  Icons.bar_chart_rounded,
              title:
                  'Body Measurements',
              iconColor:
                  const Color(
                    0xFF2EC4A0,
                  ),
            ),

            const SizedBox(height: 12),

            _buildBodyMeasurementsCard(),

            const SizedBox(height: 32),

            Padding(
              padding:
                  const EdgeInsets.symmetric(
                    horizontal: 16,
                  ),
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed:
                      _saveProfile,
                  style:
                      ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color(
                              0xFF1A8A7A,
                            ),
                        shape:
                            RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(
                                    14,
                                  ),
                            ),
                      ),
                  child: const Text(
                    'Simpan Perubahan',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight:
                          FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileAvatar() {
    return Stack(
      alignment:
          Alignment.bottomRight,
      children: [
        Container(
          width: 110,
          height: 110,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black
                    .withOpacity(0.1),
                blurRadius: 12,
                offset:
                    const Offset(0, 4),
              ),
            ],
          ),
          child: ClipOval(
            child: _image != null
                ? Image.file(
                    _image!,
                    fit: BoxFit.cover,
                  )
                : _buildMiniDashboard(),
          ),
        ),

        Positioned(
          bottom: 2,
          right: 2,
          child: GestureDetector(
            onTap: _pickImage,
            child: Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: const Color(
                  0xFF2EC4A0,
                ),
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white,
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color:
                        const Color(
                          0xFF2EC4A0,
                        ).withOpacity(0.4),
                    blurRadius: 8,
                    offset:
                        const Offset(
                          0,
                          2,
                        ),
                  ),
                ],
              ),
              child: const Icon(
                Icons.camera_alt,
                color: Colors.white,
                size: 17,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMiniDashboard() {
    return Container(
      color: Colors.white,
      padding:
          const EdgeInsets.all(8),
      child: Column(
        mainAxisAlignment:
            MainAxisAlignment.center,
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          const Text(
            'Jember, Jawa Timur',
            style: TextStyle(
              fontSize: 4,
              color: Colors.grey,
            ),
          ),

          const SizedBox(height: 2),

          Container(
            padding:
                const EdgeInsets.symmetric(
                  horizontal: 4,
                  vertical: 1,
                ),
            decoration: BoxDecoration(
              color: const Color(
                0xFF2EC4A0,
              ),
              borderRadius:
                  BorderRadius.circular(
                    2,
                  ),
            ),
            child: const Text(
              'Edit Profil',
              style: TextStyle(
                color: Colors.white,
                fontSize: 4,
              ),
            ),
          ),

          const SizedBox(height: 3),

          const Text(
            'Kalori Harian',
            style: TextStyle(
              fontSize: 5,
              fontWeight:
                  FontWeight.bold,
            ),
          ),

          const SizedBox(height: 3),

          Row(
            children: [
              _miniStat(
                '● Kalori',
                '1850 kcal',
                Colors.red,
              ),

              const SizedBox(width: 4),

              _miniStat(
                '● Protein',
                '75 g',
                Colors.blue,
              ),
            ],
          ),

          const SizedBox(height: 2),

          Row(
            children: [
              _miniStat(
                '● Lemak',
                '62 g',
                Colors.orange,
              ),

              const SizedBox(width: 4),

              _miniStat(
                '● Karbohidrat',
                '230 g',
                const Color(
                  0xFF2EC4A0,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _miniStat(
    String label,
    String value,
    Color color,
  ) {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 3.5,
            color: color,
          ),
        ),

        Text(
          value,
          style: const TextStyle(
            fontSize: 4.5,
            fontWeight:
                FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildSectionHeader({
    required IconData icon,
    required String title,
    Color iconColor =
        const Color(0xFF2EC4A0),
  }) {
    return Padding(
      padding:
          const EdgeInsets.symmetric(
            horizontal: 20,
          ),
      child: Row(
        children: [
          Icon(
            icon,
            color: iconColor,
            size: 22,
          ),

          const SizedBox(width: 8),

          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight:
                  FontWeight.w700,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPersonalInfoCard() {
    return Container(
      margin:
          const EdgeInsets.symmetric(
            horizontal: 16,
          ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black
                .withOpacity(0.05),
            blurRadius: 10,
            offset:
                const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          _buildLabel('FULL NAME'),

          const SizedBox(height: 6),

          _buildTextField(
            controller:
                _fullNameController,
            hintText:
                'Masukkan nama lengkap',
          ),

          const SizedBox(height: 18),

          _buildLabel('EMAIL'),

          const SizedBox(height: 6),

          _buildTextField(
            controller:
                _emailController,
            keyboardType:
                TextInputType
                    .emailAddress,
            hintText:
                'Masukkan email',
          ),

          const SizedBox(height: 18),

          _buildLabel('LOCATION'),

          const SizedBox(height: 6),

          _buildTextField(
            controller:
                _locationController,
            hintText:
                'Kota, Provinsi',
            suffixIcon: const Icon(
              Icons
                  .location_on_outlined,
              color: Colors.grey,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBodyMeasurementsCard() {
    return Container(
      margin:
          const EdgeInsets.symmetric(
            horizontal: 16,
          ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black
                .withOpacity(0.05),
            blurRadius: 10,
            offset:
                const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          _buildLabel('HEIGHT'),

          const SizedBox(height: 6),

          _buildTextField(
            controller:
                _heightController,
            keyboardType:
                TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter
                  .digitsOnly,
            ],
            suffixText: 'cm',
          ),

          const SizedBox(height: 18),

          _buildLabel('AGE'),

          const SizedBox(height: 6),

          _buildTextField(
            controller:
                _ageController,
            keyboardType:
                TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter
                  .digitsOnly,
            ],
            suffixText: 'yrs',
          ),

          const SizedBox(height: 18),

          _buildLabel(
            'JENIS KELAMIN',
          ),

          const SizedBox(height: 10),

          Row(
            children: [
              _buildGenderOption(
                label: 'Laki-laki',
                value: 'L',
              ),

              const SizedBox(width: 16),

              _buildGenderOption(
                label: 'Perempuan',
                value: 'P',
              ),
            ],
          ),

          const SizedBox(height: 18),

          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment
                          .start,
                  children: [
                    _buildLabel(
                      'CURRENT\nWEIGHT',
                    ),

                    const SizedBox(
                      height: 6,
                    ),

                    _buildTextField(
                      controller:
                          _currentWeightController,
                      keyboardType:
                          TextInputType
                              .number,
                      inputFormatters: [
                        FilteringTextInputFormatter
                            .digitsOnly,
                      ],
                      suffixText:
                          'kg',
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 16),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment
                          .start,
                  children: [
                    _buildLabel(
                      'WAIST\nCIRCUMFERENCE',
                    ),

                    const SizedBox(
                      height: 6,
                    ),

                    _buildTextField(
                      controller:
                          _waistController,
                      keyboardType:
                          TextInputType
                              .number,
                      inputFormatters: [
                        FilteringTextInputFormatter
                            .digitsOnly,
                      ],
                      suffixText:
                          'cm',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGenderOption({
    required String label,
    required String value,
  }) {
    final isSelected =
        _selectedGender == value;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedGender = value;
        });
      },
      child: Row(
        children: [
          AnimatedContainer(
            duration:
                const Duration(
                  milliseconds: 200,
                ),
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isSelected
                  ? const Color(
                      0xFF2EC4A0,
                    )
                  : Colors.transparent,
              border: Border.all(
                color: isSelected
                    ? const Color(
                        0xFF2EC4A0,
                      )
                    : Colors.grey,
                width: 2,
              ),
            ),
            child: isSelected
                ? const Icon(
                    Icons.check,
                    size: 12,
                    color:
                        Colors.white,
                  )
                : null,
          ),

          const SizedBox(width: 8),

          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: isSelected
                  ? FontWeight.w600
                  : FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w600,
        color: Colors.grey,
        letterSpacing: 0.8,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController
    controller,
    TextInputType keyboardType =
        TextInputType.text,
    Widget? suffixIcon,
    String? suffixText,
    String? hintText,
    List<TextInputFormatter>?
    inputFormatters,
  }) {
    return Container(
      decoration: BoxDecoration(
        color:
            const Color(0xFFF5F6FA),
        borderRadius:
            BorderRadius.circular(12),
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        inputFormatters:
            inputFormatters,
        style: const TextStyle(
          fontSize: 15,
          color: Colors.black87,
          fontWeight:
              FontWeight.w500,
        ),
        decoration: InputDecoration(
          hintText: hintText,
          contentPadding:
              const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
          border: InputBorder.none,
          suffixIcon: suffixIcon,
          suffix:
              suffixText != null
                  ? Text(
                      suffixText,
                      style:
                          const TextStyle(
                            color:
                                Colors.grey,
                            fontSize: 14,
                          ),
                    )
                  : null,
        ),
      ),
    );
  }
}