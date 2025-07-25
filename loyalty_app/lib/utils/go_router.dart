// lib/utils/router_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:loyalty_app/view/home_page/home_page.dart';
import 'package:loyalty_app/view/login_page/login_page.dart';
import 'package:loyalty_app/view/main_home_page/main_home_page.dart';
import 'package:loyalty_app/view/wishlist_page/wishlist_page.dart';
import 'navigation_service.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    navigatorKey: NavigationService.navigatorKey,
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => LoginPage(),
      ),
      GoRoute(
        path: '/mainhome',
        builder: (context, state) => MainHomePage(),
      ),
      GoRoute(
        path: '/home',
        builder: (context, state) => HomePage(),
      ),
      GoRoute(
        path: '/wishlist',
        builder: (context, state) => WishlistPage(),
      ),
    ],
  );
});