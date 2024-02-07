import 'package:flutter/material.dart';
import 'package:sogak/Widgets/DetailScreenWidget.dart';
import 'package:sogak/Widgets/MoodTagWidget.dart';
import 'package:intl/intl.dart';

class DetailSubScreen extends StatefulWidget {
  DetailSubScreen({required this.inputData});

  var inputData;

  @override
  State<DetailSubScreen> createState() => _DetailSubScreenState();
}

class _DetailSubScreenState extends State<DetailSubScreen> {
  @override
  Widget build(BuildContext context) {
    String inputDate = widget.inputData['date'];
    int baseMoodState = widget.inputData['base_mood'];
    DateTime originalDate = DateTime.parse(inputDate);
    String formattedDateMonth =
        DateFormat('MMM').format(originalDate).toUpperCase();
    String formattedDateDate = DateFormat('d').format(originalDate);

    List<dynamic> detailMoodList = widget.inputData['detail_mood'];
    List<int> splitDigitsList = detailMoodList
        .expand((number) => number.toString().split('').map(int.parse))
        .toList();
    List<MoodTagWidget> moodTagWidgets = createMoodTagWidgets(splitDigitsList);
    return SafeArea(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Flexible(
          flex: 1,
          child: Row(
            children: [
              Flexible(
                  flex: 1,
                  child: DetailScreenWidget(
                    inputWidget: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                            child: Text(
                          formattedDateMonth,
                          style: Theme.of(context).textTheme.titleLarge,
                        )),
                        Container(
                            child: Text(formattedDateDate,
                                style: TextStyle(fontSize: 50.0)))
                      ],
                    ),
                    inputWidth: MediaQuery.of(context).size.width * 0.5,
                    inputHeight: 150.0,
                  )),
              Flexible(
                  flex: 2,
                  child: DetailScreenWidget(
                    inputWidget: Padding(
                      padding: EdgeInsets.all(5.0),
                      child: Wrap(children: moodTagWidgets),
                    ),
                    inputWidth: MediaQuery.of(context).size.width * 0.8,
                    inputHeight: 150.0,
                  )),
            ],
          ),
        ),
        Flexible(
          flex: 1,
          child: Row(
            children: [
              Flexible(
                flex: 1,
                child: NumberWidget(inputText: "40%", inputTitle: "스트레스"),
              ),
              Flexible(
                flex: 1,
                child: NumberWidget(inputText: "40%", inputTitle: "피로도"),
              ),
              Flexible(
                flex: 1,
                child: NumberWidget(inputText: "매우\n만족", inputTitle: "만족도"),
              ),
            ],
          ),
        ),
        Flexible(
          flex: 2,
          child: DetailScreenWidget(
            inputWidget: Text("data"),
            inputWidth: MediaQuery.of(context).size.width,
            inputHeight: 300.0,
          ),
        ),
        Flexible(
            flex: 1,
            child: GestureDetector(
                child: Padding(
              padding: EdgeInsets.all(10.0),
              child: Container(
                height: 60.0,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.0)),
                child: Center(
                  child: Text(
                    "수정하기",
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                ),
              ),
            )))
      ],
    ));
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

class NumberWidget extends StatelessWidget {
  NumberWidget({required this.inputTitle, required this.inputText});

  final String inputTitle;
  final String inputText;

  @override
  Widget build(BuildContext context) {
    return DetailScreenWidget(
      inputWidget: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(inputTitle),
          Text(
            inputText,
            style: TextStyle(fontSize: 35.0),
          ),
        ],
      ),
      inputWidth: MediaQuery.of(context).size.width * 0.3,
      inputHeight: 150.0,
    );
  }
}
