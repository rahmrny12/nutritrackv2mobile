import 'package:nutritrack/data/models/ingredient_model.dart';

class LogFoodState {
  final List<IngredientModel> ingredients;
  final List<IngredientModel> selectedFoods;
  final String? error;

  LogFoodState({
    this.ingredients = const [],
    this.selectedFoods = const [],
    this.error,
  });

  /// Total kalori dari semua selected foods
  int get totalKcal =>
      selectedFoods.fold(0, (sum, food) => sum + food.totalKcal);

  /// Total protein dari semua selected foods
  double get totalProtein => selectedFoods.fold(
      0.0, (sum, food) => sum + food.getProtein() as double);

  /// Total carbs dari semua selected foods
  double get totalCarbs =>
      selectedFoods.fold(0.0, (sum, food) => sum + food.getCarbs() as double);

  /// Total fat dari semua selected foods
  double get totalFat =>
      selectedFoods.fold(0.0, (sum, food) => sum + food.getFat() as double);

  int get totalItems => selectedFoods.length;

  LogFoodState copyWith({
    List<IngredientModel>? ingredients,
    List<IngredientModel>? selectedFoods,
    String? error,
  }) {
    return LogFoodState(
      ingredients: ingredients ?? this.ingredients,
      selectedFoods: selectedFoods ?? this.selectedFoods,
      error: error,
    );
  }
}
