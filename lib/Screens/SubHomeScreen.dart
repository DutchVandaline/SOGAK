import 'package:flutter/material.dart';
import 'package:sogak/Widgets/ChartWidget.dart';
import 'package:sogak/Widgets/MoodTagWidget.dart';
import 'package:sogak/Widgets/HomeScreenUnderWidget.dart';

class SubHomeScreen extends StatefulWidget {
  SubHomeScreen({required this.responseData});

  final responseData;

  @override
  State<SubHomeScreen> createState() => _SubHomeScreenState();
}

class _SubHomeScreenState extends State<SubHomeScreen> {
  @override
  Widget build(BuildContext context) {
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
                inputQuestions: "Last Happened",
                inputWidget: Text(widget.responseData['what_happened'].toString()),
              )),
          Flexible(
            flex: 1,
            child: HomeScreenUnderWidget(
                inputQuestions: "How are you feeling?",
                inputWidget: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.responseData['date'].toString()),
                    Row(
                      children: [
                        MoodTagWidget(
                          inputmood:
                              widget.responseData['detail_mood'][0].toInt(),
                        ),
                        MoodTagWidget(
                          inputmood:
                              widget.responseData['detail_mood'][0].toInt(),
                        ),
                        MoodTagWidget(
                          inputmood:
                              widget.responseData['detail_mood'][0].toInt(),
                        ),
                      ],
                    ),
                  ],
                )),
          ),
        ],
      ),
    );
  }
}
