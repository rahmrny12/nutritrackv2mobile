class ScreeningResultModel {
  final String screeningType; // 'gout', 'diabetes', 'heart'
  final String level; // 'Risiko Rendah', 'Risiko Sedang', 'Risiko Tinggi'
  final int totalScore;
  final int riskFactorScore;
  final int symptomScore;
  final int modifierScore;
  final Map<String, dynamic> answers;
  final DateTime timestamp;

  ScreeningResultModel({
    required this.screeningType,
    required this.level,
    required this.totalScore,
    required this.riskFactorScore,
    required this.symptomScore,
    required this.modifierScore,
    required this.answers,
    required this.timestamp,
  });

  factory ScreeningResultModel.fromJson(Map<String, dynamic> json) {
    int toInt(dynamic value) {
      if (value == null) return 0;

      if (value is int) return value;

      if (value is double) return value.toInt();

      if (value is String) {
        return int.tryParse(value) ?? double.tryParse(value)?.toInt() ?? 0;
      }

      return 0;
    }

    return ScreeningResultModel(
      screeningType: json['screening_type']?.toString() ?? '',
      level: json['level']?.toString() ?? '',

      totalScore: toInt(json['total_score']),
      riskFactorScore: toInt(json['risk_factor_score']),
      symptomScore: toInt(json['symptom_score']),
      modifierScore: toInt(json['modifier_score']),

      answers: json['answers'] is Map<String, dynamic> ? json['answers'] : {},

      timestamp:
          DateTime.tryParse(json['timestamp']?.toString() ?? '') ??
          DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'screening_type': screeningType,
      'level': level,
      'total_score': totalScore,
      'risk_factor_score': riskFactorScore,
      'symptom_score': symptomScore,
      'modifier_score': modifierScore,
      'answers': answers,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}
