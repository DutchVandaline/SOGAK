import 'package:flutter/material.dart';

class MoodTagWidget extends StatefulWidget {
  const MoodTagWidget({Key? key, this.inputmood, this.sogakBool})
      : super(key: key);

  final inputmood;
  final sogakBool;

  @override
  State<MoodTagWidget> createState() => _MoodTagWidgetState();
}

class _MoodTagWidgetState extends State<MoodTagWidget>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    String moodTag = "";
    if (widget.inputmood == 'a') {
      moodTag = "언짢은";
    } else if (widget.inputmood == 'b') {
      moodTag = "짜증나는";
    } else if (widget.inputmood == 'c') {
      moodTag = "화난";
    } else if (widget.inputmood == 'd') {
      moodTag = "격분한";
    } else if (widget.inputmood == 'e') {
      moodTag = "불안한";
    } else if (widget.inputmood == 'f') {
      moodTag = "초조한";
    } else if (widget.inputmood == 'g') {
      moodTag = "불쾌한";
    } else if (widget.inputmood == 'h') {
      moodTag = "두려운";
    } else if (widget.inputmood == 'i') {
      moodTag = "슬픈";
    } else if (widget.inputmood == 'j') {
      moodTag = "공허한";
    } else if (widget.inputmood == 'k') {
      moodTag = "우울한";
    } else if (widget.inputmood == 'l') {
      moodTag = "절망스러운";
    } else if (widget.inputmood == 'm') {
      moodTag = "역겨운";
    } else if (widget.inputmood == 'n') {
      moodTag = "진이 빠진";
    } else if (widget.inputmood == 'o') {
      moodTag = "시무룩한";
    } else if (widget.inputmood == 'p') {
      moodTag = "의욕 없는";
    } else if (widget.inputmood == 'q') {
      moodTag = "답답한";
    } else if (widget.inputmood == 'r') {
      moodTag = "집중하는";
    } else if (widget.inputmood == 's') {
      moodTag = "흥분한";
    } else if (widget.inputmood == 't') {
      moodTag = "황홀한";
    } else if (widget.inputmood == 'u') {
      moodTag = "흥겨운";
    } else if (widget.inputmood == 'v') {
      moodTag = "기쁜";
    } else if (widget.inputmood == 'w') {
      moodTag = "놀란";
    } else if (widget.inputmood == 'x') {
      moodTag = "희망찬";
    } else if (widget.inputmood == 'y') {
      moodTag = "유쾌한";
    } else if (widget.inputmood == 'z') {
      moodTag = "평온한";
    } else if (widget.inputmood == '1') {
      moodTag = "무난한";
    } else if (widget.inputmood == '2') {
      moodTag = "편안한";
    } else if (widget.inputmood == '3') {
      moodTag = "충만한";
    } else if (widget.inputmood == '4') {
      moodTag = "나른한";
    } else if (widget.inputmood == '5') {
      moodTag = "여유로운";
    } else if (widget.inputmood == '6') {
      moodTag = "안정적인";
    } else if (widget.inputmood == '7') {
      moodTag = "고요한";
    } else if (widget.inputmood == '8') {
      moodTag = "태평한";
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
              padding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 3.0),
              child: Text(
                moodTag,
                style: const TextStyle(fontSize: 16.0),
              ),
            )),
      ),
    );
  }
}
