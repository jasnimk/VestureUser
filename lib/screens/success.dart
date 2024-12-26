import 'package:flutter/material.dart';
import 'package:vesture_firebase_user/screens/shopping_page.dart';
import 'package:vesture_firebase_user/widgets/custom_button.dart';

class SuccessScreen extends StatelessWidget {
  const SuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/Images/success.png'),
                const SizedBox(
                    height: 20), // Add spacing between image and button
              ],
            ),
            Positioned(
              bottom: 180.0,
              left: 0,
              right: 0,
              child: Center(
                child: customButton(
                  context: context,
                  text: 'Continue Shopping🥳',
                  height: 50,
                  width: 200,
                  onPressed: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (ctx) => ShoppingPage()),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
