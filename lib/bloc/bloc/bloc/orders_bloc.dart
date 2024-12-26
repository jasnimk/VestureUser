import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vesture_firebase_user/bloc/bloc/bloc/orders_event.dart';
import 'package:vesture_firebase_user/bloc/bloc/bloc/orders_state.dart';
import 'package:vesture_firebase_user/models/order_model.dart';
import 'package:vesture_firebase_user/repository/orders_repo.dart';

class OrdersBloc extends Bloc<OrdersEvent, OrdersState> {
  final OrdersRepository _ordersRepository;

  OrdersBloc(this._ordersRepository) : super(OrdersInitial()) {
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
  }
}
