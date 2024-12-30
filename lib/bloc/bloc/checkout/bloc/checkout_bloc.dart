import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vesture_firebase_user/bloc/bloc/cart/bloc/cart_bloc.dart';
import 'package:vesture_firebase_user/bloc/bloc/checkout/bloc/checkout_event.dart';
import 'package:vesture_firebase_user/bloc/bloc/checkout/bloc/checkout_state.dart';
import 'package:vesture_firebase_user/repository/checkout_repo.dart';
import 'package:vesture_firebase_user/repository/wallet_repo.dart';

class CheckoutBloc extends Bloc<CheckoutEvent, CheckoutState> {
  final CheckoutRepository _checkoutRepository;
  final WalletRepository _walletRepository;

  CheckoutBloc({
    required CheckoutRepository checkoutRepository,
    required CartBloc cartBloc,
  })  : _checkoutRepository = checkoutRepository,
        _walletRepository = WalletRepository(),
        super(CheckoutInitial()) {
    on<InitiateCheckoutEvent>(_onInitiateCheckout);
    on<StripePaymentSuccessEvent>(_onStripePaymentSuccess);
    on<WalletPaymentEvent>(_onWalletPayment);
  }
  Future _onWalletPayment(
    WalletPaymentEvent event,
    Emitter emit,
  ) async {
    try {
      emit(CheckoutLoading());

      final orderId = await _checkoutRepository.createOrder(
        addressId: event.addressId,
        items: event.items,
        paymentMethod: 'wallet',
        paymentId: null,
      );

      try {
        await _walletRepository.deductFromWallet(
          event.totalAmount,
          'Payment for order #$orderId',
          orderId,
        );

        await _checkoutRepository.updateOrderPaymentStatus(
            orderId, 'completed');

        emit(WalletPaymentCompleted(orderId));
      } catch (walletError) {
        await _checkoutRepository.updateOrderPaymentStatus(orderId, 'failed');
        throw walletError;
      }
    } catch (e) {
      emit(CheckoutError(e.toString()));
    }
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
          paymentMethod: 'cod',
          paymentId: null,
        );
        emit(CheckoutSuccess(orderId));
      } else if (event.paymentMethod == 'stripe') {
        // Emit PaymentProcessing state
        emit(PaymentProcessing());
        // Store order details temporarily
        emit(StripePaymentInitiated(
          addressId: event.addressId,
          items: event.items,
          totalAmount: event.totalAmount,
        ));
      }
    } catch (e) {
      emit(CheckoutError(e.toString()));
    }
  }

  Future<void> _onStripePaymentSuccess(
    StripePaymentSuccessEvent event,
    Emitter<CheckoutState> emit,
  ) async {
    try {
      final currentState = state;

      emit(CheckoutLoading());

      if (currentState is StripePaymentInitiated) {
        final orderId = await _checkoutRepository.createOrder(
          addressId: currentState.addressId,
          items: currentState.items,
          paymentMethod: 'stripe',
          paymentId: event.paymentIntentId,
        );

        emit(CheckoutSuccess(orderId));
      } else {
        emit(CheckoutError(
            'Invalid state transition: Payment success received before checkout initiation'));
      }
    } catch (e) {
      emit(CheckoutError(e.toString()));
    }
  }
}
