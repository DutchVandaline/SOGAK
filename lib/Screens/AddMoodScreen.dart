import 'package:flutter/material.dart';

class AddMoodScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text(
            "Add Mood 😌",
          ),
          centerTitle: false,
          backgroundColor: Colors.transparent,
          leadingWidth: 40.0,
          elevation: 0.0,
          shadowColor: Colors.transparent,
        ),
        body: SafeArea(
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: ListView(
              children: [
                Container(
                  child: Placeholder(),
                ),
                Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: 60.0,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15.0)
                    ),
                    child: Center(
                      child: Text(
                        "Add Mood",
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
