import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vesture_firebase_user/bloc/bloc/cart/bloc/cart_bloc.dart';
import 'package:vesture_firebase_user/bloc/bloc/cart/bloc/cart_event.dart';
import 'package:vesture_firebase_user/bloc/bloc/checkout/bloc/checkout_bloc.dart';
import 'package:vesture_firebase_user/bloc/bloc/coupon/bloc/coupon_bloc.dart';
import 'package:vesture_firebase_user/repository/checkout_repo.dart';
import 'package:vesture_firebase_user/screens/checkout_screen.dart';
import 'package:vesture_firebase_user/widgets/custom_button.dart';
import 'package:vesture_firebase_user/widgets/textwidget.dart';

class CartSummaryWidget extends StatelessWidget {
  final double totalAmount;
  final double totalDiscount;
  final double actualTotal;

  const CartSummaryWidget(
      {super.key,
      required this.totalAmount,
      required this.totalDiscount,
      required this.actualTotal});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Actual Amount:',
                      style: styling(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '₹${actualTotal.toStringAsFixed(2)}',
                      style: headerStyling(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Discount applied:',
                      style: styling(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '-₹${totalDiscount.toStringAsFixed(2)}',
                      style: TextStyle(
                        color: Colors.green.shade700,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total Amount:',
                      style: headerStyling(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '₹${totalAmount.toStringAsFixed(2)}',
                      style: headerStyling(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: customButton(
                  context: context,
                  text: 'Proceed to Checkout',
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => MultiBlocProvider(
                          providers: [
                            BlocProvider.value(
                              value: context.read<CartBloc>(),
                            ),
                            BlocProvider.value(
                              value: context.read<CouponBloc>(),
                            ),
                            BlocProvider(
                              create: (context) => CheckoutBloc(
                                cartBloc: context.read<CartBloc>(),
                                checkoutRepository: CheckoutRepository(),
                                couponBloc: context.read<CouponBloc>(),
                              ),
                            ),
                          ],
                          child: const CheckoutScreen(),
                        ),

                        // Navigator.of(context).push(
                        //   MaterialPageRoute(
                        //     builder: (context) => MultiBlocProvider(
                        //       providers: [
                        //         BlocProvider.value(
                        //           value: BlocProvider.of<CartBloc>(context)
                        //             ..add(LoadCartEvent()),
                        //         ),
                        //         BlocProvider(
                        //           create: (context) => CheckoutBloc(
                        //               cartBloc: context.read<CartBloc>(),
                        //               checkoutRepository: CheckoutRepository(),
                        //               couponBloc: context.read()<CouponBloc>()),
                        //         ),
                        //       ],
                        //       child: const CheckoutScreen(),
                        //     ),
                      ),
                    );
                  }),
              height: 50,
            ),
          ],
        ),
      ),
    );
  }
}
