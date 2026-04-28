import 'package:flutter/material.dart';
import 'package:nutritrack/data/models/ingredient_model.dart';
import 'package:nutritrack/view/viewmodel/log_food_state.dart';

class LogFoodViewModel extends ValueNotifier<LogFoodState> {
  // Singleton instance
  static LogFoodViewModel? _instance;

  // Factory constructor untuk singleton
  factory LogFoodViewModel() {
    _instance ??= LogFoodViewModel._internal();
    return _instance!;
  }

  // Private constructor
  LogFoodViewModel._internal() : super(LogFoodState());

  /// Tambah makanan ke selected foods
  void addFood(IngredientModel food) {
    final updated = [...value.selectedFoods, food];
    value = value.copyWith(selectedFoods: updated);
  }

  /// Hapus makanan dari selected foods
  void removeFood(int foodId) {
    final updated =
        value.selectedFoods.where((food) => food.id != foodId).toList();
    value = value.copyWith(selectedFoods: updated);
  }

  /// Toggle makanan (tambah/hapus)
  void toggleFood(IngredientModel food) {
    final exists = value.selectedFoods.any((f) => f.id == food.id);
    if (exists) {
      removeFood(food.id);
    } else {
      addFood(food);
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