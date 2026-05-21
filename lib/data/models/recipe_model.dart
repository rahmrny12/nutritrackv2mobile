import 'package:nutritrack/data/models/recipe_ingredient_model.dart';

class RecipeModel {
  final int id;
  final int userId;
  final String name;
  final String? image;
  final bool isFavorite;
  final String? desc;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<RecipeIngredientModel> ingredients;

  RecipeModel({
    required this.id,
    required this.userId,
    required this.name,
    required this.image,
    required this.isFavorite,
    required this.desc,
    required this.createdAt,
    required this.updatedAt,
    required this.ingredients,
  });

  factory RecipeModel.fromJson(Map<String, dynamic> json) {
    int parseInt(dynamic value) {
      if (value is int) return value;
      return int.tryParse(value.toString()) ?? 0;
    }

    return RecipeModel(
      id: parseInt(json['id']),

      userId: parseInt(json['user_id']),

      name: json['name'].toString(),

      image: json['image']?.toString(),

      isFavorite:
          json['is_favorite'] == 1 ||
          json['is_favorite'] == '1' ||
          json['is_favorite'] == true,

      desc: json['desc']?.toString(),

      createdAt: DateTime.parse(json['created_at'].toString()),

      updatedAt: DateTime.parse(json['updated_at'].toString()),

      ingredients: (json['ingredients'] as List<dynamic>?)
              ?.map(
                (e) => RecipeIngredientModel.fromJson(
                  e as Map<String, dynamic>,
                ),
              )
              .toList() ??
          [],
    );
  }
}