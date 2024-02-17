import 'package:flutter/material.dart';

class MoodTagWidget extends StatefulWidget {
  const MoodTagWidget({Key? key, this.inputmood, this.sogakBool}) : super(key: key);

  final inputmood;
  final sogakBool;

  @override
  State<MoodTagWidget> createState() => _MoodTagWidgetState();
}

class _MoodTagWidgetState extends State<MoodTagWidget> with SingleTickerProviderStateMixin{
  @override
  Widget build(BuildContext context) {
    String moodTag = "";
    if (widget.inputmood == 'a'){
      moodTag = "행복한";
    } else if (widget.inputmood == 'b'){
      moodTag = "흥분되는";
    } else if (widget.inputmood == 'c'){
      moodTag = "사랑스러운";
    } else if (widget.inputmood == 'd'){
      moodTag = "슬픈";
    } else if (widget.inputmood == 'e'){
      moodTag = "분노하는";
    } else if (widget.inputmood == 'f'){
      moodTag = "공포스러운";
    } else if (widget.inputmood == 'g'){
      moodTag = "혐오스러운";
    } else if (widget.inputmood == 'h'){
      moodTag = "공허한";
    } else if (widget.inputmood == 'i'){
      moodTag = "우울한";
    } else if (widget.inputmood == 'j'){
      moodTag = "감격스러운";
    } else if (widget.inputmood == 'k'){
      moodTag = "아픈";
    } else if (widget.inputmood == 'l'){
      moodTag = "답답한";
    } else if (widget.inputmood == 'm'){
      moodTag = "귀찮은";
    }
    return AnimatedOpacity(
      opacity: widget.sogakBool ? 1.0 : 0.0,
      duration: const Duration(seconds: 2),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2.0, vertical: 3.0),
        child: Container(
            decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(7.0)),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 3.0),
              child: Text(moodTag,style: const TextStyle(fontSize: 16.0),),
            )),
      ),
    );

  }
}
