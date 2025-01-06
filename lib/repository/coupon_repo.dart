// lib/repository/coupon_repository.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:vesture_firebase_user/models/cart_item.dart';
import '../models/coupon_model.dart';

// class CouponRepository {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   final FirebaseAuth _auth = FirebaseAuth.instance;

//   Future<List<CouponModel>> getAvailableCoupons() async {
//     try {
//       final now = DateTime.now();
//       final snapshot = await _firestore
//           .collection('coupons')
//           .where('isActive', isEqualTo: true)
//           .where('validTo', isGreaterThan: now)
//           .get();

//       print('Raw coupon data: ${snapshot.docs.map((d) => d.data())}');

//       final coupons = snapshot.docs
//           .map((doc) {
//             try {
//               return CouponModel.fromFirestore(doc);
//             } catch (e) {
//               print('Failed to parse coupon: $e');
//               return null;
//             }
//           })
//           .where((coupon) => coupon != null && coupon.validFrom.isBefore(now))
//           .cast<CouponModel>()
//           .toList();

//       print('Parsed coupons: $coupons');
//       return coupons;
//     } catch (e) {
//       throw Exception('Failed to fetch coupons: $e');
//     }
//   }
//   Future<CouponModel> validateCoupon(String code, List<CartItem> cartItems) async {
//     try {
//       final now = DateTime.now();
//       final couponDoc = await _firestore
//           .collection('coupons')
//           .where('couponCode', isEqualTo: code)
//           .where('isActive', isEqualTo: true)
//           .get();

//       if (couponDoc.docs.isEmpty) {
//         throw Exception('Invalid coupon code');
//       }

//       final coupon = CouponModel.fromFirestore(couponDoc.docs.first);

//       if (now.isBefore(coupon.validFrom)) {
//         throw Exception('Coupon is not yet valid');
//       }

//       if (now.isAfter(coupon.validTo)) {
//         throw Exception('Coupon has expired');
//       }

//       // Verify if there are applicable items for this coupon
//       bool hasApplicableItems = false;
//       if (coupon.parentCategoryId != null || coupon.subCategoryId != null) {
//         hasApplicableItems = cartItems.any((item) =>
//             (coupon.parentCategoryId != null &&
//                 item.parentCategoryId == coupon.parentCategoryId) ||
//             (coupon.subCategoryId != null &&
//                 item.subCategoryId == coupon.subCategoryId));

//         if (!hasApplicableItems) {
//           throw Exception('No applicable items found for this coupon');
//         }
//       }

//       return coupon;
//     } catch (e) {
//       throw Exception('Failed to validate coupon: $e');
//     }

// //   Future<CouponModel> validateCoupon(String code, double cartTotal) async {
// //     try {
// //       final now = DateTime.now();
// //       final couponDoc = await _firestore
// //           .collection('coupons')
// //           .where('couponCode', isEqualTo: code)
// //           .where('isActive', isEqualTo: true)
// //           .get();

// //       if (couponDoc.docs.isEmpty) {
// //         throw Exception('Invalid coupon code');
// //       }

// //       final coupon = CouponModel.fromFirestore(couponDoc.docs.first);

// //       if (now.isBefore(coupon.validFrom)) {
// //         throw Exception('Coupon is not yet valid');
// //       }

// //       if (now.isAfter(coupon.validTo)) {
// //         throw Exception('Coupon has expired');
// //       }

// //       // Add any additional validation logic here (e.g., category-specific validation)
// //       if (coupon.parentCategoryId != null || coupon.subCategoryId != null) {
// //         // Implement category-specific validation logic
// //       }

// //       return coupon;
// //     } catch (e) {
// //       throw Exception('Failed to validate coupon: $e');
// //     }
// //   }
// // }
//   }}

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

      print('Raw coupon data: ${snapshot.docs.map((d) => d.data())}');

      final coupons = snapshot.docs
          .map((doc) {
            try {
              return CouponModel.fromFirestore(doc);
            } catch (e) {
              print('Failed to parse coupon: $e');
              return null;
            }
          })
          .where((coupon) => coupon != null && coupon.validFrom.isBefore(now))
          .cast<CouponModel>()
          .toList();

      print('Parsed coupons: $coupons');
      return coupons;
    } catch (e) {
      throw Exception('Failed to fetch coupons: $e');
    }
  }

  Future<CouponModel> validateCoupon(
      String code, List<CartItem> cartItems) async {
    try {
      final now = DateTime.now();
      final couponDoc = await _firestore
          .collection('coupons')
          .where('couponCode', isEqualTo: code)
          .where('isActive', isEqualTo: true)
          .get();

      if (couponDoc.docs.isEmpty) {
        throw Exception('Invalid coupon code');
      }

      final coupon = CouponModel.fromFirestore(couponDoc.docs.first);

      if (now.isBefore(coupon.validFrom)) {
        throw Exception('Coupon is not yet valid');
      }

      if (now.isAfter(coupon.validTo)) {
        throw Exception('Coupon has expired');
      }

      // Verify if there are applicable items for this coupon
      if (coupon.parentCategoryId != null || coupon.subCategoryId != null) {
        bool hasApplicableItems = cartItems.any((item) =>
            (coupon.parentCategoryId != null &&
                item.parentCategoryId == coupon.parentCategoryId) ||
            (coupon.subCategoryId != null &&
                item.subCategoryId == coupon.subCategoryId));

        if (!hasApplicableItems) {
          throw Exception(
              'This coupon is not applicable to items in your cart');
        }
      }

      return coupon;
    } catch (e) {
      throw Exception('Failed to validate coupon: $e');
    }
  }

  double calculateCouponDiscount(CouponModel coupon, List<CartItem> cartItems) {
    try {
      double applicableAmount = 0.0;

      for (var item in cartItems) {
        // Skip invalid items
        if (item.price <= 0 || item.quantity <= 0) continue;

        bool isItemApplicable = false;

        // If no category restrictions, apply to all items
        if (coupon.parentCategoryId == null && coupon.subCategoryId == null) {
          isItemApplicable = true;
        }
        // Check category restrictions
        else {
          isItemApplicable = (coupon.parentCategoryId != null &&
                  item.parentCategoryId == coupon.parentCategoryId) ||
              (coupon.subCategoryId != null &&
                  item.subCategoryId == coupon.subCategoryId);
        }

        if (isItemApplicable) {
          // Calculate base price
          final itemTotal = item.price * item.quantity;

          // Apply any existing discounts first
          double existingDiscount = 0.0;
          if (item.percentDiscount > 0) {
            existingDiscount = item.percentDiscount;
          }
          if (item.categoryOffer > existingDiscount) {
            existingDiscount = item.categoryOffer;
          }
          if ((item.product?.offer ?? 0.0) > existingDiscount) {
            existingDiscount = item.product?.offer ?? 0.0;
          }

          // Calculate price after existing discounts
          final priceAfterExistingDiscount =
              itemTotal * (1 - existingDiscount / 100);

          // Add to applicable amount
          applicableAmount += priceAfterExistingDiscount;
        }
      }

      // Calculate final discount amount
      return applicableAmount * (coupon.discount / 100);
    } catch (e) {
      print('Error calculating coupon discount: $e');
      return 0.0;
    }
  }
}
