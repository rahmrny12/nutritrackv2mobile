class UserModel {
  final String name;
  final String email;
  final String? token;

  UserModel({
    required this.name,
    required this.email,
    this.token,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      name: json['name']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      token: json['token']?.toString(),
    );
  }
}