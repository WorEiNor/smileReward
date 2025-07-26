import 'package:loyalty_app/models/reward_model.dart';

class RewardDetailState {
  final Reward? reward;
  final bool isLoading;
  final String? error;

  const RewardDetailState({
    this.reward,
    this.isLoading = false,
    this.error,
  });

  RewardDetailState copyWith({
    Reward? reward,
    bool? isLoading,
    String? error,
  }) {
    return RewardDetailState(
      reward: reward ?? this.reward,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}