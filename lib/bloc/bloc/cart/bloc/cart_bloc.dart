import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vesture_firebase_user/bloc/bloc/cart/bloc/cart_event.dart';
import 'package:vesture_firebase_user/bloc/bloc/cart/bloc/cart_state.dart';
import 'package:vesture_firebase_user/repository/cart_repo.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final CartRepository cartRepository;

  CartBloc({required this.cartRepository}) : super(CartInitialState()) {
    on<LoadCartEvent>(_onLoadCart);
    on<UpdateCartItemQuantityEvent>(_onUpdateCartItemQuantity);
    on<RemoveFromCartEvent>(_onRemoveFromCart);
    on<ClearCartEvent>(_onClearCart);
  }

  /// Handles loading cart items and calculates the total cart amount.
  Future<void> _onLoadCart(LoadCartEvent event, Emitter<CartState> emit) async {
    try {
      emit(CartLoadingState());
      final items = await cartRepository.fetchCartItems();
      final totalAmount = items.fold(
        0.0,
        (sum, item) => sum + (item.effectivePrice * (item.quantity)),
      );
      emit(CartLoadedState(items: items, totalAmount: totalAmount));
    } catch (e) {
      emit(CartErrorState(message: e.toString()));
    }
  }

  /// Updates the quantity of a cart item and reloads the cart.
  Future<void> _onUpdateCartItemQuantity(
      UpdateCartItemQuantityEvent event, Emitter<CartState> emit) async {
    try {
      emit(CartLoadingState());
      await cartRepository.updateCartItemQuantity(
        cartItemId: event.cartItem.id,
        sizeId: event.cartItem.sizeId,
        newQuantity: event.newQuantity,
      );

      add(LoadCartEvent());
    } catch (e) {
      emit(CartErrorState(message: e.toString()));
    }
  }

  /// Removes an item from the cart and updates the cart state.
  Future<void> _onRemoveFromCart(
      RemoveFromCartEvent event, Emitter<CartState> emit) async {
    try {
      emit(CartLoadingState());

      await cartRepository.removeCartItem(
        cartItemId: event.cartItem.id,
        sizeId: event.cartItem.sizeId,
      );
      final items = await cartRepository.fetchCartItems();
      final totalAmount = items.fold(
        0.0,
        (sum, item) => sum + (item.effectivePrice * (item.quantity)),
      );
      emit(CartLoadedState(
          items: items, totalAmount: totalAmount, isUpdating: true));
    } catch (e) {
      emit(CartErrorState(message: e.toString()));
    }
  }

  /// Clears all items from the cart and resets the cart state.
  Future<void> _onClearCart(
      ClearCartEvent event, Emitter<CartState> emit) async {
    try {
      emit(CartLoadingState());
      await cartRepository.clearCart();
      emit(CartLoadedState(items: [], totalAmount: 0));
    } catch (e) {
      emit(CartErrorState(message: e.toString()));
    }
  }
}
