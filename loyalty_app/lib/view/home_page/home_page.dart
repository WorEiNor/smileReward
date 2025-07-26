import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:loyalty_app/viewmodels/reward_list_viewmodel.dart';
import 'package:loyalty_app/viewmodels/wishlist_viewmodel.dart';
import 'package:loyalty_app/widgets/reward_card.dart';

import '../../utils/navigation_service.dart';
import '../../viewmodels/login_viewmodel.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {

  @override
  Widget build(BuildContext context) {
    final rewardsState = ref.watch(rewardListViewModelProvider);
    final rewardsViewModel = ref.read(rewardListViewModelProvider.notifier);
    final wishlistItems = ref.watch(wishlistViewModelProvider);
    final wishlistViewModel = ref.read(wishlistViewModelProvider.notifier);
    final userProfile = ref.read(loginViewModelProvider).user;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${userProfile?.firstname} ${userProfile?.lastname}',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            Text(
              'Points: ${userProfile?.points}',
              style: TextStyle(
                color: Colors.grey[700],
                fontSize: 14,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.logout, color: Colors.black),
            onPressed: () {
              NavigationService.go('/');
            },
            tooltip: 'Logout',
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => rewardsViewModel.refreshItems(),
        child: CustomScrollView(
          slivers: [
            // Items grid or loading/error state
            if (rewardsState.isLoading && rewardsState.items.isEmpty)
              const SliverFillRemaining(
                child: Center(child: CircularProgressIndicator()),
              )
            else if (rewardsState.error != null && rewardsState.items.isEmpty)
              SliverFillRemaining(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.error_outline,
                        size: 64,
                        color: Colors.red,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Error: ${rewardsState.error}',
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () => rewardsViewModel.loadItems(),
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                ),
              )
            else
              SliverPadding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.75,
                  ),
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final reward = rewardsState.items[index];
                    return RewardCard(
                      reward: reward,
                      onTapWishlist: (){wishlistViewModel.toggleWishlist(reward.id);},
                      onTap: () {
                        context.go('/reward/${reward.id}');
                      },
                      isWishlisted: wishlistItems.contains(reward.id),
                    );
                  }, childCount: rewardsState.items.length),
                ),
              ),

            // Bottom padding
            const SliverToBoxAdapter(child: SizedBox(height: 20)),
          ],
        ),
      ),
    );
  }
}

// Item Card Widget
