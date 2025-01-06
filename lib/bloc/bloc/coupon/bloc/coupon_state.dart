// lib/bloc/coupon/coupon_state.dart
import 'package:vesture_firebase_user/models/coupon_model.dart';

abstract class CouponState {}

class CouponInitial extends CouponState {}

class CouponLoading extends CouponState {}

class CouponApplied extends CouponState {
  final CouponModel coupon;
  final double discountAmount;

  CouponApplied({required this.coupon, required this.discountAmount});
}

class CouponError extends CouponState {
  final String message;

  CouponError(this.message);
}

class AvailableCouponsLoaded extends CouponState {
  final List<CouponModel> coupons;

  AvailableCouponsLoaded(this.coupons);
}
