import 'package:flutter/material.dart';
import 'package:sogak/Widgets/PaintWidget.dart';
import 'package:sogak/Widgets/MonthlyWidget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Icon(
            Icons.account_circle,
            color: Theme.of(context).primaryColorLight,
            size: 40.0,
          ),
        ),
        title: const Text(
          "Good Afternoon",
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
          child: PageView(
            scrollDirection: Axis.horizontal,
            children: [
              MonthlyWidget(),
              MonthlyWidget(),
            ],
          )),
    );
  }
}


