import 'package:flutter/material.dart';

class MainTheme {
  ThemeData get theme => ThemeData(
    brightness: Brightness.dark,
    textTheme: const TextTheme(
      titleMedium: TextStyle(color: Colors.white, fontSize: 25.0, fontWeight: FontWeight.bold),
      titleSmall: TextStyle(color: Colors.black, fontSize: 25.0, fontWeight: FontWeight.bold),
      bodyMedium: TextStyle(color: Colors.white, fontSize: 17.0),
      bodySmall: TextStyle(color: Colors.black, fontSize: 17.0),
    ),
    scaffoldBackgroundColor: const Color(0xFF222222),
    primaryColor: const Color(0xFF393939),
    primaryColorDark: Colors.black,
    primaryColorLight: Colors.white,
    shadowColor: Colors.black,
    cardColor: const Color(0xFF222222),
    canvasColor: const Color(0xFF303030),
    //accentColor: Colors.white,
  );
}
