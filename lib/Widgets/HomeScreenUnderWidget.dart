import 'package:flutter/material.dart';

class HomeScreenUnderWidget extends StatelessWidget {
  HomeScreenUnderWidget({this.inputQuestions, this.inputWidget});

  final inputQuestions;
  final inputWidget;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.3,
      decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.grey))),
      child: Padding(
        padding: EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(inputQuestions, style: TextStyle(fontWeight: FontWeight.bold),),
            inputWidget
          ],
        ),
      ),
    );
  }
}
