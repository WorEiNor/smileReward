import 'package:flutter_riverpod/flutter_riverpod.dart';

class WishlistViewModel extends StateNotifier<Set<int>> {
  WishlistViewModel() : super(<int>{});

  void toggleWishlist(int itemId) {
    if (state.contains(itemId)) {
      state = {...state}..remove(itemId);
    } else {
      state = {...state, itemId};
    }
  }

  bool isInWishlist(int itemId) {
    return state.contains(itemId);
  }
}

final wishlistViewModelProvider = StateNotifierProvider<WishlistViewModel, Set<int>>(
  (ref) => WishlistViewModel(),
);