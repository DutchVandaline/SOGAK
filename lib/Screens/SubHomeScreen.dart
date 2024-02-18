import 'package:flutter/material.dart';
import 'package:sogak/Widgets/ChartWidget.dart';
import 'package:sogak/Widgets/MoodTagWidget.dart';
import 'package:sogak/Widgets/HomeScreenUnderWidget.dart';
import 'dart:convert';

class SubHomeScreen extends StatefulWidget {
  const SubHomeScreen({required this.responseData});

  final responseData;

  @override
  State<SubHomeScreen> createState() => _SubHomeScreenState();
}

class _SubHomeScreenState extends State<SubHomeScreen> {
  @override
  Widget build(BuildContext context) {
    List<dynamic> detailMoodList = widget.responseData['detail_mood'];
    bool sogakState = widget.responseData['sogak_bool'];
    List splitDigitsList =
        detailMoodList.expand((character) => character.split('')).toList();
    String decodedWhatHappened =
        utf8.decode(widget.responseData['what_happened'].codeUnits);
    String decodedAfterMemo =
        utf8.decode(widget.responseData['after_memo'].codeUnits);

    return SizedBox(
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
                  inputWidget: sogakState
                      ? decodedAfterMemo == ""
                          ? const Text("어떤 감정이든지 이제는 소각되었습니다.")
                          : Text(
                            decodedAfterMemo,
                            textAlign: TextAlign.center,
                            maxLines: 3,
                          )
                      : decodedWhatHappened == ""
                          ? const Text("입력된 일이 없습니다.")
                          : Text(
                              decodedWhatHappened,
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ))),
          Flexible(
            flex: 1,
            child: HomeScreenUnderWidget(
                inputHeight: MediaQuery.of(context).size.width * 0.3,
                inputWidget: sogakState
                    ? Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 2.0, vertical: 3.0),
                        child: Container(
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.white),
                                borderRadius: BorderRadius.circular(10.0)),
                            child: const Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10.0, vertical: 3.0),
                              child: Text(
                                "소각된 감정입니다",
                                style: TextStyle(color: Colors.white),
                              ),
                            )),
                      )
                    : ListView(children: [
                        const SizedBox(
                          height: 10.0,
                        ),
                        Center(
                          child: Wrap(
                              alignment: WrapAlignment.center,
                              spacing: 1.0,
                              children: createMoodTagWidgets(splitDigitsList)),
                        ),
                      ])),
          ),
        ],
      ),
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
