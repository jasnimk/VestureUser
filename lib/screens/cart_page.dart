import 'package:flutter/material.dart';
import 'package:vesture_firebase_user/widgets/custom_appbar.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildCustomAppBar(context: context, title: 'ShoppingCart'),
      body: const Center(child: Text('CartPAge')),
    );
  }
}
