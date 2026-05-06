import 'package:flutter/material.dart';
import 'package:nutritrack/data/models/ingredient_model.dart';
import 'package:nutritrack/data/repository/ingredient_repository.dart';
import 'package:nutritrack/view/viewmodel/log_food_state.dart';

class LogFoodViewModel extends ValueNotifier<LogFoodState> {
  final IngredientRepository repo;

  // Singleton instance
  static LogFoodViewModel? _instance;

  factory LogFoodViewModel({required IngredientRepository repo}) {
    _instance ??= LogFoodViewModel._internal(repo);
    return _instance!;
  }

  LogFoodViewModel._internal(this.repo) : super(LogFoodState());

  Future<void> fetchIngredients() async {
    value = value.copyWith(error: null);

    try {
      final data = await repo.fetchIngredients();

      value = value.copyWith(ingredients: data);
    } catch (e) {
      value = value.copyWith(error: e.toString());
    }
  }

  /// Tambah makanan ke selected foods
  void addSelectedFood(IngredientModel food) {
    final updated = [...value.selectedFoods, food];
    value = value.copyWith(selectedFoods: updated);
  }

  /// Hapus makanan dari selected foods
  void removeSelectedFood(int foodId) {
    final updated = value.selectedFoods
        .where((food) => food.id != foodId)
        .toList();
    value = value.copyWith(selectedFoods: updated);
  }

  /// Toggle makanan (tambah/hapus)
  void toggleSelectedFood(IngredientModel food) {
    final exists = value.selectedFoods.any((f) => f.id == food.id);
    if (exists) {
      removeSelectedFood(food.id);
    } else {
      addSelectedFood(food);
    }
  }

  /// Check apakah food sudah dipilih
  bool isFoodSelected(int foodId) {
    return value.selectedFoods.any((food) => food.id == foodId);
  }

  /// Clear semua selected foods
  void clearSelectedFoods() {
    value = value.copyWith(selectedFoods: []);
  }

  /// Reset singleton instance (untuk testing atau reset state)
  static void resetInstance() {
    _instance?.dispose();
    _instance = null;
  }
}
