import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../utils/navigation_service.dart';
import '../../viewmodels/reward_list_viewmodel.dart';
import '../../viewmodels/wishlist_viewmodel.dart';
import '../../widgets/reward_card.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class WishlistPage extends ConsumerWidget {
  const WishlistPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rewardsViewModel = ref.read(rewardListViewModelProvider.notifier);
    final rewardsState = ref.watch(rewardListViewModelProvider);
    final wishlistList = ref.watch(wishlistViewModelProvider);
    final wishlistViewModel = ref.read(wishlistViewModelProvider.notifier);

    return Scaffold(
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
                    final reward = rewardsState.items.where(
                            (reward) => wishlistList.contains(reward.id)
                    ).toList();
                    return RewardCard(
                      reward: reward[index],
                      onTapWishlist: (){wishlistViewModel.toggleWishlist(reward[index].id);},
                      onTap: () {
                        NavigationService.go('/reward/${reward[index].id}');
                      },
                      isWishlisted: wishlistList.contains(reward[index].id),
                    );
                  }, childCount: wishlistList.length),
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