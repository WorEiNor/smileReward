import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loyalty_app/services/api_service.dart';
import 'package:loyalty_app/states/reward_list_state.dart';

class RewardListViewModel extends StateNotifier<RewardListState> {
  RewardListViewModel() : super(const RewardListState()) {
    loadItems();
  }

  Future<void> loadItems() async {
    if (state.items.isEmpty) {
      state = state.copyWith(isLoading: true, error: null);
    }

    try {
      final items = await ApiService.fetchRewards();
      state = state.copyWith(
        items: items,
        isLoading: false,
        error: null,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> refreshItems() async {
    state = state.copyWith(error: null);
    
    try {
      final items = await ApiService.fetchRewards();
      state = state.copyWith(
        items: items,
        error: null,
      );
    } catch (e) {
      state = state.copyWith(
        error: e.toString(),
      );
    }
  }

}

final rewardListViewModelProvider = StateNotifierProvider<RewardListViewModel, RewardListState>(
  (ref) => RewardListViewModel(),
);