import 'package:flutter/material.dart';
import 'package:sogak/Widgets/MoodTagWidget.dart';

class ListViewWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        print("pressed");
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
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                    child: Container(
                      width: 5.0,
                      height: 50.0,
                      color: Colors.amber,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: Container(
                      child: Text(
                        "2024\n01 21",
                        style: TextStyle(fontSize: 18.0),
                      ),
                    ),
                  ),
                  Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: Container(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("What Happened?"),
                              Row(
                                children: [
                                  MoodTagWidget(inputmood: 2),
                                  MoodTagWidget(inputmood: 1),
                                ],
                              )
                            ],
                          ))),
                ],
              ),
            )),
      ),
    );
  }
}
