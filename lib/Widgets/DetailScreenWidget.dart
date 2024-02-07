import 'package:flutter/material.dart';

class DetailScreenWidget extends StatelessWidget {
  DetailScreenWidget({required this.inputWidget, required this.inputWidth, required this.inputHeight});

  final Widget inputWidget;
  final double inputWidth;
  final double inputHeight;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
      child: Container(
          height: inputHeight,
          width: inputWidth,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.0),
              color: Colors.black45),
          child: Center(
            child: inputWidget,
          )),
    );
  }
}
