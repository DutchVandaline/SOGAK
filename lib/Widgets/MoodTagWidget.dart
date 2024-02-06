import 'package:flutter/material.dart';

class MoodTagWidget extends StatelessWidget {
  MoodTagWidget({this.inputmood});

  final inputmood;

  @override
  Widget build(BuildContext context) {
    String moodTag = "";
    if (inputmood == 0){
      moodTag = "행복한";
    } else if (inputmood == 1){
      moodTag = "흥분되는";
    } else if (inputmood == 2){
      moodTag = "사랑스러운";
    } else if (inputmood == 3){
      moodTag = "슬픈";
    } else if (inputmood == 4){
      moodTag = "분노하는";
    } else if (inputmood == 5){
      moodTag = "공포스러운";
    } else if (inputmood == 6){
      moodTag = "혐오감이 드는";
    }

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 2.0, vertical: 3.0),
      child: Container(
          decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(3.0)),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 5.0),
            child: Text(moodTag),
          )),
    );
  }
}
