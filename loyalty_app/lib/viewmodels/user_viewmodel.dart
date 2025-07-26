import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/user_model.dart';
import '../services/api_service.dart';
import '../states/user_state.dart';

class UserViewModel extends StateNotifier<UserState> {
  UserViewModel() : super(UserState()) {
    // loadUserProfile();
  }

  // Future<void> loadUserProfile() async {
  //   state = state.copyWith(isLoading: true, error: null);
  //   try {
  //     final user = await ApiService.fetchUserProfile();
  //     print('asdasd ${user.firstname}');// returns UserModel
  //     state = state.copyWith(user: user, isLoading: false);
  //   } catch (e) {
  //     state = state.copyWith(error: e.toString(), isLoading: false);
  //   }
  // }

  Future<void> usePoints(int pointsToUse) async {
    if (state == null) return;

    try {
      final updatedPoints = await ApiService.usePoints(pointsToUse);
      state = state.copyWith(
        user: state.user!.copyWith(points: updatedPoints),
      );

    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }

  void updateUser(User updatedUser) {
    state = state.copyWith(user: updatedUser);
  }
}

final userViewModelProvider =
StateNotifierProvider<UserViewModel, UserState>((ref) => UserViewModel());