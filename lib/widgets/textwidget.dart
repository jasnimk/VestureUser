import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

Widget textWidget(String name, BuildContext context) {
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
  Color? color = const Color(0xFF000000),
  FontStyle fontStyle = FontStyle.normal,
  double letterSpacing = 0.0,
  double wordSpacing = 0.0,
  TextDecoration decoration = TextDecoration.none,
  double? height,
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

Widget buildProfileListTile(
    {required String title, String? subtitle, required VoidCallback onTap}) {
  return ListTile(
    title: Text(
      title,
      style: styling(fontSize: 16, fontWeight: FontWeight.w600),
    ),
    subtitle: Text(
      subtitle ?? '',
      style: styling(
          fontSize: 14, fontWeight: FontWeight.w400, color: Colors.grey),
    ),
    trailing: const Icon(Icons.arrow_forward),
    onTap: onTap,
  );
}

enum SpinkitType {
  circle,
  fadingCube,
  wave,
  fadingGrid,
  chasingDots,
  pulse,
  dualRing,
  squareCircle,
  rotatingPlain,
  fadingFour,
  threeBounce,
  cubeGrid,
}

Widget customSpinkitLoaderWithType({
  required BuildContext context,
  SpinkitType type = SpinkitType.circle,
  Color color = Colors.blue,
  double size = 50.0,
}) {
  switch (type) {
    case SpinkitType.fadingCube:
      return SpinKitFadingCube(color: color, size: size);
    case SpinkitType.wave:
      return SpinKitWave(color: color, size: size);
    case SpinkitType.fadingGrid:
      return SpinKitFadingGrid(color: color, size: size);
    case SpinkitType.chasingDots:
      return SpinKitChasingDots(color: color, size: size);
    case SpinkitType.pulse:
      return SpinKitPulse(color: color, size: size);
    case SpinkitType.dualRing:
      return SpinKitDualRing(color: color, size: size);
    case SpinkitType.squareCircle:
      return SpinKitSquareCircle(color: color, size: size);
    case SpinkitType.rotatingPlain:
      return SpinKitRotatingPlain(color: color, size: size);
    case SpinkitType.fadingFour:
      return SpinKitFadingFour(color: color, size: size);
    case SpinkitType.threeBounce:
      return SpinKitThreeBounce(color: color, size: size);
    case SpinkitType.cubeGrid:
      return SpinKitCubeGrid(color: color, size: size);
    default:
      return SpinKitCircle(color: color, size: size);
  }
}

Widget customCircularProgressIndicator({Color? color, double? size}) {
  return Center(
    child: SpinKitCircle(
      color: color ?? Colors.blue,
      size: size ?? 50.0,
    ),
  );
}

customDivider() {
  return Divider(
    color: Colors.grey,
    thickness: 1,
    indent: 16,
    endIndent: 16,
  );
}

TextStyle headerStyling({
  String fontFamily = 'Poppins-Bold',
  double fontSize = 20.0,
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

TextStyle subHeaderStyling({
  String fontFamily = 'Poppins-SemiBold',
  double fontSize = 16.0,
  FontWeight fontWeight = FontWeight.normal,
  Color color = Colors.grey,
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

class CustomTextField extends StatelessWidget {
  final String? labelText;
  final String? hintText;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final TextEditingController? controller;
  final bool obscureText;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final void Function()? onSuffixIconPressed;

  const CustomTextField({
    Key? key,
    this.labelText,
    this.hintText,
    this.prefixIcon,
    this.suffixIcon,
    this.controller,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.onChanged,
    this.onSuffixIconPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      validator: validator,
      onChanged: onChanged,
      style: styling(),
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        hintStyle: styling(),
        prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
        suffixIcon: suffixIcon != null
            ? IconButton(
                icon: Icon(suffixIcon),
                onPressed: onSuffixIconPressed,
              )
            : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.blue, width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
      ),
    );
  }
}
