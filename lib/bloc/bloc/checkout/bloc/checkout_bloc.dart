import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vesture_firebase_user/bloc/bloc/checkout/bloc/checkout_event.dart';
import 'package:vesture_firebase_user/bloc/bloc/checkout/bloc/checkout_state.dart';
import 'package:vesture_firebase_user/repository/checkout_repo.dart';

class CheckoutBloc extends Bloc<CheckoutEvent, CheckoutState> {
  final CheckoutRepository _checkoutRepository;

  CheckoutBloc({required CheckoutRepository checkoutRepository})
      : _checkoutRepository = checkoutRepository,
        super(CheckoutInitial()) {
    on<InitiateCheckoutEvent>(_onInitiateCheckout);
    on<ProcessRazorpayPaymentEvent>(_onProcessRazorpayPayment);
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
      } else if (event.paymentMethod == 'razorpay') {
        emit(PaymentProcessing());
        // Initialize Razorpay payment
        await _checkoutRepository.initializeRazorpayPayment(
          amount: event.totalAmount,
          items: event.items,
        );
      }
    } catch (e) {
      emit(CheckoutError(e.toString()));
    }
  }

  Future<void> _onProcessRazorpayPayment(
    ProcessRazorpayPaymentEvent event,
    Emitter<CheckoutState> emit,
  ) async {
    try {
      emit(CheckoutLoading());
      final orderId = await _checkoutRepository.finalizeRazorpayPayment(
        paymentId: event.paymentId,
      );
      emit(CheckoutSuccess(orderId));
    } catch (e) {
      emit(CheckoutError(e.toString()));
    }
  }
}
