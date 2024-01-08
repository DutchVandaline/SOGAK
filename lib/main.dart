import 'package:flutter/material.dart';
import 'package:sogak/Screens/MainScreen.dart';
import 'package:sogak/Theme/MainTheme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: MainTheme().theme,
      home: const MainScreen(),
    );
  }
}
