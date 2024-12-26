import 'dart:developer';

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

  Future<void> _onRemoveFromCart(
      RemoveFromCartEvent event, Emitter<CartState> emit) async {
    try {
      log('remove funcyion');
      emit(CartLoadingState());
      //await Future.delayed(Duration(milliseconds: 200));

      await cartRepository.removeCartItem(
        cartItemId: event.cartItem.id,
        sizeId: event.cartItem.sizeId,
      );
      final items = await cartRepository.fetchCartItems();
      final totalAmount = items.fold(
        0.0,
        (sum, item) => sum + (item.effectivePrice * (item.quantity)),
      );
      emit(CartLoadedState(items: items, totalAmount: totalAmount));
      //add(LoadCartEvent());
    } catch (e) {
      emit(CartErrorState(message: e.toString()));
    }
  }

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
