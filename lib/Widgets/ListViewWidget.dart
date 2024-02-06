import 'package:flutter/material.dart';
import 'package:sogak/Screens/DetailScreen.dart';
import 'package:sogak/Widgets/MoodTagWidget.dart';
import 'package:intl/intl.dart';

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
    DateTime originalDate = DateTime.parse(inputDate);
    String formattedDateMonth =
        DateFormat('MMM').format(originalDate).toUpperCase();
    String formattedDateDate = DateFormat('d').format(originalDate);

    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => DetailScreen(
                      inputId: widget.inputData['id'],
                    )));
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        child: Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 20.0),
            child: Container(
              decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: Colors.grey))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                    child: Container(
                      width: 5.0,
                      height: 50.0,
                      color: baseMoodState <= 3 ? Colors.red : Colors.grey,
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
                          style: TextStyle(fontSize: 15.0),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          formattedDateDate,
                          style: TextStyle(fontSize: 25.0),
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
                              widget.inputData['what_happened'] == null ||
                                      widget.inputData['what_happened'] == ""
                                  ? Text(
                                      "기록된 일이 없습니다.",
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                    )
                                  : Text(widget.inputData['what_happened']),
                              SizedBox(height: 5.0,),
                              Row(
                                children: [
                                  MoodTagWidget(inputmood: 2),
                                  MoodTagWidget(inputmood: 2),
                                  MoodTagWidget(inputmood: 2),
                                ],
                              ),
                            ],
                          ))),
                ],
              ),
            )),
      ),
    );
  }
}
