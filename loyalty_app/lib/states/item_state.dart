import 'package:loyalty_app/models/item_model.dart';

class ItemsState {
  final List<Reward> items;
  final bool isLoading;
  final String? error;

  const ItemsState({
    this.items = const [],
    this.isLoading = false,
    this.error,
  });

  ItemsState copyWith({
    List<Reward>? items,
    bool? isLoading,
    String? error,
  }) {
    return ItemsState(
      items: items ?? this.items,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}