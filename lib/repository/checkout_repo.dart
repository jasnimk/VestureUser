import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:vesture_firebase_user/models/cart_item.dart';
import 'package:vesture_firebase_user/models/order_model.dart';
import 'package:vesture_firebase_user/repository/cart_repo.dart';

class CheckoutRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final CartRepository _cartRepository = CartRepository();
  // final Razorpay _razorpay = Razorpay();

  CheckoutRepository() {
    //  _initializeRazorpay();
  }

  void _initializeRazorpay() {
    // _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    // _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
  }

  // void _handlePaymentSuccess(PaymentSuccessResponse response) {
  //   // Handle payment success
  // }

  // void _handlePaymentError(PaymentFailureResponse response) {
  //   // Handle payment failure
  // }

  Future<String> createOrder({
    required String addressId,
    required List<CartItem> items,
    required double totalAmount,
    required String paymentMethod,
  }) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('User not logged in');

    try {
      // Start a transaction
      return await _firestore.runTransaction<String>((transaction) async {
        // Convert cart items to order items
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
          shippingCharge: 60.0, // Fixed shipping charge
          paymentMethod: paymentMethod,
          paymentStatus: paymentMethod == 'cod' ? 'pending' : 'paid',
          orderStatus: 'pending',
          createdAt: DateTime.now(),
        );

        // Set the order document
        transaction.set(orderRef, order.toMap());

        // Clear the cart
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

    var options = {
      'key': 'YOUR_RAZORPAY_KEY',
      'amount': (amount * 100).toInt(), // Amount in smallest currency unit
      'name': 'Vesture Store',
      'description': '${items.length} items',
      'prefill': {
        'contact': user.phoneNumber ?? '',
        'email': user.email ?? '',
      }
    };

    try {
      // _razorpay.open(options);
    } catch (e) {
      throw Exception('Failed to initialize payment: $e');
    }
  }

  Future<String> finalizeRazorpayPayment({
    required String paymentId,
  }) async {
    // Verify payment with Razorpay
    // Create order after successful payment
    // Return order ID
    throw UnimplementedError();
  }

  void dispose() {
    // _razorpay.clear();
  }
}
