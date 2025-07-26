import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:loyalty_app/states/login_state.dart';

import '../models/user_model.dart';
import '../services/api_service.dart';

class LoginViewModel extends StateNotifier<LoginState> {
  LoginViewModel() : super(const LoginState());

  Future<void> login({
    required String email,
    required String password,
  }) async {
    if (email.trim().isEmpty || password.trim().isEmpty) {
      state = state.copyWith(error: 'Please enter both email and password');
      return;
    }

    if (!_isValidEmail(email)) {
      state = state.copyWith(error: 'Please enter a valid email address');
      return;
    }

    state = state.copyWith(isLoading: true, error: null);

    try {
      final loginResponse = await ApiService.login(
        email: email.trim(),
        password: password,
      );

      // Set the auth token for API services
      ApiService.setAuthToken(loginResponse.token);

      state = state.copyWith(
        isLoading: false,
        isLoggedIn: true,
        user: loginResponse.user,
        token: loginResponse.token,
        error: null,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString().replaceFirst('Exception: ', ''),
      );
    }
  }

  void logout() {
    // Clear auth token from API services
    ApiService.clearAuthToken();

    state = const LoginState();
  }

  void clearError() {
    state = state.copyWith(error: null);
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }
}

final loginViewModelProvider = StateNotifierProvider<LoginViewModel, LoginState>(
      (ref) => LoginViewModel(),
);

// Additional providers for convenience
final currentUserProvider = Provider<User?>((ref) {
  final loginState = ref.watch(loginViewModelProvider);
  return loginState.user;
});

final isLoggedInProvider = Provider<bool>((ref) {
  final loginState = ref.watch(loginViewModelProvider);
  return loginState.isLoggedIn;
});

final authTokenProvider = Provider<String?>((ref) {
  final loginState = ref.watch(loginViewModelProvider);
  return loginState.token;
});