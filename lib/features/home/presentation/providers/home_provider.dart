import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/config/api_endpoints.dart';

final popularRoutesProvider = FutureProvider<List<dynamic>>((ref) async {
  final api = ref.read(apiClientProvider);
  final res = await api.get(ApiEndpoints.schedules);
  final data = res['data'];
  if (data is Map<String, dynamic> && data.containsKey('data')) {
    // Handling Laravel pagination wrapper if any
    return data['data'] as List<dynamic>;
  }
  return data as List<dynamic>? ?? [];
});

final latestNewsProvider = FutureProvider<List<dynamic>>((ref) async {
  final api = ref.read(apiClientProvider);
  final res = await api.get(ApiEndpoints.news);
  final data = res['data'];
  if (data is Map<String, dynamic> && data.containsKey('data')) {
    return data['data'] as List<dynamic>;
  }
  return data as List<dynamic>? ?? [];
});

final fleetProvider = FutureProvider<List<dynamic>>((ref) async {
  final api = ref.read(apiClientProvider);
  final res = await api.get('/buses'); // Ad-hoc endpoint
  return res['data'] as List<dynamic>? ?? [];
});

final promoProvider = FutureProvider<List<dynamic>>((ref) async {
  final api = ref.read(apiClientProvider);
  final res = await api.get('/promos'); // Ad-hoc endpoint
  return res['data'] as List<dynamic>? ?? [];
});

final originsDestinationsProvider = FutureProvider<Map<String, List<String>>>((ref) async {
  final api = ref.read(apiClientProvider);
  final res = await api.get('/routes/origins-destinations');
  final data = res['data'];
  if (data is Map<String, dynamic>) {
    final origins = (data['origins'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [];
    final destinations = (data['destinations'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [];
    return {'origins': origins, 'destinations': destinations};
  }
  return {'origins': [], 'destinations': []};
});
