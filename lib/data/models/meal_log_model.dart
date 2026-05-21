import 'package:nutritrack/data/models/ingredient_model.dart';
import 'package:nutritrack/data/models/recipe_model.dart';

class FoodLogModel {
  final int id;
  final int mealLogId;
  final String type;
  final int? ingredientId;
  final int? recipeId;
  final String? nameManual;
  final double? caloriesManual;
  final int quantity;
  final IngredientModel? ingredient;
  final RecipeModel? recipe;

  FoodLogModel({
    required this.id,
    required this.mealLogId,
    required this.type,
    this.ingredientId,
    this.recipeId,
    this.nameManual,
    this.caloriesManual,
    required this.quantity,
    this.ingredient,
    this.recipe,
  });

  factory FoodLogModel.fromJson(Map<String, dynamic> json) {
    int? parseNullableInt(dynamic value) {
      if (value == null) return null;
      if (value is int) return value;
      return int.tryParse(value.toString());
    }

    return FoodLogModel(
      id: json['id'] is int
          ? json['id']
          : int.tryParse(json['id'].toString()) ?? 0,

      mealLogId: json['meal_log_id'] is int
          ? json['meal_log_id']
          : int.tryParse(json['meal_log_id'].toString()) ?? 0,

      type: json['type'].toString(),

      ingredientId: parseNullableInt(json['ingredient_id']),

      recipeId: parseNullableInt(json['recipe_id']),

      nameManual: json['name_manual']?.toString(),

      caloriesManual: json['calories_manual'] != null
          ? double.tryParse(json['calories_manual'].toString())
          : null,

      quantity: json['quantity'] is int
          ? json['quantity']
          : int.tryParse(json['quantity'].toString()) ?? 0,

      ingredient: json['ingredient'] != null
          ? IngredientModel.fromJson(json['ingredient'] as Map<String, dynamic>)
          : null,

      recipe: json['recipe'] != null
          ? RecipeModel.fromJson(json['recipe'] as Map<String, dynamic>)
          : null,
    );
  }
}

class MealLogModel {
  final int id;
  final int userId;
  final String mealType;
  final double totalCalories;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<FoodLogModel> foodLogs;

  MealLogModel({
    required this.id,
    required this.userId,
    required this.mealType,
    required this.totalCalories,
    required this.createdAt,
    required this.updatedAt,
    required this.foodLogs,
  });

  factory MealLogModel.fromJson(Map<String, dynamic> json) {
    return MealLogModel(
      id: json['id'] is int
          ? json['id']
          : int.tryParse(json['id'].toString()) ?? 0,

      userId: json['user_id'] is int
          ? json['user_id']
          : int.tryParse(json['user_id'].toString()) ?? 0,

      mealType: json['meal_type'].toString(),

      totalCalories: json['total_calories'] is num
          ? (json['total_calories'] as num).toDouble()
          : double.tryParse(json['total_calories'].toString()) ?? 0,

      createdAt: DateTime.parse(json['created_at'].toString()),
      updatedAt: DateTime.parse(json['updated_at'].toString()),

      foodLogs:
          (json['food_logs'] as List<dynamic>?)
              ?.map((e) => FoodLogModel.fromJson(e))
              .toList() ??
          [],
    );
  }
}
