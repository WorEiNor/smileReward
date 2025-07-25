import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loyalty_app/viewmodels/item_viewmodel.dart';
import 'package:loyalty_app/viewmodels/wishlist_viewmodel.dart';
import 'package:loyalty_app/widgets/item_card.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final itemsState = ref.watch(itemsViewModelProvider);
    final itemsViewModel = ref.read(itemsViewModelProvider.notifier);
    final wishlistItems = ref.watch(wishlistViewModelProvider);
    final wishlistViewModel = ref.read(wishlistViewModelProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        elevation: 0,
      ),
      body: RefreshIndicator(
        onRefresh: () => itemsViewModel.refreshItems(),
        child: CustomScrollView(
          slivers: [
            // Items grid or loading/error state
            if (itemsState.isLoading && itemsState.items.isEmpty)
              const SliverFillRemaining(
                child: Center(child: CircularProgressIndicator()),
              )
            else if (itemsState.error != null && itemsState.items.isEmpty)
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
                        'Error: ${itemsState.error}',
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () => itemsViewModel.loadItems(),
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
                    final item = itemsState.items[index];
                    return RewardCard(
                      item: item,
                      onTapWishlist: () {
                        wishlistViewModel.toggleWishlist(item.id);
                      },
                      onTap: () {
                        print('tapped');
                      },
                      isWishlisted: wishlistItems.contains(item.id),
                    );
                  }, childCount: itemsState.items.length),
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
