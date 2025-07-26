import 'package:loyalty_app/models/reward_model.dart';

import '../models/wishlist_model.dart';

class WishlistState {
  final List<Wishlist> list;
  final bool isLoading;
  final String? error;

  const WishlistState({
    this.list = const [],
    this.isLoading = false,
    this.error,
  });

  WishlistState copyWith({
    List<Wishlist>? list,
    bool? isLoading,
    String? error,
  }) {
    return WishlistState(
      list: list ?? this.list,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }

  T when<T>({
    required T Function() loading,
    required T Function(String error, StackTrace? stackTrace) error,
    required T Function(List<Wishlist> list) data,
  }) {
    if (isLoading) {
      return loading();
    } else if (this.error != null) {
      return error(this.error!, null);
    } else {
      return data(list);
    }
  }

  bool isInWishlist(String rewardId) {
    return list.any((item) => item.rewardId == rewardId);
  }
}