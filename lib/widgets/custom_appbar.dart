import 'package:flutter/material.dart';
import 'package:vesture_firebase_user/widgets/textwidget.dart';

AppBar buildCustomAppBar({
  required BuildContext context,
  required String title,
  bool showBackButton = true,
  List<Widget>? actions, // Change this line to List<Widget>?
  TextStyle? titleTextStyle,
  IconData? leadingIcon,
  VoidCallback? onLeadingPressed,
}) {
  Color backgroundColor = Theme.of(context).colorScheme.surface;

  return AppBar(
    backgroundColor: backgroundColor,
    elevation: 0,
    centerTitle: false,
    // leading: showBackButton
    //     ? IconButton(
    //         icon: Icon(leadingIcon ?? Icons.arrow_back),
    //         onPressed: onLeadingPressed,
    //         color: Theme.of(context).textTheme.bodyMedium!.color,
    //         iconSize: 24,
    //       )
    //     : null,
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
