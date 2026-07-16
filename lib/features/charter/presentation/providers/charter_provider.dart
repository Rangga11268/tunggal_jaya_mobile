import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/charter_repository.dart';

final charterHistoryProvider = FutureProvider.autoDispose<List<dynamic>>((ref) async {
  final repo = ref.watch(charterRepositoryProvider);
  return await repo.getCharterHistory();
});

class CharterRequestNotifier extends StateNotifier<AsyncValue<void>> {
  final CharterRepository _repository;

  CharterRequestNotifier(this._repository) : super(const AsyncValue.data(null));

  Future<void> submitRequest(Map<String, dynamic> data) async {
    state = const AsyncValue.loading();
    try {
      await _repository.submitCharterRequest(data);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> cancelCharter(int charterId) async {
    state = const AsyncValue.loading();
    try {
      await _repository.cancelCharter(charterId);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

final charterRequestProvider = StateNotifierProvider<CharterRequestNotifier, AsyncValue<void>>((ref) {
  final repo = ref.watch(charterRepositoryProvider);
  return CharterRequestNotifier(repo);
});
