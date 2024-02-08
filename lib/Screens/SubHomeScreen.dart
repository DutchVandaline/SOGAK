import 'package:flutter/material.dart';
import 'package:sogak/Widgets/ChartWidget.dart';
import 'package:sogak/Widgets/MoodTagWidget.dart';
import 'package:sogak/Widgets/HomeScreenUnderWidget.dart';
import 'dart:convert';

class SubHomeScreen extends StatefulWidget {
  SubHomeScreen({required this.responseData});

  final responseData;

  @override
  State<SubHomeScreen> createState() => _SubHomeScreenState();
}

class _SubHomeScreenState extends State<SubHomeScreen> {
  @override
  Widget build(BuildContext context) {
    List<dynamic> detailMoodList = widget.responseData['detail_mood'];
    bool sogakState = widget.responseData['sogak_bool'];
    List<int> splitDigitsList = detailMoodList
        .expand((number) => number.toString().split('').map(int.parse))
        .toList();
    List<MoodTagWidget> moodTagWidgets = createMoodTagWidgets(splitDigitsList);
    String decodedWhatHappened =
        utf8.decode(widget.responseData['what_happened'].codeUnits);

    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            flex: 3,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.5,
              width: MediaQuery.of(context).size.width,
              color: Theme.of(context).cardColor,
              child: Center(
                child: ChartWidget(),
              ),
            ),
          ),
          Flexible(
              flex: 1,
              child: HomeScreenUnderWidget(
                  inputQuestions: "최근에 무슨 일이 있었나요?",
                  inputWidget: sogakState
                      ? Text("이미 소각된 일입니다.")
                      : decodedWhatHappened == ""
                          ? Text("입력된 일이 없습니다.")
                          : Text(decodedWhatHappened))),
          Flexible(
            flex: 1,
            child: HomeScreenUnderWidget(
              inputHeight: MediaQuery.of(context).size.width * 0.3,
              inputQuestions: "그때, 어떤 감정을 느끼셨나요?",
              inputWidget: sogakState
                  ? Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 2.0, vertical: 3.0),
                      child: Container(
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.white),
                              borderRadius: BorderRadius.circular(3.0)),
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 5.0),
                            child: Text(
                              "소각된 감정입니다",
                              style: TextStyle(color: Colors.white),
                            ),
                          )),
                    )
                  : Wrap(
                      spacing: 1.0,
                      children: createMoodTagWidgets(splitDigitsList)),
            ),
          ),
        ],
      ),
    );
  }
}

List<MoodTagWidget> createMoodTagWidgets(List<int> splitDigitsList) {
  List<MoodTagWidget> moodTagWidgets = [];
  for (int i = 0; i < splitDigitsList.length; i++) {
    moodTagWidgets.add(
      MoodTagWidget(inputmood: splitDigitsList[i]),
    );
  }

  return moodTagWidgets;
}
