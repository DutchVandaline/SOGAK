import 'package:flutter/material.dart';
import 'package:sogak/Widgets/HomeScreenUnderWidget.dart';
import 'package:sogak/Widgets/MoodTagWidget.dart';
import 'package:sogak/Screens/AddMoodScreen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Good Afternoon 👋",
          style: TextStyle(fontSize: 25.0),
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        centerTitle: false,
        leadingWidth: 40.0,
        elevation: 0.0,
        shadowColor: Colors.transparent,
      ),
      body: Container(
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
                  decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      border: Border(bottom: BorderSide(color: Colors.grey))),
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Center(
                      child: Text("Graph goes Here"),
                    ),
                  ),
                ),
              ),
              Flexible(
                  flex: 1,
                  child: HomeScreenUnderWidget(
                    inputQuestions: "Last Happened Event",
                    inputWidget: Text('Memo will go inside'),
                  )),
              Flexible(
                flex: 1,
                child: HomeScreenUnderWidget(
                    inputQuestions: "How are you feeling?",
                    inputWidget: Column(
                      children: [
                        Row(
                          children: [
                            MoodTagWidget(inputmood: 0,),
                            MoodTagWidget(inputmood: 1,),
                            MoodTagWidget(inputmood: 2,),
                          ],
                        ),
                        Row(
                          children: [
                            MoodTagWidget(inputmood: 3,),
                            MoodTagWidget(inputmood: 4,),
                            MoodTagWidget(inputmood: 5,),
                            MoodTagWidget(inputmood: 6,),
                          ],
                        ),
                      ],
                    )),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => AddMoodScreen()));
                },
                child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: 60.0,
                    color: Colors.white,
                    child: Center(
                      child: Text("Add Mood",
                          style: Theme.of(context).textTheme.bodySmall),
                    )),
              ),
            ],
          )),
    );
  }
}
