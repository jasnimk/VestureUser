import 'package:flutter/material.dart';

ThemeData lightmode = ThemeData(
  brightness: Brightness.light,
  colorScheme: const ColorScheme.light(
      surface: Colors.white,
      primary: Color.fromRGBO(196, 28, 13, 0.829),
      secondary: Color.fromARGB(255, 216, 114, 114),
      tertiary: Colors.black),

  textTheme: const TextTheme(
    bodyLarge: TextStyle(color: Colors.black), 
    bodyMedium: TextStyle(color: Colors.black), 
    displayLarge: TextStyle(color: Colors.blue), 
    displayMedium: TextStyle(color: Colors.blue),
    displaySmall: TextStyle(color: Colors.blue), 
    headlineMedium: TextStyle(color: Colors.blue), 
    headlineSmall: TextStyle(color: Colors.blue),
    titleLarge: TextStyle(color: Colors.blue),
    titleMedium: TextStyle(color: Colors.black54), 
    titleSmall: TextStyle(color: Colors.black54),
    bodySmall: TextStyle(color: Colors.grey),
    labelLarge: TextStyle(color: Colors.white), 
    labelSmall: TextStyle(color: Colors.grey),
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

  textTheme: const TextTheme(
    bodyLarge: TextStyle(color: Colors.white),
    bodyMedium: TextStyle(color: Colors.white), 
    displayLarge: TextStyle(color: Colors.yellow),
    displayMedium: TextStyle(color: Colors.yellow), 
    displaySmall: TextStyle(color: Colors.yellow), 
    headlineMedium: TextStyle(color: Colors.yellow), 
    headlineSmall: TextStyle(color: Colors.yellow), 
    titleLarge: TextStyle(color: Colors.yellow), 
    titleMedium: TextStyle(color: Colors.white70),
    titleSmall: TextStyle(color: Colors.white70), 
    bodySmall: TextStyle(color: Colors.grey), 
    labelLarge: TextStyle(color: Colors.black), 
    labelSmall: TextStyle(color: Colors.grey), 
  ),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: Colors.black,
    selectedItemColor: Colors.white,
    unselectedItemColor: Colors.grey,
  ),
);
