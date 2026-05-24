import 'package:nutritrack/core/api_service.dart';
import 'package:nutritrack/data/models/screening_result_model.dart';

class ScreeningRepository {
  final ApiService api;

  ScreeningRepository(this.api);

  Future<ScreeningResultModel> saveScreeningResult(
    ScreeningResultModel result,
  ) async {
    final response = await api.post(
      '/screenings',
      result.toJson(),
    );

    final statusCode = response['statusCode'];
    final data = response['data'];

    if (statusCode != 200 && statusCode != 201) {
      throw Exception(
        data['message'] ?? 'Failed to save screening result',
      );
    }

    return ScreeningResultModel.fromJson(data);
  }

  Future<ScreeningResultModel?> getLastScreeningResult(
    String screeningType,
  ) async {
    final response = await api.get(
      '/screenings/latest/$screeningType',
    );

    final statusCode = response['statusCode'];
    final data = response['data'];

    if (statusCode == 404 || data == null) {
      return null;
    }

    if (statusCode != 200) {
      throw Exception(
        data['message'] ?? 'Failed to load screening result',
      );
    }

    return ScreeningResultModel.fromJson(data);
  }
}