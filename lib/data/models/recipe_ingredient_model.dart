import 'package:nutritrack/data/models/ingredient_model.dart';

class RecipeIngredientModel {
  final int id;
  final int recipeId;
  final int ingredientId;
  final double quantityGram;
  final IngredientModel ingredient;

  RecipeIngredientModel({
    required this.id,
    required this.recipeId,
    required this.ingredientId,
    required this.quantityGram,
    required this.ingredient,
  });

  factory RecipeIngredientModel.fromJson(Map<String, dynamic> json) {
    return RecipeIngredientModel(
      id: json['id'],
      recipeId: json['recipe_id'],
      ingredientId: json['ingredient_id'],
      quantityGram: (json['quantity_gram'] as num).toDouble(),
      ingredient: IngredientModel.fromJson(json['ingredient']),
    );
  }
}