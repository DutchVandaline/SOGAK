import 'package:flutter/material.dart';
import 'package:sogak/Widgets/HomeScreenUnderWidget.dart';
import 'package:sogak/Widgets/MoodTagWidget.dart';
import 'package:sogak/Screens/AddMoodScreen.dart';
import 'package:sogak/Widgets/ChartWidget.dart';

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
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 8.0),
            child: IconButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => AddMoodScreen()));
                },
                icon: Icon(
                  Icons.add,
                  size: 30.0,
                )),
          )
        ],
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
                  color: Theme.of(context).cardColor,
                  child: Center(
                    child: ChartWidget(),
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
                            MoodTagWidget(
                              inputmood: 0,
                            ),
                            MoodTagWidget(
                              inputmood: 1,
                            ),
                            MoodTagWidget(
                              inputmood: 2,
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            MoodTagWidget(
                              inputmood: 3,
                            ),
                            MoodTagWidget(
                              inputmood: 4,
                            ),
                            MoodTagWidget(
                              inputmood: 5,
                            ),
                            MoodTagWidget(
                              inputmood: 6,
                            ),
                          ],
                        ),
                      ],
                    )),
              ),
            ],
          )),
    );
  }
}
