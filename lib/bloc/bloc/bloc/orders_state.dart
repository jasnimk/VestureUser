import 'package:vesture_firebase_user/models/order_model.dart';

abstract class OrdersState {}

class OrdersInitial extends OrdersState {}

class OrdersLoading extends OrdersState {}

class OrdersLoaded extends OrdersState {
  final List<OrderModel> orders;
  OrdersLoaded(this.orders);
}

class OrdersError extends OrdersState {
  final String message;
  OrdersError(this.message);
}

class OrderCancellationInProgress extends OrdersState {}

class OrderCancellationSuccess extends OrdersState {
  final String message;
  OrderCancellationSuccess(this.message);
}

class OrderCancellationFailure extends OrdersState {
  final String error;
  OrderCancellationFailure(this.error);
}
