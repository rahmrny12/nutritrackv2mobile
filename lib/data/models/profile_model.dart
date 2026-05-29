class ProfileModel {
  final int? id;
  final int? userId;

  // anthropometry
  final double? height;
  final double? weight;

  final double? bmi;
  final double? bmr;
  final double? tdee;

  // nutrition
  final double? targetCalories;

  final double? proteinTarget;
  final double? fatTarget;
  final double? carbohydrateTarget;

  // personal
  final int? age;
  final String? gender;

  final String? activityLevel;
  final String? goal;

  // body measurement
  final double? waistCircumference;
  final double? hipCircumference;

  ProfileModel({
    this.id,
    this.userId,

    this.height,
    this.weight,

    this.bmi,
    this.bmr,
    this.tdee,

    this.targetCalories,

    this.proteinTarget,
    this.fatTarget,
    this.carbohydrateTarget,

    this.age,
    this.gender,

    this.activityLevel,
    this.goal,

    this.waistCircumference,
    this.hipCircumference,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: _toInt(json['id']),
      userId: _toInt(json['user_id']),

      height: _toDouble(json['height']),
      weight: _toDouble(json['weight']),

      bmi: _toDouble(json['bmi']),
      bmr: _toDouble(json['bmr']),
      tdee: _toDouble(json['tdee']),

      targetCalories: _toDouble(json['target_calories']),

      proteinTarget: _toDouble(json['protein_target']),

      fatTarget: _toDouble(json['fat_target']),

      carbohydrateTarget: _toDouble(json['carbohydrate_target']),

      age: _toInt(json['age']),

      gender: json['gender']?.toString(),

      activityLevel: json['activity_level']?.toString(),

      goal: json['goal']?.toString(),

      waistCircumference: _toDouble(json['waist_circumference']),

      hipCircumference: _toDouble(json['hip_circumference']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "user_id": userId,

      "height": height,
      "weight": weight,

      "bmi": bmi,
      "bmr": bmr,
      "tdee": tdee,

      "target_calories": targetCalories,

      "protein_target": proteinTarget,
      "fat_target": fatTarget,
      "carbohydrate_target": carbohydrateTarget,

      "age": age,
      "gender": gender,

      "activity_level": activityLevel,
      "goal": goal,

      "waist_circumference": waistCircumference,

      "hip_circumference": hipCircumference,
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
