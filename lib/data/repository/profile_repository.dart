import 'package:nutritrack/core/api_service.dart';
import 'package:nutritrack/core/local_storage.dart';
import 'package:nutritrack/data/models/profile_model.dart';

class ProfileRepository {
  final ApiService api;

  ProfileRepository(this.api);

  Future<ProfileModel?> getProfile() async {
    final response = await api.get('/profile');

    final statusCode = response['statusCode'];
    final data = response['data'];

    if (data == null || statusCode == 404) {
      return null;
    }

    if (statusCode != 200) {
      throw Exception(
        data['message'] ?? "Failed to load profile",
      );
    }

    final profile = ProfileModel.fromJson(data);

    // sync local storage
    await LocalStorage.saveProfile(profile.toJson());

    return profile;
  }

  Future<ProfileModel> updateProfile({
    required double height,
    required double weight,

    required double? waistCircumference,
    required double? hipCircumference,

    required int age,

    required String gender,

    required String activityLevel,
    required String goal,
  }) async {
    final response = await api.post('/profile', {
      "height": height,
      "weight": weight,

      "waist_circumference": waistCircumference,
      "hip_circumference": hipCircumference,

      "age": age,
      "gender": gender,

      "activity_level": activityLevel,
      "goal": goal,
    });

    final statusCode = response['statusCode'];
    final data = response['data'];

    if (statusCode != 200 && statusCode != 201) {
      throw Exception(
        data?['message'] ?? 'Failed to update profile',
      );
    }

    final profile = ProfileModel.fromJson(data);

    // save latest profile locally
    await LocalStorage.saveProfile(profile.toJson());

    return profile;
  }
}