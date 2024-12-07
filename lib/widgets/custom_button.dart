import 'package:flutter/material.dart';

customButton({
  required BuildContext context,
  required String text,
  required VoidCallback onPressed,
  // Color color = Theme.of(context).colorScheme.primary,
  Color textColor = Colors.white,
  double borderRadius = 8.0,
  double padding = 16.0,
  double fontSize = 16.0,
  FontWeight fontWeight = FontWeight.bold,
  double? width,
  double height = 90.0,
}) {
  return SizedBox(
    width: width ?? double.infinity,
    height: height,
    child: ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Theme.of(context).colorScheme.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        padding: EdgeInsets.symmetric(vertical: padding),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: Theme.of(context).textTheme.labelLarge!.color,
          fontSize: fontSize,
          fontWeight: fontWeight,
        ),
      ),
    ),
  );
}
