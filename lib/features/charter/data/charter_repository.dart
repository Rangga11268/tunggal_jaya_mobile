import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/api_client.dart';

final charterRepositoryProvider = Provider<CharterRepository>((ref) {
  final apiClient = ref.read(apiClientProvider);
  return CharterRepository(apiClient);
});

class CharterRepository {
  final ApiClient _apiClient;

  CharterRepository(this._apiClient);

  Future<List<dynamic>> getCharterHistory() async {
    final response = await _apiClient.get('/charter/history');
    return response['data'] ?? [];
  }

  Future<dynamic> submitCharterRequest(Map<String, dynamic> data) async {
    return await _apiClient.post('/charter/request', data: data);
  }

  Future<dynamic> cancelCharter(int charterId) async {
    return await _apiClient.post('/charter/$charterId/cancel', data: {});
  }
}
