import 'package:flutter/material.dart';

class HomeScreenUnderWidget extends StatelessWidget {
  HomeScreenUnderWidget({this.inputQuestions, this.inputWidget, this.inputHeight});

  final inputQuestions;
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              inputQuestions,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            inputWidget
          ],
        ),
      ),
    ),);
  }
}
