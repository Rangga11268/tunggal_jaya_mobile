import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/api_client.dart';

class SearchRepository {
  final ApiClient _apiClient;

  SearchRepository(this._apiClient);

  Future<Map<String, dynamic>> getOriginsDestinations() async {
    return await _apiClient.get('/routes/origins-destinations');
  }

  Future<Map<String, dynamic>> getSchedule(String id) async {
    return await _apiClient.get('/schedules/$id');
  }

  Future<Map<String, dynamic>> getSchedules({
    required String origin,
    required String destination,
    required String date,
  }) async {
    return await _apiClient.get('/schedules', queryParameters: {
      'origin': origin,
      'destination': destination,
      'date': date,
    });
  }
}

final searchRepositoryProvider = Provider<SearchRepository>((ref) {
  final apiClient = ref.read(apiClientProvider);
  return SearchRepository(apiClient);
});

final originsDestinationsProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  final repository = ref.read(searchRepositoryProvider);
  return await repository.getOriginsDestinations();
});
