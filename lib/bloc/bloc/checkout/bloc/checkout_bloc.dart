import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vesture_firebase_user/bloc/bloc/cart/bloc/cart_bloc.dart';
import 'package:vesture_firebase_user/bloc/bloc/checkout/bloc/checkout_event.dart';
import 'package:vesture_firebase_user/bloc/bloc/checkout/bloc/checkout_state.dart';
import 'package:vesture_firebase_user/repository/checkout_repo.dart';

class CheckoutBloc extends Bloc<CheckoutEvent, CheckoutState> {
  final CheckoutRepository _checkoutRepository;
  final CartBloc _cartBloc;

  CheckoutBloc({
    required CheckoutRepository checkoutRepository,
    required CartBloc cartBloc,
  })  : _checkoutRepository = checkoutRepository,
        _cartBloc = cartBloc,
        super(CheckoutInitial()) {
    on<InitiateCheckoutEvent>(_onInitiateCheckout);
  }

  Future<void> _onInitiateCheckout(
    InitiateCheckoutEvent event,
    Emitter<CheckoutState> emit,
  ) async {
    try {
      emit(CheckoutLoading());

      if (event.paymentMethod == 'cod') {
        final orderId = await _checkoutRepository.createOrder(
          addressId: event.addressId,
          items: event.items,
          totalAmount: event.totalAmount,
          paymentMethod: 'cod',
        );
        emit(CheckoutSuccess(orderId));
      } else if (event.paymentMethod == 'stripe') {
        emit(PaymentProcessing());
        // Stripe implementation will go here later
      }
    } catch (e) {
      emit(CheckoutError(e.toString()));
    }
  }
}
