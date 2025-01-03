import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:vesture_firebase_user/screens/cart_page.dart';
import 'package:vesture_firebase_user/screens/shopping_page.dart';
import 'package:vesture_firebase_user/widgets/custom_button.dart';

class CartSucces extends StatelessWidget {
  const CartSucces({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
              height: 250,
              child: Lottie.asset(
                  'assets/animations/Animation - 1735834409097.json')),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: customButton(
                    height: 50,
                    fontSize: 15,
                    context: context,
                    text: 'Go to Cart',
                    onPressed: () {
                      Navigator.of(context)
                          .pushReplacement(MaterialPageRoute(builder: (ctx) {
                        return CartScreen();
                      }));
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: customButton(
                    height: 50,
                    fontSize: 15,
                    context: context,
                    text: 'Continue Shopping',
                    onPressed: () {
                      Navigator.of(context)
                          .pushReplacement(MaterialPageRoute(builder: (ctx) {
                        return ShoppingPage();
                      }));
                    },
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
