import 'package:flutter/material.dart';

textWidget(String name, BuildContext context) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Text(
      name,
      style: TextStyle(
          color: Theme.of(context).textTheme.bodyLarge!.color,
          fontSize: 15,
          fontFamily: 'Poppins-SemiBold'),
    ),
  );
}

TextStyle styling({
  String fontFamily = 'Poppins-Regular',
  double fontSize = 14.0,
  FontWeight fontWeight = FontWeight.normal,
  Color color = const Color(0xFF000000),
  FontStyle fontStyle = FontStyle.normal,
  double letterSpacing = 0.0,
  double wordSpacing = 0.0,
  TextDecoration decoration = TextDecoration.none,
}) {
  return TextStyle(
    fontFamily: fontFamily,
    fontSize: fontSize,
    fontWeight: fontWeight,
    color: color,
    fontStyle: fontStyle,
    letterSpacing: letterSpacing,
    wordSpacing: wordSpacing,
    decoration: decoration,
  );
}

buildProfileListTile(
    {required String title,
    required String subtitle,
    required VoidCallback onTap}) {
  return ListTile(
    title: Text(
      title,
      style: styling(fontSize: 16, fontWeight: FontWeight.w600 // SemiBold
          ),
    ),
    subtitle: Text(
      subtitle,
      style: styling(
          fontSize: 14,
          fontWeight: FontWeight.w400, // Regular
          color: Colors.grey),
    ),
    trailing: const Icon(Icons.arrow_forward),
    onTap: onTap,
  );
}
