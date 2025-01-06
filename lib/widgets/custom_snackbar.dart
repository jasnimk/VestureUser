import 'package:flutter/material.dart';
import 'package:vesture_firebase_user/widgets/textwidget.dart';

class CustomSnackBar {
  static void show(
    BuildContext context, {
    required String message,
    Color backgroundColor = const Color.fromRGBO(196, 28, 13, 0.829),
    Color textColor = Colors.white,
    Duration duration = const Duration(seconds: 2),
    SnackBarAction? action,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: styling(color: textColor),
          textAlign: TextAlign.center,
        ),
        backgroundColor: backgroundColor,
        duration: duration,
        behavior: SnackBarBehavior.floating,
        action: action,
      ),
    );
  }
}
