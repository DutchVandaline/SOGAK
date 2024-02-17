import 'package:flutter/material.dart';

class DetailScreenWidget extends StatelessWidget {
  const DetailScreenWidget({Key? key, required this.inputWidget, required this.inputWidth, required this.inputHeight}) : super(key: key);

  final Widget inputWidget;
  final double inputWidth;
  final double inputHeight;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
      child: Container(
          height: inputHeight,
          width: inputWidth,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.0),
              color: const Color(0xFF292929)),
          child: Center(
            child: inputWidget,
          )),
    );
  }
}
