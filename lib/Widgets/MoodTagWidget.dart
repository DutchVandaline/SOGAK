import 'package:flutter/material.dart';

class MoodTagWidget extends StatefulWidget {
  MoodTagWidget({this.inputmood, this.sogakBool});

  final inputmood;
  final sogakBool;

  @override
  State<MoodTagWidget> createState() => _MoodTagWidgetState();
}

class _MoodTagWidgetState extends State<MoodTagWidget> with SingleTickerProviderStateMixin{
  @override
  Widget build(BuildContext context) {
    String moodTag = "";
    if (widget.inputmood == 1){
      moodTag = "행복한";
    } else if (widget.inputmood == 2){
      moodTag = "흥분되는";
    } else if (widget.inputmood == 3){
      moodTag = "사랑스러운";
    } else if (widget.inputmood == 4){
      moodTag = "슬픈";
    } else if (widget.inputmood == 5){
      moodTag = "분노하는";
    } else if (widget.inputmood == 6){
      moodTag = "공포스러운";
    } else if (widget.inputmood == 7){
      moodTag = "혐오감이 드는";
    }
    return AnimatedOpacity(
      opacity: widget.sogakBool ? 1.0 : 0.0,
      duration: const Duration(seconds: 2),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 2.0, vertical: 3.0),
        child: Container(
            decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(7.0)),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 3.0),
              child: Text(moodTag),
            )),
      ),
    );

  }
}
