import 'package:flutter/material.dart';

class BubbleClipper extends CustomClipper<Path> {
  final bool isSender;

  BubbleClipper(this.isSender);

  @override
  Path getClip(Size size) {
    Path path = Path();

    if (isSender) {
      path.lineTo(0, 0);
      path.lineTo(size.width - 10, 0);
      path.quadraticBezierTo(size.width, 0, size.width, 10);
      path.lineTo(size.width, size.height - 10);
      path.quadraticBezierTo(
          size.width, size.height, size.width - 10, size.height);
      path.lineTo(10, size.height);
      path.quadraticBezierTo(0, size.height, 0, size.height - 10);
      path.close();
    } else {
      path.lineTo(0, 0);
      path.lineTo(size.width - 10, 0);
      path.quadraticBezierTo(size.width, 0, size.width, 10);
      path.lineTo(size.width, size.height - 10);
      path.quadraticBezierTo(
          size.width, size.height, size.width - 10, size.height);
      path.lineTo(10, size.height);
      path.quadraticBezierTo(0, size.height, 0, size.height - 10);
      path.close();
    }

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

Widget messageBubble(String message, bool isSender) {
  return ClipPath(
    clipper: BubbleClipper(isSender),
    child: Container(
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
      decoration: BoxDecoration(
        color: isSender
            ? const Color.fromARGB(255, 184, 155, 59)
            : Colors.grey[300],
      ),
      child: Text(
        message,
        style: TextStyle(
          fontSize: 16.0,
        ),
      ),
    ),
  );
}
