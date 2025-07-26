import 'package:loyalty_app/models/reward_model.dart';

class RewardListState {
  final List<Reward> items;
  final bool isLoading;
  final String? error;

  const RewardListState({
    this.items = const [],
    this.isLoading = false,
    this.error,
  });

  RewardListState copyWith({
    List<Reward>? items,
    bool? isLoading,
    String? error,
  }) {
    return RewardListState(
      items: items ?? this.items,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }

  T when<T>({
    required T Function() loading,
    required T Function(String error, StackTrace? stackTrace) error,
    required T Function(List<Reward> list) data,
  }) {
    if (isLoading) {
      return loading();
    } else if (this.error != null) {
      return error(this.error!, null);
    } else {
      return data(items);
    }
  }
}