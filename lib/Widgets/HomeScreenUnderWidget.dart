import 'package:flutter/material.dart';

class HomeScreenUnderWidget extends StatelessWidget {
  HomeScreenUnderWidget({this.inputWidget, this.inputHeight});

  final inputWidget;
  final inputHeight;

  @override
  Widget build(BuildContext context) {
    return Padding(padding: EdgeInsets.only(bottom: 13.0, left: 10.0, right: 10.0),
    child: Container(
      width: MediaQuery.of(context).size.width,
      height: inputHeight,
      decoration: BoxDecoration(
        color: Color(0xFF292929),
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Padding(
        padding: EdgeInsets.all(10.0),
        child: Center(
          child: inputWidget,
        )
        ),
      ),
    );
  }
}
