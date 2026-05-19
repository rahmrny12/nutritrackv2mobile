import 'package:nutritrack/data/models/ingredient_model.dart';
import 'package:nutritrack/data/models/recipe_model.dart';

enum LogFoodTabType { ingredient, recipe }

class LogFoodState {
  final List<IngredientModel> ingredients;
  final List<IngredientModel> selectedFoods;
  final List<RecipeModel> recipes;
  final List<RecipeModel> selectedRecipes;

  final LogFoodTabType tab; // ✅ ADD THIS

  final bool isLoading;
  final String? error;
  final String? message;

  LogFoodState({
    this.isLoading = false,
    this.ingredients = const [],
    this.selectedFoods = const [],
    this.recipes = const [],
    this.selectedRecipes = const [],
    this.tab = LogFoodTabType.ingredient, // default tab
    this.error,
    this.message,
  });

  /// TOTAL NUTRITION
  int get totalKcal =>
      selectedFoods.fold(0, (sum, food) => sum + food.totalKcal);

  double get totalProtein =>
      selectedFoods.fold(0.0, (sum, food) => sum + food.getProtein());

  double get totalCarbs =>
      selectedFoods.fold(0.0, (sum, food) => sum + food.getCarbs());

  double get totalFat =>
      selectedFoods.fold(0.0, (sum, food) => sum + food.getFat());

  int get totalItems => selectedFoods.length;

  LogFoodState copyWith({
    List<IngredientModel>? ingredients,
    List<IngredientModel>? selectedFoods,
    List<RecipeModel>? recipes,
    List<RecipeModel>? selectedRecipes,
    LogFoodTabType? tab, // ✅ ADD THIS
    bool? isLoading,
    String? error,
    String? message,
  }) {
    return LogFoodState(
      ingredients: ingredients ?? this.ingredients,
      selectedFoods: selectedFoods ?? this.selectedFoods,
      recipes: recipes ?? this.recipes,
      selectedRecipes: selectedRecipes ?? this.selectedRecipes,
      tab: tab ?? this.tab,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      message: message ?? this.message,
    );
  }
}