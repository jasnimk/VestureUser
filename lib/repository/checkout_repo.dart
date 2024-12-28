// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:vesture_firebase_user/models/cart_item.dart';
// import 'package:vesture_firebase_user/models/order_model.dart';
// import 'package:vesture_firebase_user/repository/cart_repo.dart';

// class CheckoutRepository {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final CartRepository _cartRepository = CartRepository();

//   Future<String> createOrder({
//     required String addressId,
//     required List<CartItem> items,
//     required double totalAmount,
//     required String paymentMethod,
//      String? paymentId,
//   }) async {
//     final user = _auth.currentUser;
//     if (user == null) throw Exception('User not logged in');

//     try {
//       // Step 1: Verify user exists
//       final userDoc = await _firestore.collection('users').doc(user.uid).get();
//       if (!userDoc.exists) {
//         throw Exception('User data not found');
//       }

//       final orderRef = _firestore.collection('orders').doc();
//       final orderId = orderRef.id;

//       final orderItems = items
//           .map((item) => OrderItem(
//                 productId: item.productId,
//                 variantId: item.variantId,
//                 sizeId: item.sizeId,
//                 quantity: item.quantity,
//                 price: item.price,
//                 percentDiscount: item.percentDiscount,
//                 productName: item.productName,
//                 color: item.color,
//                 size: item.size,
//                 imageUrl: item.imageUrl,
//               ))
//           .toList();

//       final orderData = OrderModel(
//         id: orderId,
//         userId: user.uid,
//         addressId: addressId,
//         items: orderItems,
//         totalAmount: totalAmount,
//         shippingCharge: 60.0,
//         paymentMethod: paymentMethod,
//         paymentStatus: paymentMethod == 'cod' ? 'pending' : 'awaiting_payment',
//         orderStatus: 'pending',
//         createdAt: DateTime.now(),
//       ).toMap();

//       await orderRef.set(orderData);

//       if (paymentMethod == 'cod') {
//         await _cartRepository.clearCart();
//       }

//       return orderId;
//     } catch (e) {
//       print('Failed to create order: $e');
//       throw Exception('Failed to create order: $e');
//     }
//   }
// // }
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:vesture_firebase_user/models/cart_item.dart';
// import 'package:vesture_firebase_user/models/order_model.dart';
// import 'package:vesture_firebase_user/repository/cart_repo.dart';

// class CheckoutRepository {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final CartRepository _cartRepository = CartRepository();

//   Future<String> createOrder({
//     required String addressId,
//     required List<CartItem> items,
//     required double totalAmount,
//     required String paymentMethod,
//     String? paymentId,
//   }) async {
//     final user = _auth.currentUser;
//     if (user == null) throw Exception('User not logged in');

//     try {
//       // Step 1: Verify user exists
//       final userDoc = await _firestore.collection('users').doc(user.uid).get();
//       if (!userDoc.exists) {
//         throw Exception('User data not found');
//       }

//       final orderRef = _firestore.collection('orders').doc();
//       final orderId = orderRef.id;

//       final orderItems = items
//           .map((item) => OrderItem(
//                 productId: item.productId,
//                 variantId: item.variantId,
//                 sizeId: item.sizeId,
//                 quantity: item.quantity,
//                 price: item.price,
//                 percentDiscount: item.percentDiscount,
//                 productName: item.productName,
//                 color: item.color,
//                 size: item.size,
//                 imageUrl: item.imageUrl,
//                 categoryOffer: item.categoryOffer,
//                 addedAt: DateTime.now(),
//               ))
//           .toList();

//       // Set payment status based on payment method
//       String paymentStatus;
//       if (paymentMethod == 'cod') {
//         paymentStatus = 'pending';
//       } else if (paymentMethod == 'stripe' && paymentId != null) {
//         paymentStatus = 'completed';
//       } else {
//         paymentStatus = 'awaiting_payment';
//       }

//       final orderData = OrderModel(
//         id: orderId,
//         userId: user.uid,
//         addressId: addressId,
//         items: orderItems,
//         totalAmount: totalAmount,
//         shippingCharge: 60.0,
//         paymentMethod: paymentMethod,
//         paymentStatus: paymentStatus,
//         orderStatus: 'pending',
//         createdAt: DateTime.now(),
//         paymentId: paymentId,
//       ).toMap();

//       await orderRef.set(orderData);

//       // Clear cart for COD or completed Stripe payments
//       if (paymentMethod == 'cod' ||
//           (paymentMethod == 'stripe' && paymentId != null)) {
//         await _cartRepository.clearCart();
//       }

//       return orderId;
//     } catch (e) {
//       print('Failed to create order: $e');
//       throw Exception('Failed to create order: $e');
//     }
//   }
// }
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:vesture_firebase_user/models/cart_item.dart';
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
  }) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('User not logged in');

    try {
      final userDoc = await _firestore.collection('users').doc(user.uid).get();
      if (!userDoc.exists) {
        throw Exception('User data not found');
      }

      final orderRef = _firestore.collection('orders').doc();
      final orderId = orderRef.id;

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

      // Calculate order totals
      double subTotal = 0;
      double totalDiscount = 0;
      double finalAmount = 0;

      for (var item in orderItems) {
        subTotal += item.originalPrice * item.quantity;
        totalDiscount += item.discountAmount;
        finalAmount += item.totalAmount;
      }

      final shippingCharge = 60.0;
      final totalAmount = finalAmount + shippingCharge;

      // Set payment status based on payment method
      String paymentStatus;
      if (paymentMethod == 'cod') {
        paymentStatus = 'pending';
      } else if (paymentMethod == 'stripe' && paymentId != null) {
        paymentStatus = 'completed';
      } else {
        paymentStatus = 'awaiting_payment';
      }

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
      ).toMap();

      await orderRef.set(orderData);

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
}
