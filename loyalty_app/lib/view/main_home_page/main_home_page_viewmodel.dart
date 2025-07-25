import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MainHomePageViewModel extends StateNotifier<int> {
  MainHomePageViewModel() : super(0);

  void changeTab(int index) {
    state = index;

  }

  void showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: const Duration(seconds: 2)),
    );
  }
}

// Provider for the ViewModel
final mainHomePageViewModelProvider =
    StateNotifierProvider<MainHomePageViewModel, int>(
      (ref) => MainHomePageViewModel(),
    );
