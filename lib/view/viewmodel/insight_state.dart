class InsightState {
  final Map<String, dynamic>? weeklyData;
  final bool isLoading;
  final String? error;
  final String? message;

  InsightState({
    this.weeklyData,
    this.isLoading = false,
    this.error,
    this.message,
  });

  List<String> get recommendations {
    final data = weeklyData?['rekomendasi'];

    if (data is List) {
      return data.map((e) => e.toString()).toList();
    }

    return [];
  }

  bool get hasData =>
      weeklyData != null && weeklyData!.isNotEmpty;

  InsightState copyWith({
    Map<String, dynamic>? weeklyData,
    bool? isLoading,
    String? error,
    String? message,
  }) {
    return InsightState(
      weeklyData: weeklyData ?? this.weeklyData,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      message: message ?? this.message,
    );
  }
}