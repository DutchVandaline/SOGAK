import 'package:flutter/material.dart';
import 'package:sogak/Screens/DetailScreen.dart';
import 'package:sogak/Screens/SogakDetailScreen.dart';
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
            ? showSogakDialog(context)
            : Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => DetailScreen(
                          inputId: widget.inputData['id'],
                        ))).then((value) {
                setState(() {});
              });
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
                  Flexible(
                    flex: 1,
                    child: Padding(
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
                  ),
                  Flexible(
                    flex: 2,
                    child: Padding(
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
                  ),
                  Flexible(
                    flex: 10,
                    child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            widget.inputData['sogak_bool']
                                ? decodedAfterMemo == ""
                                    ? const Text(
                                        "어떤 감정이든지 소각되었습니다.",
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            color: Colors.grey, fontSize: 16.0),
                                      )
                                    : SizedBox(
                                        child: Text(
                                          decodedAfterMemo,
                                          maxLines: 3,
                                          style: const TextStyle(
                                              color: Colors.grey),
                                        ),
                                      )
                                : widget.inputData['what_happened'] == null ||
                                        widget.inputData['what_happened'] == ""
                                    ? SizedBox(
                                        child: Text(
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
                                        ),
                                      )
                                    : SizedBox(
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
                                ? const Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 2.0, vertical: 3.0),
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 10.0, vertical: 3.0),
                                      child: Text(
                                        "소각된 감정입니다",
                                        style: TextStyle(
                                            color: Colors.grey, fontSize: 16.0),
                                      ),
                                    ),
                                  )
                                : SizedBox(
                                    child: Wrap(
                                        spacing: 1.0,
                                        children: createMoodTagWidgets(
                                            splitDigitsList)),
                                  ),
                          ],
                        )),
                  ),
                ],
              ),
            )),
      ),
    );
  }

  void showSogakDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('소각된 감정'),
          content: const Text(
            '이미 소각된 감정입니다. 열람하시겠습니까?\n소각된 감정은 수정 및 삭제가 불가능합니다.',
            style: TextStyle(fontSize: 13.0),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                '취소',
                style: TextStyle(color: Colors.white),
              ),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context) => SogakDetailScreen(inputId: widget.inputData['id'])));
              },
              child: const Text(
                '확인',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
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
