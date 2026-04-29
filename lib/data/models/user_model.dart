class UserModel {
  final String name;
  final String token;

  UserModel({required this.name, required this.token});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      name: json['user']['name'],
      token: json['token'],
    );
  }
}
