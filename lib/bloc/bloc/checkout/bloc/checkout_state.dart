// import 'package:equatable/equatable.dart';

// abstract class CheckoutState extends Equatable {
//   const CheckoutState();

//   @override
//   List<Object?> get props => [];
// }

// class CheckoutInitial extends CheckoutState {}

// class CheckoutLoading extends CheckoutState {}

// class PaymentProcessing extends CheckoutState {}

// class CheckoutSuccess extends CheckoutState {
//   final String orderId;
//   const CheckoutSuccess(this.orderId);

//   @override
//   List<Object?> get props => [orderId];
// }

// class CheckoutError extends CheckoutState {
//   final String message;
//   const CheckoutError(this.message);

//   @override
//   List<Object?> get props => [message];
// }

import 'package:vesture_firebase_user/models/cart_item.dart';

abstract class CheckoutState {}

class CheckoutInitial extends CheckoutState {}

class CheckoutLoading extends CheckoutState {}

class PaymentProcessing extends CheckoutState {}

class CheckoutSuccess extends CheckoutState {
  final String orderId;
  CheckoutSuccess(this.orderId);
}

class CheckoutError extends CheckoutState {
  final String message;
  CheckoutError(this.message);
}

class StripePaymentInitiated extends CheckoutState {
  final String addressId;
  final List<CartItem> items;
  final double totalAmount;

  StripePaymentInitiated({
    required this.addressId,
    required this.items,
    required this.totalAmount,
  });
}

// Add new state in checkout_state.dart
class WalletPaymentCompleted extends CheckoutState {
  final String orderId;

  WalletPaymentCompleted(this.orderId);
}
