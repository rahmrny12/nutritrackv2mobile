class ProfileModel {
  final int? id;
  final int? userId;
  final double? tinggiBadan;
  final double? beratBadan;
  final double? bmi;
  final int? usia;
  final String? jenisKelamin;

  final double? lingkarPinggang;
  final double? lingkarPinggul;

  ProfileModel({
    this.id,
    this.userId,
    this.tinggiBadan,
    this.beratBadan,
    this.bmi,
    this.usia,
    this.jenisKelamin,
    this.lingkarPinggang,
    this.lingkarPinggul,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: _toInt(json['id']),
      userId: _toInt(json['user_id']),

      tinggiBadan: _toDouble(json['tinggi_badan']),
      beratBadan: _toDouble(json['berat_badan']),
      bmi: _toDouble(json['bmi']),

      usia: _toInt(json['usia']),
      jenisKelamin: json['jenis_kelamin']?.toString(),

      lingkarPinggang: _toDouble(json['lingkar_pinggang']),
      lingkarPinggul: _toDouble(json['lingkar_pinggul']),
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
      "lingkar_pinggang": lingkarPinggang,
      "lingkar_pinggul": lingkarPinggul,
    };
  }

  static double? _toDouble(dynamic value) {
    if (value == null) return null;
    return double.tryParse(value.toString());
  }

  static int? _toInt(dynamic value) {
    if (value == null) return null;
    return int.tryParse(value.toString());
  }
}
