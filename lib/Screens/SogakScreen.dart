import 'package:flutter/material.dart';

class SogakScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Ready to Sogak? 🔥",
          style: TextStyle(fontSize: 25.0),
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
