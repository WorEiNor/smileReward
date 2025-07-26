import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../models/reward_model.dart';
import '../../utils/navigation_service.dart';
import '../../viewmodels/reward_detail_viewmodel.dart';
import '../../viewmodels/reward_list_viewmodel.dart';
import '../../viewmodels/user_viewmodel.dart';
import '../../viewmodels/wishlist_viewmodel.dart';

class RewardDetailPage extends ConsumerStatefulWidget {
  final String rewardId;

  const RewardDetailPage({
    Key? key,
    required this.rewardId,
  }) : super(key: key);

  @override
  _RewardDetailPageState createState() => _RewardDetailPageState();
}

class _RewardDetailPageState extends ConsumerState<RewardDetailPage> {

  @override
  Widget build(BuildContext context) {
    final rewardState = ref.watch(rewardListViewModelProvider);

    final reward = rewardState.items.firstWhere(
          (item) => item.id == widget.rewardId,
    );

    final wishlistItems = ref.watch(wishlistViewModelProvider);
    final wishlistViewModel = ref.read(wishlistViewModelProvider.notifier);
    final userViewModel = ref.read(userViewModelProvider.notifier);

    if (rewardState.error != null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Reward Details'),
        ),
        body: const Center(
          child: Text('Reward not found'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Reward Details'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (context.canPop()) {
              context.pop(); // or Navigator.of(context).pop();
            } else {
              context.go('/mainhome'); // fallback route if no page to pop
            }
          },
        ),
      ),

      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Reward Image
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      reward!.imageUrl,
                      width: double.infinity,
                      height: 200,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: double.infinity,
                          height: 200,
                          color: Colors.grey[300],
                          child: const Icon(
                            Icons.image_not_supported,
                            size: 50,
                            color: Colors.grey,
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Reward Name, Points, and Wishlist Button Row
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              reward!.name,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Icon(
                                  Icons.stars,
                                  color: Colors.amber,
                                  size: 20,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '${reward!.points} points',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey[600],
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      IconButton(
                        onPressed: () {
                          wishlistViewModel.toggleWishlist(reward!.id);
                        },
                        icon: Icon(
                          wishlistItems.contains(reward!.id)
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: wishlistItems.contains(reward!.id)
                              ? Colors.red
                              : Colors.grey[600],
                        ),
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.grey[100],
                          padding: const EdgeInsets.all(12),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Reward Details Section
                  const Text(
                    'Details',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    reward!.description,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[700],
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 100), // Space for bottom navbar
                ],
              ),
            ),
          ),
        ],
      ),

      // Bottom Navigation Bar with Redeem Button
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: () {
                _showRedeemConfirmation(context, reward!, (){userViewModel.usePoints(reward!.points);});
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'Redeem for ${reward!.points} points',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showRedeemConfirmation(
      BuildContext context,
      Reward reward,
      VoidCallback onTap,
      ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Redemption'),
          content: Text(
            'Are you sure you want to redeem "${reward.name}" for ${reward.points} points?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                onTap();
                // viewModel.redeemReward(reward.id);
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('${reward.name} redeemed successfully!'),
                    backgroundColor: Colors.green,
                  ),
                );
              },
              child: const Text('Redeem'),
            ),
          ],
        );
      },
    );
  }
}