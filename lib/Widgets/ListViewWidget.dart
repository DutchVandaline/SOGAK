import 'package:flutter/material.dart';
import 'package:sogak/Screens/DetailScreen.dart';
import 'package:sogak/Widgets/MoodTagWidget.dart';
import 'package:intl/intl.dart';
import 'dart:convert';

class ListViewWidget extends StatefulWidget {
  const ListViewWidget({required this.inputData});

  final inputData;

  @override
  State<ListViewWidget> createState() => _ListViewWidgetState();
}

class _ListViewWidgetState extends State<ListViewWidget> {
  @override
  Widget build(BuildContext context) {
    String inputDate = widget.inputData['date'];
    int baseMoodState = widget.inputData['base_mood'];
    List<dynamic> detailMoodList = widget.inputData['detail_mood'];
    List<int> splitDigitsList = detailMoodList
        .expand((number) => number.toString().split('').map(int.parse))
        .toList();
    DateTime originalDate = DateTime.parse(inputDate);
    String formattedDateMonth =
        DateFormat('MMM').format(originalDate).toUpperCase();
    String formattedDateDate = DateFormat('d').format(originalDate);
    String decodedWhatHappened =
        utf8.decode(widget.inputData['what_happened'].codeUnits);

    return GestureDetector(
      onTap: () {
        widget.inputData['sogak_bool']
            ? print("sogaked")
            : Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => DetailScreen(
                          inputId: widget.inputData['id'],
                        )));
      },
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 10.0),
        child: Container(
            decoration: BoxDecoration(
              color: Color(0xFF292929),
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: Padding(
              padding: EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                    child: Container(
                      width: 5.0,
                      height: 50.0,
                      color: widget.inputData['sogak_bool']
                          ? Theme.of(context).cardColor
                          : baseMoodState <= 3
                              ? Colors.grey
                              : Colors.red,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: Container(
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          formattedDateMonth,
                          style: widget.inputData['sogak_bool']
                              ? TextStyle(fontSize: 15.0, color: Colors.grey)
                              : TextStyle(fontSize: 15.0),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          formattedDateDate,
                          style: widget.inputData['sogak_bool']
                              ? TextStyle(fontSize: 25.0, color: Colors.grey)
                              : TextStyle(fontSize: 25.0),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    )),
                  ),
                  Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: Container(
                          width: MediaQuery.of(context).size.width * 0.72,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              widget.inputData['sogak_bool']
                                  ? Text(
                                      "어떤 감정이든지 이제는 소각되었습니다.",
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(color: Colors.grey, fontSize: 16.0),
                                    )
                                  : widget.inputData['what_happened'] == null ||
                                          widget.inputData['what_happened'] == ""
                                      ? Text(
                                          "기록된 일이 없습니다.",
                                          maxLines: 3,
                                          overflow: TextOverflow.ellipsis,
                                          style: widget.inputData['sogak_bool']
                                              ? TextStyle(color: Colors.grey, fontSize: 16.0)
                                              : TextStyle(color: Colors.white, fontSize: 16.0),
                                        )
                                      : Text(
                                          decodedWhatHappened,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(color: Colors.white, fontSize: 16.0),
                                        ),
                              SizedBox(
                                height: 5.0,
                              ),
                              widget.inputData['sogak_bool']
                                  ? Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 2.0, vertical: 3.0),
                                      child: Container(
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Colors.grey),
                                              borderRadius:
                                                  BorderRadius.circular(7.0)),
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 10.0,
                                                vertical: 3.0),
                                            child: Text(
                                              "소각된 감정입니다",
                                              style:
                                                  TextStyle(color: Colors.grey, fontSize: 16.0),
                                            ),
                                          )),
                                    )
                                  : Wrap(
                                      spacing: 1.0,
                                      children: createMoodTagWidgets(
                                          splitDigitsList)),
                            ],
                          ))),
                ],
              ),
            )),
      ),
    );
  }
}

List<MoodTagWidget> createMoodTagWidgets(List<int> splitDigitsList) {
  List<MoodTagWidget> moodTagWidgets = [];
  for (int i = 0; i < splitDigitsList.length; i++) {
    moodTagWidgets.add(
      MoodTagWidget(inputmood: splitDigitsList[i], sogakBool: true,),
    );
  }

  return moodTagWidgets;
}
