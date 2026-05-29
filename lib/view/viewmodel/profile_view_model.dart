import 'package:flutter/material.dart';
import 'package:nutritrack/data/models/profile_model.dart';
import 'package:nutritrack/data/repository/profile_repository.dart';
import 'profile_state.dart';

class ProfileViewModel extends ValueNotifier<ProfileState> {
  final ProfileRepository repo;

  ProfileViewModel(this.repo) : super(ProfileState());

  // ─── Controllers ─────────────────────────────────────────────
  final heightController = TextEditingController();
  final weightController = TextEditingController();

  final waistController = TextEditingController();
  final hipController = TextEditingController();

  final ageController = TextEditingController();

  final targetCaloriesController =
      TextEditingController();

  // ─── Selection State ─────────────────────────────────────────
  String gender = 'male';

  /// sedentary | light | moderate | active | very_active
  String activityLevel = 'moderate';

  /// maintain | cutting | bulking
  String goal = 'maintain';

  // ─── Update Profile ──────────────────────────────────────────
  Future<void> updateProfile() async {
    value = value.copyWith(
      isLoading: true,
      error: null,
    );

    try {
      final profile = await repo.updateProfile(
        height: double.parse(heightController.text),

        weight: double.parse(weightController.text),

        waistCircumference:
            waistController.text.isEmpty
                ? null
                : double.parse(
                    waistController.text,
                  ),

        hipCircumference:
            hipController.text.isEmpty
                ? null
                : double.parse(
                    hipController.text,
                  ),

        age: int.parse(ageController.text),

        gender: gender,

        activityLevel: activityLevel,

        goal: goal,
      );

      value = value.copyWith(
        isLoading: false,
        profile: profile,
      );
    } catch (e) {
      value = value.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  // ─── Get Profile ─────────────────────────────────────────────
  Future<ProfileModel?> getProfile() async {
    value = value.copyWith(
      isLoading: true,
      error: null,
    );

    try {
      final profile = await repo.getProfile();

      if (profile != null) {
        // Fill controllers
        heightController.text =
            profile.height?.toString() ?? '';

        weightController.text =
            profile.weight?.toString() ?? '';

        waistController.text =
            profile.waistCircumference
                ?.toString() ??
            '';

        hipController.text =
            profile.hipCircumference
                ?.toString() ??
            '';

        ageController.text =
            profile.age?.toString() ?? '';

        targetCaloriesController.text =
            profile.targetCalories
                ?.toString() ??
            '';

        // Selection values
        gender = profile.gender ?? 'male';

        activityLevel =
            profile.activityLevel ??
            'moderate';

        goal = profile.goal ?? 'maintain';

        value = value.copyWith(
          isLoading: false,
          profile: profile,
        );

        return profile;
      }

      value = value.copyWith(
        isLoading: false,
      );

      return null;
    } catch (e) {
      value = value.copyWith(
        isLoading: false,
        error: e.toString(),
      );

      return null;
    }
  }

  // ─── Dispose ────────────────────────────────────────────────
  @override
  void dispose() {
    heightController.dispose();
    weightController.dispose();

    waistController.dispose();
    hipController.dispose();

    ageController.dispose();

    targetCaloriesController.dispose();

    super.dispose();
  }
}