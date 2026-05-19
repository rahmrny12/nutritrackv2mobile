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
    return FoodLogModel(
      id: json['id'] as int,
      mealLogId: json['meal_log_id'] as int,
      type: json['type'] as String,
      ingredientId: json['ingredient_id'] as int?,
      recipeId: json['recipe_id'] as int?,
      nameManual: json['name_manual'] as String?,
      caloriesManual: json['calories_manual'] != null
          ? double.tryParse(json['calories_manual'].toString())
          : null,
      quantity: json['quantity'] is int
          ? json['quantity'] as int
          : int.tryParse(json['quantity'].toString()) ?? 0,
      ingredient: json['ingredient'] != null
          ? IngredientModel.fromJson(json['ingredient'])
          : null,

      recipe: json['recipe'] != null
          ? RecipeModel.fromJson(json['recipe'])
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
      id: json['id'],
      userId: json['user_id'],
      mealType: json['meal_type'],

      totalCalories: (json['total_calories'] as num).toDouble(),

      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),

      foodLogs:
          (json['food_logs'] as List<dynamic>?)
              ?.map((e) => FoodLogModel.fromJson(e))
              .toList() ??
          [],
    );
  }
}
