import 'package:flutter/material.dart';
import 'package:sogak/Widgets/ListViewWidget.dart';

class ListScreen extends StatelessWidget {
  const ListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Daily Moods 👏",
          style: TextStyle(fontSize: 25.0),
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        centerTitle: false,
        leadingWidth: 40.0,
        elevation: 0.0,
        shadowColor: Colors.transparent,
      ),
      body: ListView(
        children: [
          ListViewWidget(),
        ],
      ),
    );
  }
}



