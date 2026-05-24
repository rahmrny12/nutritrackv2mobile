import 'package:nutritrack/data/models/meal_log_model.dart';

class HistoryState {
  final bool isLoading;
  final String? error;
  final List<MealLogModel> mealLogs;

  const HistoryState({
    this.isLoading = false,
    this.error,
    this.mealLogs = const [],
  });

  HistoryState copyWith({
    bool? isLoading,
    String? error,
    List<MealLogModel>? mealLogs,
  }) {
    return HistoryState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      mealLogs: mealLogs ?? this.mealLogs,
    );
  }
}