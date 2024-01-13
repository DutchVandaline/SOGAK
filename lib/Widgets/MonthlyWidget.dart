import 'package:flutter/material.dart';
import 'PaintWidget.dart';

class MonthlyWidget extends StatefulWidget {
  @override
  State<MonthlyWidget> createState() => _MonthlyWidgetState();
}

class _MonthlyWidgetState extends State<MonthlyWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: EdgeInsets.all(8.0),
          child: Container(
            width: MediaQuery.of(context).size.width * 0.9,
            height: MediaQuery.of(context).size.height * 0.08,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: Theme.of(context).canvasColor,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    "January 2024",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.0),
                    child: IconButton(
                        onPressed: () {}, icon: Icon(Icons.format_paint)))
              ],
            ),
          ),
        ),
        Flexible(
          flex: 2,
          child: PaintWidget(),
        ),
        Flexible(
          flex: 1,
          child: Padding(
            padding: EdgeInsets.only(top: 8.0, bottom: 16.0),
            child: Container(
              width: MediaQuery.of(context).size.width * 0.9,
              height: MediaQuery.of(context).size.height * 0.2,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: Theme.of(context).canvasColor,
              ),
            ),
          ),
        )
      ],
    );
  }
}
