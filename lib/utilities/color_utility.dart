import 'package:flutter/material.dart';

class ColorUtil {
  // Mapping of color names to Color objects
  static final Map<String, Color> colorNameToColor = {
    "Red": Colors.red,
    "Pink": Colors.pink,
    "Purple": Colors.purple,
    "Deep Purple": Colors.deepPurple,
    "Indigo": Colors.indigo,
    "Blue": Colors.blue,
    "Light Blue": Colors.lightBlue,
    "Cyan": Colors.cyan,
    "Teal": Colors.teal,
    "Green": Colors.green,
    "Light Green": Colors.lightGreen,
    "Lime": Colors.lime,
    "Yellow": Colors.yellow,
    "Amber": Colors.amber,
    "Orange": Colors.orange,
    "Deep Orange": Colors.deepOrange,
    "Brown": Colors.brown,
    "Grey": Colors.grey,
    "Blue Grey": Colors.blueGrey,
    "Black": Colors.black,
    "White": Colors.white,
  };

  // Hex to color name mapping
  static final Map<String, String> hexToColorName = {
    "#FF0000": "Red",
    "#F44336": "Red",
    "#E91E63": "Pink",
    "#9C27B0": "Purple",
    "#673AB7": "Deep Purple",
    "#3F51B5": "Indigo",
    "#2196F3": "Blue",
    "#03A9F4": "Light Blue",
    "#00BCD4": "Cyan",
    "#009688": "Teal",
    "#4CAF50": "Green",
    "#8BC34A": "Light Green",
    "#CDDC39": "Lime",
    "#FFEB3B": "Yellow",
    "#FFC107": "Amber",
    "#FF9800": "Orange",
    "#FF5722": "Deep Orange",
    "#795548": "Brown",
    "#9E9E9E": "Grey",
    "#607D8B": "Blue Grey",
    "#000000": "Black",
    "#FFFFFF": "White",
  };

  // Convert hex to color name
  static String colorNameFromHex(String hex) {
    return hexToColorName[hex.toUpperCase()] ?? "Unknown";
  }

  // Get Color object from color name
  static Color getColorFromName(String colorName) {
    return colorNameToColor[colorName] ?? Colors.grey;
  }

  // Get Color object directly from hex
  static Color getColorFromHex(String hex) {
    return Color(int.parse(
        hex.startsWith('#') ? '0xFF' + hex.substring(1) : '0xFF' + hex));
  }
}
