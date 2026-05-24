import 'package:flutter/material.dart';
import 'package:nutritrack/data/models/gout_screening_form_model.dart';
import 'package:nutritrack/data/models/screening_result_model.dart';
import 'package:nutritrack/data/repository/screening_repository.dart';
import 'package:nutritrack/view/viewmodel/screening_state.dart';

class ScreeningViewModel extends ValueNotifier<ScreeningState> {
  final ScreeningRepository repository;

  ScreeningViewModel(this.repository) : super(const ScreeningState());

  final form = GoutScreeningFormModel();

  ScreeningState get state => value;

  bool get isCompleted => form.isCompleted;

  void updateAnswer({
    required String key,
    required String value,
  }) {
    switch (key) {
      case 'riwayatKeluarga':
        form.riwayatKeluarga = value;
        break;

      case 'pernahAsamUrat':
        form.pernahAsamUrat = value;
        break;

      case 'konsumsiPurin':
        form.konsumsiPurin = value;
        break;

      case 'minumanManis':
        form.minumanManis = value;
        break;

      case 'beratBadan':
        form.beratBadan = value;
        break;

      case 'hipertensiGinjal':
        form.hipertensiGinjal = value;
        break;

      case 'alkohol':
        form.alkohol = value;
        break;

      case 'nyeriSendi':
        form.nyeriSendi = value;
        break;

      case 'bengkakSendi':
        form.bengkakSendi = value;
        break;

      case 'nyeriIbuJari':
        form.nyeriIbuJari = value;
        break;
    }

    notifyListeners();
  }

  ScreeningResultModel calculateResult() {
    int riskFactorScore = 0;
    int symptomScore = 0;
    int modifier = 0;

    switch (form.konsumsiPurin) {
      case 'Kadang':
        riskFactorScore += 1;
        break;
      case 'Sering':
        riskFactorScore += 2;
        break;
    }

    switch (form.minumanManis) {
      case 'Kadang':
        riskFactorScore += 1;
        break;
      case 'Sering':
        riskFactorScore += 2;
        break;
    }

    switch (form.alkohol) {
      case 'Kadang':
        riskFactorScore += 1;
        break;
      case 'Sering':
        riskFactorScore += 2;
        break;
    }

    if (form.beratBadan == 'Ya') {
      riskFactorScore += 2;
    }

    if (form.hipertensiGinjal == 'Ya') {
      riskFactorScore += 2;
    }

    switch (form.nyeriSendi) {
      case 'Kadang':
        symptomScore += 2;
        break;
      case 'Sering':
        symptomScore += 4;
        break;
    }

    switch (form.bengkakSendi) {
      case 'Kadang':
        symptomScore += 2;
        break;
      case 'Sering':
        symptomScore += 4;
        break;
    }

    switch (form.nyeriIbuJari) {
      case 'Kadang':
        symptomScore += 3;
        break;
      case 'Sering':
        symptomScore += 5;
        break;
    }

    if (form.riwayatKeluarga == 'Ya') {
      modifier += 1;
    }

    if (form.pernahAsamUrat == 'Pernah') {
      modifier += 2;
    }

    final totalScore =
        riskFactorScore + symptomScore + modifier;

    String level;

    if (symptomScore >= 10 || totalScore >= 16) {
      level = 'Risiko Tinggi';
    } else if (symptomScore >= 5 || totalScore >= 9) {
      level = 'Risiko Sedang';
    } else {
      level = 'Risiko Rendah';
    }

    return ScreeningResultModel(
      screeningType: 'gout',
      level: level,
      totalScore: totalScore,
      riskFactorScore: riskFactorScore,
      symptomScore: symptomScore,
      modifierScore: modifier,
      answers: form.toJson(),
      timestamp: DateTime.now(),
    );
  }

  Future<void> saveResult() async {
    try {
      value = value.copyWith(
        status: ScreeningStatus.loading,
        errorMessage: null,
      );

      final result = calculateResult();

      final savedResult =
          await repository.saveScreeningResult(
        result,
      );

      value = value.copyWith(
        status: ScreeningStatus.success,
        latestResult: savedResult,
      );
    } catch (e) {
      value = value.copyWith(
        status: ScreeningStatus.error,
        errorMessage: e.toString(),
      );
    }
  }

  Future<ScreeningResultModel?> fetchLatestResult(
    String screeningType,
  ) async {
    try {
      value = value.copyWith(
        status: ScreeningStatus.loading,
        errorMessage: null,
      );

      final result =
          await repository.getLastScreeningResult(screeningType);

      value = value.copyWith(
        status: ScreeningStatus.success,
        latestResult: result,
      );

      return result;
    } catch (e) {
      value = value.copyWith(
        status: ScreeningStatus.error,
        errorMessage: e.toString(),
      );
      return null;
    }
  }

  Future<void> fetchAllLatestResults() async {
    try {
      value = value.copyWith(
        status: ScreeningStatus.loading,
        errorMessage: null,
      );

      final goutResult = await repository.getLastScreeningResult('gout');
      final diabetesResult = await repository.getLastScreeningResult('diabetes');
      final heartResult = await repository.getLastScreeningResult('heart');

      final results = [
        goutResult,
        diabetesResult,
        heartResult,
      ].whereType<ScreeningResultModel>().toList();

      ScreeningResultModel? latestResult;
      if (results.isNotEmpty) {
        results.sort((a, b) => b.timestamp.compareTo(a.timestamp));
        latestResult = results.first;
      }

      value = value.copyWith(
        status: ScreeningStatus.success,
        latestResult: latestResult,
      );
    } catch (e) {
      value = value.copyWith(
        status: ScreeningStatus.error,
        errorMessage: e.toString(),
      );
    }
  }

  void resetState() {
    value = const ScreeningState();
  }
}