import 'dart:math';
import 'package:flutter/material.dart';

class MoodWidget extends StatelessWidget {
  MoodWidget({this.inputColor});
  var inputColor;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      child: CircleAvatar(
        backgroundColor: inputColor,
        radius: 20.0,
      ),
      left: Random().nextInt((MediaQuery.of(context).size.width * 0.8).toInt()).toDouble(),
      top: Random().nextInt((MediaQuery.of(context).size.height * 0.3).toInt()).toDouble(),
    );
  }
}