import 'package:nutritrack/core/api_service.dart';
import 'package:nutritrack/core/local_storage.dart';
import 'package:nutritrack/data/models/profile_model.dart';

class ProfileRepository {
  final ApiService api;

  ProfileRepository(this.api);

  Future<ProfileModel> getProfile() async {
    final response = await api.get('/profile');

    final profileJson = response['data'] ?? response;
    return ProfileModel.fromJson(profileJson);
  }

  Future<ProfileModel> updateProfile({
    required double tinggiBadan,
    required double beratBadan,
    required double? lingkarPinggang,
    required int usia,
    required String jenisKelamin,
  }) async {
    final response = await api.post('/profile', {
      "tinggi_badan": tinggiBadan,
      "berat_badan": beratBadan,
      "lingkar_pinggang": lingkarPinggang,
      "usia": usia,
      "jenis_kelamin": jenisKelamin,
    });

    final profileJson = response['data'] ?? response;

    final profile = ProfileModel.fromJson(profileJson);

    // simpan ke local storage (pakai toJson)
    await LocalStorage.saveProfile(profile.toJson());

    return profile;
  }
}
