import 'package:nutritrack/data/models/screening_result_model.dart';

enum ScreeningStatus {
  initial,
  loading,
  success,
  error,
}

class ScreeningState {
  final ScreeningStatus status;
  final ScreeningResultModel? latestResult;
  final String? errorMessage;

  const ScreeningState({
    this.status = ScreeningStatus.initial,
    this.latestResult,
    this.errorMessage,
  });

  ScreeningState copyWith({
    ScreeningStatus? status,
    ScreeningResultModel? latestResult,
    String? errorMessage,
  }) {
    return ScreeningState(
      status: status ?? this.status,
      latestResult:
          latestResult ?? this.latestResult,
      errorMessage:
          errorMessage ?? this.errorMessage,
    );
  }
}