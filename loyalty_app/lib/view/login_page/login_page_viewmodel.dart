import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginPageViewmodel extends AsyncNotifier<void> {
  @override
  Future<void> build() async {
    // no initial data to load
  }

  Future<void> login(String email, String password) async {
    state = const AsyncLoading();

    // final authRepo = ref.read(authRepositoryProvider);

    state = await AsyncValue.guard(() async {
      print('waiting');
      await Future.delayed(Duration(seconds: 10), () {
        return;
      });
    });
  }

  
}

final loginPageProvider = AsyncNotifierProvider<LoginPageViewmodel, void>(
  LoginPageViewmodel.new,
);
