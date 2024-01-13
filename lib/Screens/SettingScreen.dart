import 'package:flutter/material.dart';

class SettingScreen extends StatelessWidget {
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
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        centerTitle: false,
        leadingWidth: 40.0,
        elevation: 0.0,
        shadowColor: Colors.transparent,
      ),
      body: const Placeholder(),
    );
  }
}
