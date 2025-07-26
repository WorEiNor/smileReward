import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/api_service.dart';
import '../states/reward_detail_state.dart';

class RewardDetailViewModel extends StateNotifier<RewardDetailState> {
  final String rewardId;

  RewardDetailViewModel(this.rewardId) : super(const RewardDetailState()) {
    loadReward();
  }

  Future<void> loadReward() async {
    if (state.reward == null) {
      state = state.copyWith(isLoading: true, error: null);
    }

    try {
      final reward = await ApiService.fetchRewardById(rewardId);
      state = state.copyWith(
        reward: reward,
        isLoading: false,
        error: null,
      );
    } catch (e) {
      state = state.copyWith(
        reward: null,
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> refreshReward() async {
    state = state.copyWith(error: null);

    try {
      final reward = await ApiService.fetchRewardById(rewardId);
      state = state.copyWith(
        reward: reward,
        error: null,
      );
    } catch (e) {
      state = state.copyWith(
        error: e.toString(),
      );
    }
  }

  // Helper methods
  bool canAffordReward(int userPoints) {
    if (state.reward == null) return false;
    return userPoints >= state.reward!.points;
  }

  String get formattedPoints {
    if (state.reward == null) return '0';
    return state.reward!.points.toString();
  }

  String get imageUrl {
    if (state.reward?.imageUrl == null || state.reward!.imageUrl.isEmpty) {
      return 'https://via.placeholder.com/300x200?text=No+Image';
    }
    return state.reward!.imageUrl;
  }

  bool get hasDescription {
    return state.reward?.description != null && state.reward!.description.isNotEmpty;
  }

  bool get isNotFound {
    return state.error?.contains('not found') == true ||
        state.error?.contains('404') == true;
  }
}

// Provider that takes rewardId as parameter
final rewardDetailViewModelProvider =
StateNotifierProvider.family<RewardDetailViewModel, RewardDetailState, String>(
      (ref, rewardId) => RewardDetailViewModel(rewardId),
);