import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:vesture_firebase_user/bloc/bloc/checkout/bloc/checkout_bloc.dart';
import 'package:vesture_firebase_user/bloc/bloc/checkout/bloc/checkout_event.dart';
import 'package:vesture_firebase_user/utilities/keysApi.dart';

class StripeService {
  StripeService._();

  static final StripeService instance = StripeService._();

  Future<void> makePayment({
    required double amount,
    required BuildContext context,
  }) async {
    // Fixed: Removed extra amount field and added parameter
    try {
      String? paymentIntentClientSecret =
          await _createPaymentIntent(amount.toInt(), "usd");
      if (paymentIntentClientSecret == null) return;
      await Stripe.instance.initPaymentSheet(
          paymentSheetParameters: SetupPaymentSheetParameters(
        paymentIntentClientSecret: paymentIntentClientSecret,
        merchantDisplayName: 'user',
      ));
      await _processPayment(context, paymentIntentClientSecret);
    } catch (e) {
      print(e);
    }
  }

  Future<String?> _createPaymentIntent(int amount, String currency) async {
    try {
      final Dio dio = Dio();
      final amt = _calculateAmount(amount);
      Map<String, dynamic> data = {"amount": amt, "currency": currency};
      var response = await dio.post('https://api.stripe.com/v1/payment_intents',
          data: data,
          options:
              Options(contentType: Headers.formUrlEncodedContentType, headers: {
            "Authorization": "Bearer $stripeSecretKey",
            "Content-Type": 'application/x-www-form-urlencoded'
          }));

      if (response.data != null) {
        // print(response.data);
        return response.data['client_secret'];
      }
      return null;
    } catch (e) {
      print(e);
    }
    return null;
  }

  String _calculateAmount(int amount) {
    final calculatedAmount = amount * 100;
    return calculatedAmount.toString();
  }

  Future<void> _processPayment(
    BuildContext context,
    String paymentIntentClientSecret,
  ) async {
    try {
      await Stripe.instance.presentPaymentSheet();

      // Extract payment intent ID from client secret
      final paymentIntentId = paymentIntentClientSecret.split('_secret')[0];

      // Notify the bloc that payment was successful
      context.read<CheckoutBloc>().add(
            StripePaymentSuccessEvent(paymentIntentId),
          );
    } catch (e) {
      print(e);
      throw Exception('Payment failed: ${e.toString()}');
    }
  }

  // Future<void> _processPayment() async {
  //   try {
  //     await Stripe.instance.presentPaymentSheet();
  //   } catch (e) {
  //     print(e);
  //   }
  // }
}
