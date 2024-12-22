import 'package:flutter/material.dart';

ThemeData lightmode = ThemeData(
  brightness: Brightness.light,
  colorScheme: const ColorScheme.light(
      surface: Colors.white,
      primary: Color.fromRGBO(196, 28, 13, 0.829),
      secondary: Color.fromARGB(255, 216, 114, 114),
      tertiary: Colors.black),
  // Define custom text colors for the light mode
  textTheme: const TextTheme(
    bodyLarge: TextStyle(color: Colors.black), // Body text color
    bodyMedium: TextStyle(color: Colors.black), // Body text color
    displayLarge: TextStyle(color: Colors.blue), // Headline 1 color
    displayMedium: TextStyle(color: Colors.blue), // Headline 2 color
    displaySmall: TextStyle(color: Colors.blue), // Headline 3 color
    headlineMedium: TextStyle(color: Colors.blue), // Headline 4 color
    headlineSmall: TextStyle(color: Colors.blue), // Headline 5 color
    titleLarge: TextStyle(color: Colors.blue), // Headline 6 color
    titleMedium: TextStyle(color: Colors.black54), // Subtitle color
    titleSmall: TextStyle(color: Colors.black54), // Subtitle color
    bodySmall: TextStyle(color: Colors.grey), // Caption color
    labelLarge: TextStyle(color: Colors.white), // Button text color
    labelSmall: TextStyle(color: Colors.grey), // Overline color
  ),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: Colors.white,
    selectedItemColor: Color.fromRGBO(196, 28, 13, 0.829),
    unselectedItemColor: Colors.black87,
  ),
);

ThemeData darkmode = ThemeData(
  brightness: Brightness.dark,
  colorScheme: ColorScheme.dark(
    surface: Colors.grey.shade900,
    primary: const Color.fromARGB(255, 255, 255, 255),
  ),
  // Define custom text colors for the dark mode
  textTheme: const TextTheme(
    bodyLarge: TextStyle(color: Colors.white), // Body text color
    bodyMedium: TextStyle(color: Colors.white), // Body text color
    displayLarge: TextStyle(color: Colors.yellow), // Headline 1 color
    displayMedium: TextStyle(color: Colors.yellow), // Headline 2 color
    displaySmall: TextStyle(color: Colors.yellow), // Headline 3 color
    headlineMedium: TextStyle(color: Colors.yellow), // Headline 4 color
    headlineSmall: TextStyle(color: Colors.yellow), // Headline 5 color
    titleLarge: TextStyle(color: Colors.yellow), // Headline 6 color
    titleMedium: TextStyle(color: Colors.white70), // Subtitle color
    titleSmall: TextStyle(color: Colors.white70), // Subtitle color
    bodySmall: TextStyle(color: Colors.grey), // Caption color
    labelLarge: TextStyle(color: Colors.black), // Button text color
    labelSmall: TextStyle(color: Colors.grey), // Overline color
  ),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: Colors.black,
    selectedItemColor: Colors.white,
    unselectedItemColor: Colors.grey,
  ),
);
