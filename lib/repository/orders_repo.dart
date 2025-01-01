import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:vesture_firebase_user/models/order_model.dart';
import 'package:vesture_firebase_user/repository/wallet_repo.dart';

class OrdersRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final WalletRepository _walletRepository = WalletRepository();

  Stream<List<OrderModel>> getOrders() {
    final user = _auth.currentUser;
    if (user == null) throw Exception('User not logged in');

    return _firestore
        .collection('orders')
        .where('userId', isEqualTo: user.uid)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => OrderModel.fromMap(doc.data(), doc.id))
          .toList();
    });
  }

  Future<void> updateOrderToDelivered(String orderId) async {
    final orderRef = _firestore.collection('orders').doc(orderId);

    await orderRef.update({
      'orderStatus': 'delivered',
      'deliveredAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> cancelOrder(String orderId) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('User not logged in');

    final orderRef = _firestore.collection('orders').doc(orderId);

    return _firestore.runTransaction((transaction) async {
      final orderDoc = await transaction.get(orderRef);
      if (!orderDoc.exists) {
        throw Exception('Order not found');
      }

      final order = OrderModel.fromMap(orderDoc.data()!, orderDoc.id);

      // Verify order belongs to current user
      if (order.userId != user.uid) {
        throw Exception('Unauthorized to cancel this order');
      }

      // Check if already cancelled
      if (order.orderStatus.toLowerCase() == 'cancelled') {
        throw Exception('Order is already cancelled');
      }

      // Check if order is delivered and within cancellation window
      if (order.orderStatus.toLowerCase() != 'delivered') {
        throw Exception('Only delivered orders can be cancelled');
      }

      if (order.deliveredAt == null) {
        throw Exception('Delivery date not found');
      }

      final daysSinceDelivery =
          DateTime.now().difference(order.deliveredAt!).inDays;
      if (daysSinceDelivery > 3) {
        throw Exception(
            'Order can only be cancelled within 3 days of delivery');
      }

      // Process refund based on payment method
      await _walletRepository.addToWallet(
        order.totalAmount,
        'Refund for cancelled order #${order.id.substring(0, 8)}',
        order.id,
      );

      // Update order status to cancelled and add cancellation metadata
      transaction.update(orderRef, {
        'orderStatus': 'cancelled',
        'cancelledAt': FieldValue.serverTimestamp(),
        'refundedToWallet': true,
        'refundAmount': order.totalAmount,
        'daysSinceDelivery': daysSinceDelivery,
      });
    });
  }

  Future<OrderModel> getOrder(String orderId) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('User not logged in');

    final doc = await _firestore.collection('orders').doc(orderId).get();

    if (!doc.exists) {
      throw Exception('Order not found');
    }

    final order = OrderModel.fromMap(doc.data()!, doc.id);

    // Verify order belongs to current user
    if (order.userId != user.uid) {
      throw Exception('Unauthorized to access this order');
    }

    return order;
  }
}
