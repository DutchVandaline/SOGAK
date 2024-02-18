import 'package:flutter/material.dart';
import 'package:sogak/Screens/DetailScreen.dart';
import 'package:sogak/Widgets/MoodTagWidget.dart';
import 'package:intl/intl.dart';
import 'dart:convert';

class ListViewWidget extends StatefulWidget {
  const ListViewWidget({Key? key, required this.inputData}) : super(key: key);

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
    List splitDigitsList =
        detailMoodList.expand((character) => character.split('')).toList();
    DateTime originalDate = DateTime.parse(inputDate);
    String formattedDateMonth =
        DateFormat('MMM').format(originalDate).toUpperCase();
    String formattedDateDate = DateFormat('d').format(originalDate);
    String decodedWhatHappened =
        utf8.decode(widget.inputData['what_happened'].codeUnits);
    String decodedAfterMemo =
        utf8.decode(widget.inputData['after_memo'].codeUnits);

    return GestureDetector(
      onTap: () {
        widget.inputData['sogak_bool']
            ? {}
            : Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => DetailScreen(
                          inputId: widget.inputData['id'],
                        )));
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 10.0),
        child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFF292929),
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
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
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          formattedDateMonth,
                          style: widget.inputData['sogak_bool']
                              ? const TextStyle(
                                  fontSize: 15.0, color: Colors.grey)
                              : const TextStyle(fontSize: 15.0),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          formattedDateDate,
                          style: widget.inputData['sogak_bool']
                              ? const TextStyle(
                                  fontSize: 25.0, color: Colors.grey)
                              : const TextStyle(fontSize: 25.0),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          widget.inputData['sogak_bool']
                              ? decodedAfterMemo == ""
                                  ? const Text(
                                      "어떤 감정이든지 이제는 소각되었습니다.",
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          color: Colors.grey, fontSize: 16.0),
                                    )
                                  : Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.72,
                                      child: Text(
                                        decodedAfterMemo,
                                        maxLines: 3,
                                        style:
                                            const TextStyle(color: Colors.grey),
                                      ),
                                    )
                              : widget.inputData['what_happened'] == null ||
                                      widget.inputData['what_happened'] == ""
                                  ? Text(
                                      "기록된 일이 없습니다.",
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                      style: widget.inputData['sogak_bool']
                                          ? const TextStyle(
                                              color: Colors.grey,
                                              fontSize: 16.0)
                                          : const TextStyle(
                                              color: Colors.white,
                                              fontSize: 16.0),
                                    )
                                  : SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.74,
                                      child: Text(
                                        decodedWhatHappened,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 16.0),
                                      ),
                                    ),
                          const SizedBox(
                            height: 5.0,
                          ),
                          widget.inputData['sogak_bool']
                              ? Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 2.0, vertical: 3.0),
                                  child: Container(
                                      decoration: BoxDecoration(
                                          border:
                                              Border.all(color: Colors.grey),
                                          borderRadius:
                                              BorderRadius.circular(7.0)),
                                      child: const Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10.0, vertical: 3.0),
                                        child: Text(
                                          "소각된 감정입니다",
                                          style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 16.0),
                                        ),
                                      )),
                                )
                              : SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.75,
                                  child: Wrap(
                                      spacing: 1.0,
                                      children: createMoodTagWidgets(
                                          splitDigitsList)),
                                ),
                        ],
                      )),
                ],
              ),
            )),
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
