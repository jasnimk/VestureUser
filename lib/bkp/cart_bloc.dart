// import 'dart:async';

// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:vesture_firebase_user/bloc/bloc/cart/bloc/cart_event.dart';
// import 'package:vesture_firebase_user/bloc/bloc/cart/bloc/cart_state.dart';
// import 'package:vesture_firebase_user/models/cart_item.dart';
// import 'package:vesture_firebase_user/repository/cart_repo.dart';

// class CartBloc extends Bloc<CartEvent, CartState> {
//   final CartRepository cartRepository;
//   StreamSubscription<List<CartItem>>? _cartSubscription;

//   CartBloc({required this.cartRepository}) : super(CartInitialState()) {
//     on<LoadCartEvent>(_onLoadCart);
//     on<UpdateCartItemQuantityEvent>(_onUpdateCartItemQuantity);
//     on<RemoveFromCartEvent>(_onRemoveFromCart);
//     on<ClearCartEvent>(_onClearCart);
//     on<CartUpdated>(_onCartUpdated);
//   }
//   Future<void> _onCartUpdated(
//       CartUpdated event, Emitter<CartState> emit) async {
//     final totalAmount =
//         event.items.fold(0.0, (sum, item) => sum + item.totalPrice);
//     // emit(CartLoadedState(items: event.items, totalAmount: totalAmount));
//   }

//   @override
//   Future<void> close() {
//     _cartSubscription?.cancel();
//     return super.close();
//   }

//   Future<void> _onLoadCart(LoadCartEvent event, Emitter<CartState> emit) async {
//     try {
//       emit(CartLoadingState());

//       await _cartSubscription?.cancel();

//       _cartSubscription = cartRepository.getCartStream().listen((items) {
//         add(CartUpdated(items));
//       }, onError: (error) {
//         emit(CartErrorState(message: error.toString()));
//       });
//     } catch (e) {
//       emit(CartErrorState(message: e.toString()));
//     }
//   }

//   Future<void> _onUpdateCartItemQuantity(
//       UpdateCartItemQuantityEvent event, Emitter<CartState> emit) async {
//     try {
//       emit(CartLoadingState());
//       await cartRepository.updateCartItemQuantity(
//         cartItemId: event.cartItem.id,
//         sizeId: event.cartItem.sizeId,
//         newQuantity: event.newQuantity,
//       );

//       emit(CartLoadedState(items:, totalAmount: totalAmount))
//     } catch (e) {
//       emit(CartErrorState(message: e.toString()));
//     }
//   }

//   Future<void> _onRemoveFromCart(
//       RemoveFromCartEvent event, Emitter<CartState> emit) async {
//     // if (state is CartLoadedState) {
//     //   final currentState = state as CartLoadedState;
//     //   emit(currentState.copyWith(loadingItemId: event.cartItem.id));
//     // }
//     try {
//       emit(CartLoadingState());
//       await cartRepository.removeCartItem(
//         cartItemId: event.cartItem.id,
//         sizeId: event.cartItem.sizeId,
//       );
//     } catch (e) {
//       emit(CartErrorState(message: e.toString()));
//     }
//   }

//   Future<void> _onClearCart(
//       ClearCartEvent event, Emitter<CartState> emit) async {
//     try {
//       await cartRepository.clearCart();
//       emit(CartLoadedState(items: [], totalAmount: 0));
//     } catch (e) {
//       emit(CartErrorState(message: e.toString()));
//     }
//   }
// }
