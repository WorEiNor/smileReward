// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:loyalty_app/states/wishlist_state.dart';
//
// import '../services/api_service.dart';
//
// class WishlistViewModel extends StateNotifier<WishlistState> {
//   WishlistViewModel() : super(const WishlistState()) {
//     loadlist();
//   }
//
//   Future<void> loadlist() async {
//     if (state.list.isEmpty) {
//       state = state.copyWith(isLoading: true, error: null);
//     }
//
//     try {
//       final list = await ApiService.fetchWishlist();
//       state = state.copyWith(
//         list: list,
//         isLoading: false,
//         error: null,
//       );
//     } catch (e) {
//       state = state.copyWith(
//         isLoading: false,
//         error: e.toString(),
//       );
//     }
//   }
//
//   Future<void> refreshlist() async {
//     state = state.copyWith(error: null);
//
//     try {
//       final list = await ApiService.fetchWishlist();
//       state = state.copyWith(
//         list: list,
//         error: null,
//       );
//     } catch (e) {
//       state = state.copyWith(
//         error: e.toString(),
//       );
//     }
//   }
//
//   Future<void> addToWishlist(String rewardId) async {
//     try {
//       await ApiService.addToWishlist(rewardId);
//       await refreshlist(); // Refresh to get updated list
//     } catch (e) {
//       state = state.copyWith(error: e.toString());
//       rethrow;
//     }
//   }
//
//   Future<void> removeFromWishlist(String rewardId) async {
//     try {
//       await ApiService.removeFromWishlist(rewardId);
//       await refreshlist(); // Refresh to get updated list
//     } catch (e) {
//       state = state.copyWith(error: e.toString());
//       rethrow;
//     }
//   }
//
//   Future<void> toggleWishlist(String rewardId) async {
//     try {
//       final isCurrentlyInWishlist = state.isInWishlist(rewardId);
//
//       if (isCurrentlyInWishlist) {
//         await removeFromWishlist(rewardId);
//       } else {
//         await addToWishlist(rewardId);
//       }
//     } catch (e) {
//       // Error handling is done in addToWishlist/removeFromWishlist
//       rethrow;
//     }
//   }
//
//   bool isInWishlist(String rewardId) {
//     return state.isInWishlist(rewardId);
//   }
//
//   void clearError() {
//     state = state.copyWith(error: null);
//   }
// }
//
// final wishlistViewModelProvider = StateNotifierProvider<WishlistViewModel, WishlistState>(
//       (ref) => WishlistViewModel(),
// );
//
// // Additional providers for convenience
// final isInWishlistProvider = Provider.family<bool, String>((ref, rewardId) {
//   final wishlistState = ref.watch(wishlistViewModelProvider);
//   return wishlistState.isInWishlist(rewardId);
// });

import 'package:flutter_riverpod/flutter_riverpod.dart';

class WishlistViewModel extends StateNotifier<Set<String>> {
  WishlistViewModel() : super(<String>{});

  void toggleWishlist(String itemId) {
    if (state.contains(itemId)) {
      state = {...state}..remove(itemId);
    } else {
      state = {...state, itemId};
    }
  }

  bool isInWishlist(String itemId) {
    return state.contains(itemId);
  }
}

final wishlistViewModelProvider = StateNotifierProvider<WishlistViewModel, Set<String>>(
      (ref) => WishlistViewModel(),
);