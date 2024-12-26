import 'package:flutter/material.dart';
import 'package:vesture_firebase_user/widgets/textwidget.dart';

AppBar buildCustomAppBar({
  required BuildContext context,
  required String title,
  bool showBackButton = true,
  List<Widget>? actions,
  TextStyle? titleTextStyle,
  IconData? leadingIcon,
  VoidCallback? onLeadingPressed,
}) {
  Color backgroundColor = Theme.of(context).colorScheme.surface;

  return AppBar(
    backgroundColor: backgroundColor,
    elevation: 0,
    centerTitle: false,
    actions: actions,
    title: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        if (showBackButton) const SizedBox(width: 0),
        Text(
          title,
          style: titleTextStyle ??
              styling(fontSize: 20, fontFamily: 'Poppins-Bold'),
        ),
      ],
    ),
  );
}
