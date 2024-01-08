import 'package:flutter/material.dart';

class MainTheme {
  ThemeData get theme => ThemeData(
    brightness: Brightness.dark,
    textTheme: const TextTheme(
      headline1: TextStyle(color: Colors.white, fontSize: 25.0, fontWeight: FontWeight.bold),
      headline2: TextStyle(color: Colors.white, fontSize: 20.0),
      headline3: TextStyle(color: Colors.black, fontSize: 20.0),
      bodyText1: TextStyle(color: Colors.white, fontSize: 17.0),
      bodyText2: TextStyle(color: Colors.black, fontSize: 17.0),

    ),
    scaffoldBackgroundColor: const Color(0xFF222222),
    primaryColor: const Color(0xFF393939),
    primaryColorDark: Colors.black,
    primaryColorLight: Colors.white,
    shadowColor: Colors.black,
    cardColor: const Color(0xFF222222),
    canvasColor: const Color(0xFF303030),
    accentColor: Colors.white,
  );
}
