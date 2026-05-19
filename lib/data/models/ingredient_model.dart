import 'dart:io';

class IngredientModel {
  final int id;
  final String name;
  final double caloriesPer100g;
  final double protein;
  final double carbs;
  final double fat;
  final String? emoji;
  final double? portion; // dalam gram
  final String? image; // optional field

  IngredientModel({
    required this.id,
    required this.name,
    required this.caloriesPer100g,
    required this.protein,
    required this.carbs,
    required this.fat,
    this.emoji,
    this.portion,
    this.image,
  });

  /// Hitung total kalori berdasarkan portion
  int get totalKcal {
    if (portion == null) return caloriesPer100g.toInt();
    return ((caloriesPer100g * portion!) / 100).toInt();
  }

  /// Hitung protein berdasarkan portion
  double getProtein() {
    if (portion == null) return protein;
    return (protein * portion!) / 100;
  }

  /// Hitung carbs berdasarkan portion
  double getCarbs() {
    if (portion == null) return carbs;
    return (carbs * portion!) / 100;
  }

  /// Hitung fat berdasarkan portion
  double getFat() {
    if (portion == null) return fat;
    return (fat * portion!) / 100;
  }

  factory IngredientModel.fromJson(Map<String, dynamic> json) {
    return IngredientModel(
      id: json['id'] as int,
      name: json['name'] as String,

      caloriesPer100g: double.parse(json['calories_per_100g'].toString()),
      protein: double.parse(json['protein'].toString()),
      carbs: double.parse(json['carbs'].toString()),
      fat: double.parse(json['fat'].toString()),

      image: json['image'] as String?, // ✅ ADD THIS
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'calories_per_100g': caloriesPer100g,
      'protein': protein,
      'carbs': carbs,
      'fat': fat,
      'image': image,
    };
  }
}
