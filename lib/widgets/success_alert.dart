import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:vesture_firebase_user/screens/cart_page.dart';
import 'package:vesture_firebase_user/screens/favorite_page.dart';

void showSuccessAlert({
  required BuildContext context,
  required String message,
  required String actionLabel,
  required VoidCallback actionCallback,
  bool isCartAction = false, // Add this flag to check context
}) {
  showDialog(
    context: context,
    builder: (BuildContext dialogContext) {
      return AlertDialog(
        title: Text(
          message,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
            onPressed: () => Navigator.of(dialogContext).pop(),
          ),
          TextButton(
            child: Text(actionLabel, style: const TextStyle(color: Colors.red)),
            onPressed: () {
              actionCallback();
              Navigator.of(dialogContext).pop();
            },
          ),
          // If the action is Cart, add a button to navigate to CartPage
          if (isCartAction)
            TextButton(
              child: const Text(
                'Go to Cart',
                style: TextStyle(color: Colors.blue),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CartScreen()),
                );
              },
            ),
          // If the action is Favorite, add a button to navigate to FavoritesPage
          if (!isCartAction)
            TextButton(
              child: const Text(
                'Go to Favorites',
                style: TextStyle(color: Colors.blue),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FavoritesPage()),
                );
              },
            ),
        ],
      );
    },
  );
}
