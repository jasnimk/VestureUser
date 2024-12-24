import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:vesture_firebase_user/models/cart_item.dart';
import 'package:vesture_firebase_user/models/order_model.dart';
import 'package:vesture_firebase_user/repository/cart_repo.dart';

class CheckoutRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final CartRepository _cartRepository = CartRepository();

  CheckoutRepository() {}

  void _initializeRazorpay() {}

  Future<String> createOrder({
    required String addressId,
    required List<CartItem> items,
    required double totalAmount,
    required String paymentMethod,
  }) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('User not logged in');

    try {
      return await _firestore.runTransaction<String>((transaction) async {
        final orderItems = items
            .map((item) => OrderItem(
                  productId: item.productId,
                  variantId: item.variantId,
                  sizeId: item.sizeId,
                  quantity: item.quantity,
                  price: item.price,
                  percentDiscount: item.percentDiscount,
                  productName: item.productName,
                  color: item.color,
                  size: item.size,
                  imageUrl: item.imageUrl,
                ))
            .toList();

        // Create new order
        final orderRef = _firestore.collection('orders').doc();
        final order = OrderModel(
          id: orderRef.id,
          userId: user.uid,
          addressId: addressId,
          items: orderItems,
          totalAmount: totalAmount,
          shippingCharge: 60.0,
          paymentMethod: paymentMethod,
          paymentStatus: paymentMethod == 'cod' ? 'pending' : 'paid',
          orderStatus: 'pending',
          createdAt: DateTime.now(),
        );

        transaction.set(orderRef, order.toMap());

        await _cartRepository.clearCart();

        return orderRef.id;
      });
    } catch (e) {
      throw Exception('Failed to create order: $e');
    }
  }

  Future<void> initializeRazorpayPayment({
    required double amount,
    required List<CartItem> items,
  }) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('User not logged in');

    try {} catch (e) {
      throw Exception('Failed to initialize payment: $e');
    }
  }

  Future<String> finalizeRazorpayPayment({
    required String paymentId,
  }) async {
    throw UnimplementedError();
  }

  void dispose() {}
}
