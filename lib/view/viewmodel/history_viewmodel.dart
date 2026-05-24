import 'package:flutter/material.dart';
import 'package:nutritrack/data/repository/meal_log_repository.dart';
import 'package:nutritrack/view/viewmodel/history_state.dart';

class HistoryViewModel extends ValueNotifier<HistoryState> {
  final MealLogRepository repo;

  HistoryViewModel({required this.repo}) : super(const HistoryState());

  Future<void> fetchMealLogs({DateTime? startDate, DateTime? endDate}) async {
    value = value.copyWith(isLoading: true, error: null);

    try {
      final mealLogs = await repo.fetchMealLogs(
        startDate: startDate,
        endDate: endDate,
      );

      value = value.copyWith(isLoading: false, mealLogs: mealLogs);
    } catch (e) {
      value = value.copyWith(isLoading: false, error: e.toString());
    }
  }

  double get totalKcal {
    return value.mealLogs.fold(0.0, (sum, log) => sum + log.totalCalories);
  }

  bool get isEmpty => value.mealLogs.isEmpty;
}
