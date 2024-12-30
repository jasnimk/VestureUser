import 'package:vesture_firebase_user/models/cart_item.dart';

abstract class CartEvent {}

class LoadCartEvent extends CartEvent {}

class UpdateCartItemQuantityEvent extends CartEvent {
  final CartItem cartItem;
  final int newQuantity;

  UpdateCartItemQuantityEvent({
    required this.cartItem,
    required this.newQuantity,
  });
}

class RemoveFromCartEvent extends CartEvent {
  final CartItem cartItem;

  RemoveFromCartEvent({required this.cartItem});
}

class CartUpdated extends CartEvent {
  final List<CartItem> items;

  CartUpdated(this.items);
}

class ClearCartEvent extends CartEvent {
  List<Object?> get props => [];
}
