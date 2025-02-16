import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vesture_firebase_user/bloc/bloc/bloc/orders_event.dart';
import 'package:vesture_firebase_user/bloc/bloc/bloc/orders_state.dart';
import 'package:vesture_firebase_user/bloc/wallet/bloc/wallet_bloc.dart';
import 'package:vesture_firebase_user/models/order_model.dart';
import 'package:vesture_firebase_user/repository/orders_repo.dart';

class OrdersBloc extends Bloc<OrdersEvent, OrdersState> {
  final OrdersRepository _ordersRepository;
  final WalletBloc _walletBloc;

  OrdersBloc(this._ordersRepository, this._walletBloc)
      : super(OrdersInitial()) {
    // Handles the loading of orders and emits appropriate states.
    on<LoadOrders>((event, emit) async {
      emit(OrdersLoading());
      try {
        await emit.forEach(
          _ordersRepository.getOrders(),
          onData: (List<OrderModel> orders) => OrdersLoaded(orders),
          onError: (error, stackTrace) => OrdersError(error.toString()),
        );
      } catch (e) {
        emit(OrdersError(e.toString()));
      }
    });

    // Handles the cancellation of an order by the user.
    on<CancelOrder>((event, emit) async {
      emit(OrderCancellationInProgress());
      try {
        await _ordersRepository.cancelOrder(event.orderId);
        emit(OrderCancellationSuccess('Order cancelled successfully'));
      } catch (e) {
        emit(OrderCancellationFailure(e.toString()));
      }
    });

    // Handles the cancellation of an order by an admin.
    on<AdminCancelOrder>((event, emit) async {
      emit(OrderCancellationInProgress());
      try {
        await _ordersRepository.adminCancelOrder(event.orderId);
        emit(OrderCancellationSuccess('Order cancelled by admin successfully'));
      } catch (e) {
        emit(OrderCancellationFailure(e.toString()));
      }
    });
  }
}
