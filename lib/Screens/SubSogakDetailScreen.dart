import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:sogak/Widgets/MoodTagWidget.dart';
import 'package:sogak/Widgets/DetailScreenWidget.dart';
import 'package:intl/intl.dart';

class SubSogakDetailScreen extends StatefulWidget {
  SubSogakDetailScreen({Key? key, required this.inputData}) : super(key: key);
  var inputData;

  @override
  State<SubSogakDetailScreen> createState() => _SubSogakDetailScreenState();
}

class _SubSogakDetailScreenState extends State<SubSogakDetailScreen> {
  double _opacity = 1.0;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 1), () {
      setState(() {
        _opacity = 0.0;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    String inputDate = widget.inputData['date'];
    int baseMoodState = widget.inputData['base_mood'];
    int stressRate = widget.inputData['stress_rate'];
    int tiredRate = widget.inputData['tired_rate'];
    List<dynamic> detailMoodList = widget.inputData['detail_mood'];
    String decodedWhatHappened =
    utf8.decode(widget.inputData['what_happened'].codeUnits);
    String decodedAfterMemo =
    utf8.decode(widget.inputData['after_memo'].codeUnits);
    List splitDigitsList =
        detailMoodList.expand((character) => character.split('')).toList();
    List<MoodTagWidget> moodTagWidgets = createMoodTagWidgets(splitDigitsList);

    DateTime originalDate = DateTime.parse(inputDate);
    String formattedDateMonth =
        DateFormat('MMM').format(originalDate).toUpperCase();
    String formattedDateDate = DateFormat('d').format(originalDate);

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Row(
          children: [
            Flexible(
                flex: 1,
                child: DetailScreenWidget(
                  inputWidget: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      AnimatedOpacity(
                        opacity: _opacity,
                        duration: const Duration(seconds: 9),
                        child: Text(
                          formattedDateMonth,
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge
                        ),
                      ),
                      AnimatedOpacity(
                        opacity: _opacity,
                        duration: const Duration(seconds: 9),
                        child: Text(formattedDateDate,
                            style: const TextStyle(
                                fontSize: 50.0)),
                      )
                    ],
                  ),
                  inputWidth: MediaQuery.of(context).size.width * 0.5,
                  inputHeight: 150.0,
                )),
            Flexible(
                flex: 2,
                child: DetailScreenWidget(
                  inputWidget: ListView(children: [
                    const SizedBox(height: 20.0),
                    AnimatedOpacity(
                      opacity: _opacity,
                      duration: const Duration(seconds: 9),
                      child: Center(
                          child: Wrap(
                        children: moodTagWidgets,
                        alignment: WrapAlignment.center,
                      )),
                    ),
                  ]),
                  inputWidth: MediaQuery.of(context).size.width * 0.8,
                  inputHeight: 150.0,
                )),
          ],
        ),
        Row(
          children: [
            Flexible(
              flex: 1,
              child: NumberWidget(
                inputText: "${stressRate}0%",
                inputTitle: "🤯스트레스",
                inputOpacity: _opacity,
              ),
            ),
            Flexible(
              flex: 1,
              child: NumberWidget(
                  inputText: "${tiredRate}0%",
                  inputTitle: "🥱피로도",
                  inputOpacity: _opacity),
            ),
            Flexible(
              flex: 1,
              child: NumberWidget(
                  inputText: BasedOnBaseMood(baseMoodState),
                  inputTitle: "😃만족도",
                  inputOpacity: _opacity),
            ),
          ],
        ),
        DetailScreenWidget(
          inputWidth: MediaQuery.of(context).size.width,
          inputHeight: MediaQuery.of(context).size.height * 0.2,
          inputWidget: Padding(
            padding: const EdgeInsets.all(5.0),
            child: AnimatedOpacity(
              opacity: _opacity,
              duration: const Duration(seconds: 9),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 10.0),
                    child: Text(
                      "무슨 일이 있었나요?",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.14,
                    child: ListView(
                      children: [
                        Text(
                          decodedWhatHappened,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        DetailScreenWidget(
          inputWidth: MediaQuery.of(context).size.width,
          inputHeight: MediaQuery.of(context).size.height * 0.2,
          inputWidget: Padding(
            padding: const EdgeInsets.all(5.0),
            child: AnimatedOpacity(
              opacity: _opacity,
              duration: const Duration(seconds: 9),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.only(top: 10.0),
                      child: Text(
                        "소각 이후는 어떠신가요?",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    child: Text(decodedAfterMemo,
                        textAlign: TextAlign.start),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

List<MoodTagWidget> createMoodTagWidgets(List splitDigitsList) {
  List<MoodTagWidget> moodTagWidgets = [];
  for (int i = 0; i < splitDigitsList.length; i++) {
    moodTagWidgets.add(
      MoodTagWidget(
        inputmood: splitDigitsList[i],
        sogakBool: true,
      ),
    );
  }

  return moodTagWidgets;
}

class NumberWidget extends StatefulWidget {
  const NumberWidget(
      {Key? key,
      required this.inputTitle,
      required this.inputText,
      required this.inputOpacity})
      : super(key: key);

  final String inputTitle;
  final String inputText;
  final double inputOpacity;

  @override
  State<NumberWidget> createState() => _NumberWidgetState();
}

class _NumberWidgetState extends State<NumberWidget> {
  @override
  Widget build(BuildContext context) {
    return DetailScreenWidget(
      inputWidget: AnimatedOpacity(
        opacity: widget.inputOpacity,
        duration: const Duration(seconds: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              widget.inputTitle,
              textAlign: TextAlign.center,
            ),
            Text(
              widget.inputText,
              style: const TextStyle(fontSize: 25.0, ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
      inputWidth: MediaQuery.of(context).size.width * 0.3,
      inputHeight: 150.0,
    );
  }
}

String BasedOnBaseMood(int inputBaseMood) {
  String outputTag = "";
  if (inputBaseMood == 1) {
    return outputTag = "매우\n불만족";
  } else if (inputBaseMood == 2) {
    return outputTag = "불만족";
  } else if (inputBaseMood == 3) {
    return outputTag = "보통";
  } else if (inputBaseMood == 4) {
    return outputTag = "만족";
  } else if (inputBaseMood == 5) {
    return outputTag = "매우 만족";
  }
  return outputTag = "";
}
