class Reward {
  final String id;
  final String name;
  final String imageUrl;
  final int points;
  final String description;

  const Reward({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.points,
    required this.description,
  });

  factory Reward.fromJson(Map<String, dynamic> json) {
    return Reward(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      imageUrl: json['image_url'] ?? '',
      points: json['reward_points'] ?? 0,
      description: json['reward_desc'] ?? ''
    );
  }
}