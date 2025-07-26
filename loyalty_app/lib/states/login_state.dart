import '../models/user_model.dart';

class LoginState {
  final bool isLoading;
  final String? error;
  final bool isLoggedIn;
  final User? user;
  final String? token;

  const LoginState({
    this.isLoading = false,
    this.error,
    this.isLoggedIn = false,
    this.user,
    this.token,
  });

  LoginState copyWith({
    bool? isLoading,
    String? error,
    bool? isLoggedIn,
    User? user,
    String? token,
  }) {
    return LoginState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
      user: user ?? this.user,
      token: token ?? this.token,
    );
  }
}