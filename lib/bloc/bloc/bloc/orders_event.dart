abstract class OrdersEvent {}

class LoadOrders extends OrdersEvent {}

class CancelOrder extends OrdersEvent {
  final String orderId;
  final double amount;
  CancelOrder({required this.orderId, required this.amount});
}

class AdminCancelOrder extends OrdersEvent {
  final String orderId;
  AdminCancelOrder(this.orderId);
}
