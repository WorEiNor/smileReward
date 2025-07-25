import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NavigationService {
  static final navigatorKey = GlobalKey<NavigatorState>();

  static BuildContext? get context => navigatorKey.currentContext;

  static void go(String location) {
    context?.go(location);
  }

  static void push(String location) {
    context?.push(location);
  }

  static void pop() {
    navigatorKey.currentState?.pop();
  }
}