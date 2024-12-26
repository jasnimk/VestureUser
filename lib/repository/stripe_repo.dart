import 'package:dio/dio.dart';
import 'package:vesture_firebase_user/utilities/keysApi.dart';

class StripeService {
  StripeService._();

  static final StripeService instance = StripeService._();

  Future<void> makePayment({required double amount}) async {
    // Fixed: Removed extra amount field and added parameter
    try {
      String? result = await _createPaymentIntent(amount.toInt(), "usd");
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
        print(response.data);
        return response.data;
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
}
