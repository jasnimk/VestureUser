import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:vesture_firebase_user/models/cart_item.dart';
import 'package:vesture_firebase_user/models/coupon_model.dart';
import 'package:vesture_firebase_user/models/order_model.dart';
import 'package:vesture_firebase_user/repository/cart_repo.dart';

class CheckoutRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final CartRepository _cartRepository = CartRepository();

  Future<String> createOrder({
    required String addressId,
    required List<CartItem> items,
    required String paymentMethod,
    String? paymentId,
    CouponModel? appliedCoupon,
    double? couponDiscount,
    required double finalAmount,
  }) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('User not logged in');

    try {
      String orderId = '';

      List<Map<String, dynamic>> sizeStockData = [];
      for (var item in items) {
        final sizeStockDoc = await _firestore
            .collection('sizes_and_stocks')
            .doc(item.sizeId)
            .get();

        if (!sizeStockDoc.exists) {
          throw Exception('Size stock not found for ${item.productName}');
        }

        final currentStock = sizeStockDoc.data()?['stock'] as int? ?? 0;
        if (currentStock < item.quantity) {
          throw Exception('Not enough stock for ${item.productName}');
        }

        sizeStockData.add({
          'sizeId': item.sizeId,
          'currentStock': currentStock,
        });
      }

      final userDoc = await _firestore.collection('users').doc(user.uid).get();
      if (!userDoc.exists) {
        throw Exception('User data not found');
      }

      // Step 2: Perform all write operations (create order) inside the transaction
      final orderRef = _firestore.collection('orders').doc();
      orderId = orderRef.id;

      final orderItems = items
          .map((item) => OrderItem(
                productId: item.productId,
                variantId: item.variantId,
                sizeId: item.sizeId,
                quantity: item.quantity,
                originalPrice: item.price,
                percentDiscount: item.percentDiscount,
                categoryOffer: item.categoryOffer,
                productName: item.productName,
                color: item.color,
                size: item.size,
                imageUrl: item.imageUrl,
                parentCategoryId: item.parentCategoryId,
                subCategoryId: item.subCategoryId,
                addedAt: DateTime.now(),
              ))
          .toList();

      double subTotal = 0;
      double totalDiscount = 0;

      for (var item in orderItems) {
        subTotal += item.originalPrice * item.quantity;
        totalDiscount += item.discountAmount;
      }

      final shippingCharge = 60.0;
      final totalAmount = finalAmount + shippingCharge;

      String paymentStatus;
      if (paymentMethod == 'cod') {
        paymentStatus = 'pending';
      } else if (paymentMethod == 'stripe' && paymentId != null) {
        paymentStatus = 'completed';
      } else {
        paymentStatus = 'awaiting_payment';
      }

      // Create order document
      final orderData = OrderModel(
        id: orderId,
        userId: user.uid,
        addressId: addressId,
        items: orderItems,
        subTotal: subTotal,
        totalDiscount: totalDiscount,
        finalAmount: finalAmount,
        shippingCharge: shippingCharge,
        totalAmount: totalAmount,
        paymentMethod: paymentMethod,
        paymentStatus: paymentStatus,
        orderStatus: 'pending',
        createdAt: DateTime.now(),
        paymentId: paymentId,
        appliedCouponId: appliedCoupon?.id,
        couponDiscount: couponDiscount,
      ).toMap();

      // Step 3: Start the transaction for stock updates and order creation
      await _firestore.runTransaction((transaction) async {
        // Update stock for each item within the same transaction
        for (var item in items) {
          final sizeStockRef =
              _firestore.collection('sizes_and_stocks').doc(item.sizeId);
          final currentStock = sizeStockData.firstWhere(
              (data) => data['sizeId'] == item.sizeId)['currentStock'];
          transaction.update(sizeStockRef, {
            'stock': currentStock - item.quantity,
            'lastUpdated': FieldValue.serverTimestamp(),
          });
        }

        // Set the order document
        transaction.set(orderRef, orderData);

        // Update coupon usage if applicable
        if (appliedCoupon != null) {
          transaction
              .update(_firestore.collection('coupons').doc(appliedCoupon.id), {
            'usedBy': FieldValue.arrayUnion([user.uid]),
            'lastUsed': FieldValue.serverTimestamp(),
          });
        }
      });

      // Clear cart after successful order creation
      if (paymentMethod == 'cod' ||
          (paymentMethod == 'stripe' && paymentId != null)) {
        await _cartRepository.clearCart();
      }

      return orderId;
    } catch (e) {
      print('Failed to create order: $e');
      throw Exception('Failed to create order: $e');
    }
  }

  Future<void> updateOrderPaymentStatus(String orderId, String status) async {
    await _firestore.collection('orders').doc(orderId).update({
      'paymentStatus': status,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }
}
