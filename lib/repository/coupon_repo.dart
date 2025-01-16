// lib/repository/coupon_repository.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:vesture_firebase_user/models/cart_item.dart';
import '../models/coupon_model.dart';

class CouponRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<List<CouponModel>> getAvailableCoupons() async {
    try {
      final now = DateTime.now();
      final snapshot = await _firestore
          .collection('coupons')
          .where('isActive', isEqualTo: true)
          .where('validTo', isGreaterThan: now)
          .get();

      final coupons = snapshot.docs
          .map((doc) {
            try {
              return CouponModel.fromFirestore(doc);
            } catch (e) {
              return null;
            }
          })
          .where((coupon) => coupon != null && coupon.validFrom.isBefore(now))
          .cast<CouponModel>()
          .toList();

      return coupons;
    } catch (e) {
      throw Exception('Failed to fetch coupons: $e');
    }
  }

  Future<CouponModel> validateCoupon(
      String code, List<CartItem> cartItems) async {
    try {
      final couponDoc = await _firestore
          .collection('coupons')
          .where('couponCode', isEqualTo: code)
          .where('isActive', isEqualTo: true)
          .get();

      if (couponDoc.docs.isEmpty) {
        throw Exception('Invalid coupon code');
      }

      final coupon = CouponModel.fromFirestore(couponDoc.docs.first);

      return coupon;
    } catch (e) {
      throw Exception('Failed to validate coupon: $e');
    }
  }

  double calculateCouponDiscount(CouponModel coupon, List<CartItem> cartItems) {
    try {
      double applicableAmount = 0.0;

      for (var item in cartItems) {
        if (item.price <= 0 || item.quantity <= 0) {
          continue;
        }

        bool isItemApplicable = false;
        if (coupon.parentCategoryId == null && coupon.subCategoryId == null) {
          isItemApplicable = true;
        } else {
          isItemApplicable = (coupon.parentCategoryId != null &&
                  item.parentCategoryId == coupon.parentCategoryId) ||
              (coupon.subCategoryId != null &&
                  item.subCategoryId == coupon.subCategoryId);
        }

        if (isItemApplicable) {
          final itemTotal = item.price * item.quantity;

          double existingDiscount = [
            item.percentDiscount,
            item.categoryOffer,
            item.product?.offer ?? 0.0
          ].reduce((a, b) => a > b ? a : b);

          final priceAfterExistingDiscount =
              itemTotal * (1 - existingDiscount / 100);

          applicableAmount += priceAfterExistingDiscount;
        }
      }

      final finalDiscount = applicableAmount * (coupon.discount / 100);
      return finalDiscount;
    } catch (e) {
      return 0.0;
    }
  }
}
