import 'package:flutter/material.dart';
import 'package:nutritrack/data/repository/profile_repository.dart';
import 'package:nutritrack/data/models/profile_model.dart';
import 'profile_state.dart';

class ProfileViewModel extends ValueNotifier<ProfileState> {
  final ProfileRepository repo;

  ProfileViewModel(this.repo) : super(ProfileState());

  final tinggiController = TextEditingController();
  final beratController = TextEditingController();
  TextEditingController lingkarController = TextEditingController();
  final usiaController = TextEditingController();

  String gender = 'L';

  Future<void> updateProfile() async {
    value = value.copyWith(isLoading: true, error: null);

    try {
      final profile = await repo.updateProfile(
        tinggiBadan: double.parse(tinggiController.text),
        beratBadan: double.parse(beratController.text),
        lingkarPinggang: lingkarController.text.isEmpty
            ? null
            : double.parse(lingkarController.text),
        usia: int.parse(usiaController.text),
        jenisKelamin: gender,
      );

      value = value.copyWith(isLoading: false, profile: profile);
    } catch (e) {
      value = value.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<ProfileModel?> getProfile() async {
    final profile = await repo.getProfile();

    value = value.copyWith(isLoading: false, profile: profile);

    return profile;
  }

  @override
  void dispose() {
    tinggiController.dispose();
    beratController.dispose();
    lingkarController.dispose();
    usiaController.dispose();
    super.dispose();
  }
}
