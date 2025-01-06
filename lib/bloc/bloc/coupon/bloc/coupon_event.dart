// lib/bloc/coupon/coupon_event.dart
import 'package:vesture_firebase_user/models/cart_item.dart';

abstract class CouponEvent {}

class ApplyCouponEvent extends CouponEvent {
  final String couponCode;
  final List<CartItem> cartItems;

  ApplyCouponEvent({
    required this.couponCode,
    required this.cartItems,
  });
}

class RemoveCouponEvent extends CouponEvent {}

class LoadAvailableCouponsEvent extends CouponEvent {}
