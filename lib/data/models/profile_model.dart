class ProfileModel {
  final int? id;
  final int? userId;
  final double? tinggiBadan;
  final double? beratBadan;
  final double? bmi;
  final int? usia;
  final String? jenisKelamin;

  ProfileModel({
    this.id,
    this.userId,
    this.tinggiBadan,
    this.beratBadan,
    this.bmi,
    this.usia,
    this.jenisKelamin,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: json['id'],
      userId: json['user_id'],
      tinggiBadan: _toDouble(json['tinggi_badan']),
      beratBadan: _toDouble(json['berat_badan']),
      bmi: _toDouble(json['bmi']),
      usia: json['usia'],
      jenisKelamin: json['jenis_kelamin'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "user_id": userId,
      "tinggi_badan": tinggiBadan,
      "berat_badan": beratBadan,
      "bmi": bmi,
      "usia": usia,
      "jenis_kelamin": jenisKelamin,
    };
  }

  static double? _toDouble(dynamic value) {
    if (value == null) return null;
    return double.tryParse(value.toString());
  }
}