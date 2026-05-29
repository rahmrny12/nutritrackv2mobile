import 'dart:async';

import 'package:flutter/material.dart';
import 'package:nutritrack/data/repository/recipe_repository.dart';
import 'package:nutritrack/data/repository/ingredient_repository.dart';
import 'package:nutritrack/data/models/ingredient_model.dart';
import 'add_meal_state.dart';

class MealViewModel extends ValueNotifier<MealState> {
  final RecipeRepository recipeRepo;
  final IngredientRepository ingredientRepo;

  MealViewModel({required this.recipeRepo, required this.ingredientRepo})
    : super(MealState()) {
    fetchIngredients();
  }

  final namaController = TextEditingController();
  final deskripsiController = TextEditingController();
  final searchController = TextEditingController();

  Future<void> fetchIngredients() async {
    value = value.copyWith(isLoadingIngredients: true, error: null);

    try {
      final ingredients = await ingredientRepo.fetchIngredients();
      final recipeIngredients = ingredients
          .map(
            (ingredient) => RecipeIngredientItem(
              ingredientId: ingredient.id,
              name: ingredient.name,
              kcal: ingredient.caloriesPer100g.toInt(),
              protein: '${ingredient.protein}g',
              karbo: '${ingredient.carbs}g',
              gram: 100, // Default portion
            ),
          )
          .toList();

      value = value.copyWith(
        isLoadingIngredients: false,
        allIngredients: recipeIngredients,
      );
    } catch (e) {
      value = value.copyWith(isLoadingIngredients: false, error: e.toString());
    }
  }

  void updateName(String value) {
    this.value = this.value.copyWith(name: value, error: null, success: false);
  }

  void updateDescription(String value) {
    this.value = this.value.copyWith(
      description: value,
      error: null,
      success: false,
    );
  }

  void setCategory(int index) {
    value = value.copyWith(
      selectedCategory: index,
      error: null,
      success: false,
    );
  }

  void toggleFavorite(bool isFavorite) {
    value = value.copyWith(isFavorite: isFavorite, error: null, success: false);
  }

  void removeIngredient(int index) {
    final updated = [...value.ingredients]..removeAt(index);
    value = value.copyWith(ingredients: updated, error: null, success: false);
  }

  void addIngredient(RecipeIngredientItem ingredient) {
    final updated = [...value.ingredients, ingredient];
    value = value.copyWith(ingredients: updated, error: null, success: false);
  }

  Timer? _debounce;

  void updateSearchQuery(String query) {
    value = value.copyWith(searchQuery: query);

    _debounce?.cancel();

    _debounce = Timer(const Duration(milliseconds: 400), () async {
      await _searchIngredients(query);
    });
  }

  Future<void> _searchIngredients(String query) async {
    value = value.copyWith(isLoadingIngredients: true, error: null);

    try {
      final ingredients = await ingredientRepo.searchIngredients(query);

      final mapped = ingredients.map((ingredient) {
        return RecipeIngredientItem(
          ingredientId: ingredient.id,
          name: ingredient.name,
          kcal: ingredient.caloriesPer100g.toInt(),
          protein: '${ingredient.protein}g',
          karbo: '${ingredient.carbs}g',
          gram: 100,
        );
      }).toList();

      value = value.copyWith(
        isLoadingIngredients: false,
        allIngredients: mapped,
      );
    } catch (e) {
      value = value.copyWith(isLoadingIngredients: false, error: e.toString());
    }
  }

  void addIngredientToRecipe(RecipeIngredientItem ingredient) {
    final updated = [...value.ingredients, ingredient];
    value = value.copyWith(ingredients: updated, error: null, success: false);
  }

  void toggleIngredientInRecipe(RecipeIngredientItem ingredient) {
    final current = [...value.ingredients];

    final index = current.indexWhere(
      (item) => item.ingredientId == ingredient.ingredientId,
    );

    if (index >= 0) {
      // REMOVE
      current.removeAt(index);
    } else {
      // ADD
      current.add(ingredient);
    }

    value = value.copyWith(ingredients: current, error: null, success: false);
  }

  Future<void> submitRecipe() async {
    value = value.copyWith(isLoading: true, error: null, success: false);

    try {
      await recipeRepo.createRecipe(
        name: namaController.text,
        isFavorite: value.isFavorite,
        desc: deskripsiController.text,
        ingredients: value.ingredients,
      );

      value = value.copyWith(
        isLoading: false,
        success: true,
        ingredients: [], // optional reset
      );
    } catch (e) {
      value = value.copyWith(
        isLoading: false,
        error: e.toString(),
        success: false,
      );
    }
  }

  @override
  void dispose() {
    namaController.dispose();
    deskripsiController.dispose();
    searchController.dispose();
    super.dispose();
  }
}
