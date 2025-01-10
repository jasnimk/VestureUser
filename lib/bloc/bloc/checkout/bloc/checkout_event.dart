// checkout_event.dart
import 'package:equatable/equatable.dart';
import 'package:vesture_firebase_user/models/cart_item.dart';

abstract class CheckoutEvent extends Equatable {
  const CheckoutEvent();

  @override
  List<Object?> get props => [];
}

class InitiateCheckoutEvent extends CheckoutEvent {
  final String addressId;
  final String paymentMethod;
  final List<CartItem> items;
  final double totalAmount;

  const InitiateCheckoutEvent({
    required this.addressId,
    required this.paymentMethod,
    required this.items,
    required this.totalAmount,
  });

  @override
  List<Object?> get props => [addressId, paymentMethod, items, totalAmount];
}

class ProcessRazorpayPaymentEvent extends CheckoutEvent {
  final String paymentId;
  const ProcessRazorpayPaymentEvent(this.paymentId);

  @override
  List<Object?> get props => [paymentId];
}

class StripePaymentSuccessEvent extends CheckoutEvent {
  final String paymentIntentId;
  final double totalAmount;
  StripePaymentSuccessEvent(this.paymentIntentId, this.totalAmount);
}

class WalletPaymentEvent extends CheckoutEvent {
  final String addressId;
  final List<CartItem> items;
  final double totalAmount;

  WalletPaymentEvent({
    required this.addressId,
    required this.items,
    required this.totalAmount,
  });
}
