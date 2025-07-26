class Wishlist {
  final String userId;
  final String rewardId;
  final DateTime addedAt;

  const Wishlist({
    required this.userId,
    required this.rewardId,
    required this.addedAt,
  });

  factory Wishlist.fromJson(Map<String, dynamic> json) {
    return Wishlist(
      userId: json['user_id'],
      rewardId: json['reward_id'],
      addedAt: DateTime.parse(json['added_at']),
    );
  }

}