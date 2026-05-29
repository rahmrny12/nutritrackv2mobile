import 'package:flutter/material.dart';
import 'package:nutritrack/core/api_service.dart';
import 'package:nutritrack/core/route_generator.dart';
import 'package:nutritrack/data/repository/profile_repository.dart';
import 'package:nutritrack/view/pages/main_page.dart';
import 'package:nutritrack/view/viewmodel/profile_view_model.dart';

class ActivityPage extends StatefulWidget {
  const ActivityPage({super.key});

  @override
  State<ActivityPage> createState() => _ActivityPageState();
}

class _ActivityPageState extends State<ActivityPage> {
  late final ProfileViewModel viewModel;

  String _activityLevel = 'moderate';
  String _goal = 'maintain';

  String _recommendedGoal() {
    final bmi = viewModel.value.profile?.bmi ?? 0;

    if (bmi < 18.5) {
      return 'bulking';
    } else if (bmi >= 25) {
      return 'cutting';
    }

    return 'maintain';
  }

  @override
  void initState() {
    super.initState();

    viewModel = ProfileViewModel(ProfileRepository(ApiService()));

    viewModel.getProfile();

    viewModel.addListener(() {
      final profile = viewModel.value.profile;

      if (profile == null) return;

      final recommendedGoal = _recommendedGoal();

      setState(() {
        _activityLevel = profile.activityLevel ?? 'moderate';

        // auto select recommendation
        _goal = recommendedGoal;
      });
    });
  }

  Future<void> _submit() async {
    try {
      viewModel.activityLevel = _activityLevel;
      viewModel.goal = _goal;

      await viewModel.updateProfile();

      if (!mounted) return;

      if (viewModel.value.error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(viewModel.value.error!),
            backgroundColor: Colors.red,
          ),
        );

        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Data profil berhasil disimpan'),
          backgroundColor: Color(0xFF1AAA8A),
        ),
      );

      Navigator.pushNamed(context, Routes.main);
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
                      padding: const EdgeInsets.all(24),
                      child: ValueListenableBuilder(
                        valueListenable: viewModel,
                        builder: (context, state, child) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Aktivitas & Target Kalori',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF0D3D38),
                                ),
                              ),

                              const SizedBox(height: 10),

                              const Text(
                                'Lengkapi tingkat aktivitas dan tujuan tubuh untuk menghitung kebutuhan kalori harian.',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Color(0xFF6B8F8A),
                                ),
                              ),

                              const SizedBox(height: 28),

                              _buildSectionTitle('Tingkat Aktivitas'),

                              const SizedBox(height: 14),

                              _buildActivityOption(
                                title: 'Jarang Aktif',
                                subtitle:
                                    'Sebagian besar duduk atau sedikit bergerak',
                                value: 'sedentary',
                              ),

                              _buildActivityOption(
                                title: 'Aktif Ringan',
                                subtitle:
                                    'Aktivitas harian ringan dan sesekali berjalan',
                                value: 'light',
                              ),

                              _buildActivityOption(
                                title: 'Aktif Sedang',
                                subtitle:
                                    'Cukup sering bergerak dalam aktivitas sehari-hari',
                                value: 'moderate',
                              ),

                              _buildActivityOption(
                                title: 'Aktif Tinggi',
                                subtitle:
                                    'Banyak aktivitas fisik atau sering berpindah tempat',
                                value: 'active',
                              ),

                              _buildActivityOption(
                                title: 'Sangat Aktif',
                                subtitle:
                                    'Pekerjaan atau aktivitas fisik berat hampir setiap hari',
                                value: 'very_active',
                              ),

                              const SizedBox(height: 28),

                              _buildSectionTitle('Target Kalori'),

                              const SizedBox(height: 14),

                              _buildGoalOption(
                                title: 'Menurunkan Berat Badan',
                                subtitle: 'Defisit kalori sekitar 20%',
                                value: 'cutting',
                              ),

                              _buildGoalOption(
                                title: 'Menjaga Berat Badan',
                                subtitle: 'Kalori sesuai kebutuhan harian',
                                value: 'maintain',
                              ),

                              _buildGoalOption(
                                title: 'Menambah Berat Badan',
                                subtitle: 'Surplus kalori sekitar 10%',
                                value: 'bulking',
                              ),

                              const SizedBox(height: 32),

                              _buildSubmitButton(state.isLoading),
                            ],
                          );
                        },
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
      child: const SafeArea(
        child: Center(
          child: Text(
            'NutriTrack',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w700,
        color: Color(0xFF1F3330),
      ),
    );
  }

  Widget _buildActivityOption({
    required String title,
    required String subtitle,
    required String value,
  }) {
    final isSelected = _activityLevel == value;

    return GestureDetector(
      onTap: () {
        setState(() {
          _activityLevel = value;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFE8F8F5) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? const Color(0xFF23A18F)
                : const Color(0xFFE2ECEA),
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            Icon(
              isSelected ? Icons.check_circle : Icons.circle_outlined,
              color: isSelected
                  ? const Color(0xFF23A18F)
                  : const Color(0xFF9EB5B1),
            ),
            const SizedBox(width: 14),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                      color: Color(0xFF1A2E2B),
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 12.5,
                      color: Color(0xFF6C8B86),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGoalOption({
    required String title,
    required String subtitle,
    required String value,
  }) {
    final isSelected = _goal == value;

    final isRecommended = _recommendedGoal() == value;

    return GestureDetector(
      onTap: () {
        setState(() {
          _goal = value;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFE8F8F5) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? const Color(0xFF23A18F)
                : isRecommended
                ? const Color(0xFFFFC857)
                : const Color(0xFFE2ECEA),
            width: isRecommended ? 2 : 1.5,
          ),
          boxShadow: isRecommended
              ? [
                  BoxShadow(
                    color: const Color(0xFFFFC857).withOpacity(0.18),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              isSelected ? Icons.check_circle : Icons.circle_outlined,
              color: isSelected
                  ? const Color(0xFF23A18F)
                  : isRecommended
                  ? const Color(0xFFFFB020)
                  : const Color(0xFF9EB5B1),
            ),

            const SizedBox(width: 14),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                            color: Color(0xFF1A2E2B),
                          ),
                        ),
                      ),

                      if (isRecommended)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFF4D6),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text(
                            'Direkomendasikan',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFFE09A00),
                            ),
                          ),
                        ),
                    ],
                  ),

                  const SizedBox(height: 4),

                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 12.5,
                      color: Color(0xFF6C8B86),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
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
        onPressed: isLoading ? null : _submit,
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
                'Simpan',
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
