// cart_state.dart
import 'package:equatable/equatable.dart';
import 'package:vesture_firebase_user/models/cart_item.dart';

abstract class CartState extends Equatable {
  const CartState();

  @override
  List<Object?> get props => [];
}

class CartInitialState extends CartState {}

class CartLoadingState extends CartState {}

class CartEmpty extends CartState {}

class CartErrorState extends CartState {
  final String message;

  CartErrorState({required this.message});
}

class CartLoadedState extends CartState {
  final List<CartItem> items;
  final double totalAmount;
  final String? error;
  final String? errorItemId;
  final String? loadingItemId;

  const CartLoadedState({
    required this.items,
    required this.totalAmount,
    this.error,
    this.errorItemId,
    this.loadingItemId,
  });

  @override
  List<Object?> get props =>
      [items, totalAmount, error, errorItemId, loadingItemId];
}

extension CartLoadedStateCopyWith on CartLoadedState {
  CartLoadedState copyWith({
    List<CartItem>? items,
    double? totalAmount,
    String? error,
    String? errorItemId,
    String? loadingItemId,
  }) {
    return CartLoadedState(
      items: items ?? this.items,
      totalAmount: totalAmount ?? this.totalAmount,
      error: error,
      errorItemId: errorItemId,
      loadingItemId: loadingItemId,
    );
  }
}
