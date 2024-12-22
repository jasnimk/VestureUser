import 'package:flutter/material.dart';
import 'package:vesture_firebase_user/widgets/textwidget.dart';

customButton({
  required BuildContext context,
  required String text,
  required VoidCallback onPressed,
  IconData? icon,
  Color textColor = Colors.white,
  double borderRadius = 8.0,
  double padding = 16.0,
  double fontSize = 18.0,
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (icon != null) Icon(icon, color: textColor),
          if (icon != null) SizedBox(width: 8),
          Text(
            text,
            style: TextStyle(
                color: textColor,
                fontSize: fontSize,
                fontWeight: fontWeight,
                fontFamily: 'Poppins-Bold'),
          ),
        ],
      ),
    ),
  );
}

customElevatedButton({
  required IconData icon,
  required String label,
  required VoidCallback onPressed,
  Color backgroundColor = Colors.transparent,
  EdgeInsetsGeometry padding = const EdgeInsets.symmetric(horizontal: 12),
}) {
  return ElevatedButton.icon(
    onPressed: onPressed,
    icon: Icon(icon),
    label: Text(
      label,
      style: styling(fontSize: 16),
    ),
    style: ElevatedButton.styleFrom(
      padding: padding,
      shape: const BeveledRectangleBorder(),
      elevation: 0,
      backgroundColor: backgroundColor,
    ),
  );
}
