// lib/bloc/coupon/coupon_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vesture_firebase_user/bloc/bloc/coupon/bloc/coupon_event.dart';
import 'package:vesture_firebase_user/bloc/bloc/coupon/bloc/coupon_state.dart';
import 'package:vesture_firebase_user/repository/coupon_repo.dart';

class CouponBloc extends Bloc<CouponEvent, CouponState> {
  final CouponRepository _couponRepository;

  CouponBloc({required CouponRepository couponRepository})
      : _couponRepository = couponRepository,
        super(CouponInitial()) {
    on<ApplyCouponEvent>(_onApplyCoupon);
    on<RemoveCouponEvent>(_onRemoveCoupon);
    on<LoadAvailableCouponsEvent>(_onLoadAvailableCoupons);
  }

  Future<void> _onApplyCoupon(
    ApplyCouponEvent event,
    Emitter<CouponState> emit,
  ) async {
    try {
      emit(CouponLoading());

      final coupon = await _couponRepository.validateCoupon(
        event.couponCode,
        event.cartItems, // Pass cart items instead of total
      );

      final discountAmount = _couponRepository.calculateCouponDiscount(
        coupon,
        event.cartItems,
      );

      emit(CouponApplied(
        coupon: coupon,
        discountAmount: discountAmount,
      ));
    } catch (e) {
      emit(CouponError(e.toString()));
    }
  }

  // Future<void> _onApplyCoupon(
  //   ApplyCouponEvent event,
  //   Emitter<CouponState> emit,
  // ) async {
  //   try {
  //     emit(CouponLoading());

  //     final coupon = await _couponRepository.validateCoupon(
  //       event.couponCode,
  //       event.cartTotal,
  //     );

  //     final discountAmount = (event.cartTotal * coupon.discount / 100);

  //     emit(CouponApplied(
  //       coupon: coupon,
  //       discountAmount: discountAmount,
  //     ));
  //   } catch (e) {
  //     emit(CouponError(e.toString()));
  //   }
  // }

  void _onRemoveCoupon(
    RemoveCouponEvent event,
    Emitter<CouponState> emit,
  ) {
    emit(CouponInitial());
  }

  Future<void> _onLoadAvailableCoupons(
    LoadAvailableCouponsEvent event,
    Emitter<CouponState> emit,
  ) async {
    try {
      emit(CouponLoading());
      final coupons = await _couponRepository.getAvailableCoupons();
      emit(AvailableCouponsLoaded(coupons));
    } catch (e) {
      emit(CouponError(e.toString()));
    }
  }
}
