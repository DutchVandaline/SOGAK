import 'package:flutter/material.dart';
import 'package:sogak/Screens/MainScreen.dart';
import 'package:sogak/Theme/MainTheme.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: MainTheme().theme,
      home: MainScreen(),
    );
  }
}
