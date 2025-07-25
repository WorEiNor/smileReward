// Main homepage with bottom navigation
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loyalty_app/view/home_page/home_page.dart';
import 'package:loyalty_app/view/main_home_page/main_home_page_viewmodel.dart';
import 'package:loyalty_app/view/wishlist_page/wishlist_page.dart';

class MainHomePage extends ConsumerWidget {
  const MainHomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentTabIndex = ref.watch(mainHomePageViewModelProvider);
    final viewModel = ref.read(mainHomePageViewModelProvider.notifier);

    return Scaffold(
      body: _buildCurrentPage(currentTabIndex),
      bottomNavigationBar: _buildBottomNavigationBar(
        context,
        currentTabIndex,
        viewModel,
      ),
    );
  }

  Widget _buildCurrentPage(int currentIndex) {
    switch (currentIndex) {
      case 0:
        return const HomePage();
      case 1:
        return const WishlistPage();
      default:
        return const HomePage();
    }
  }

  Widget _buildBottomNavigationBar(
    BuildContext context,
    int currentIndex,
    MainHomePageViewModel viewModel,
  ) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: viewModel.changeTab,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Theme.of(context).primaryColor,
      unselectedItemColor: Colors.grey,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          activeIcon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.favorite_border),
          activeIcon: Icon(Icons.favorite),
          label: 'Wishlist',
        ),
      ],
    );
  }
}