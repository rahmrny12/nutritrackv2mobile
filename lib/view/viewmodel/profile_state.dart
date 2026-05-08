import 'package:nutritrack/data/models/profile_model.dart';

class ProfileState {
  final bool isLoading;
  final String? error;
  final ProfileModel? profile;

  ProfileState({
    this.isLoading = false,
    this.error,
    this.profile,
  });

  ProfileState copyWith({
    bool? isLoading,
    String? error,
    ProfileModel? profile,
  }) {
    return ProfileState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      profile: profile ?? this.profile,
    );
  }
}