import 'package:flutter/material.dart';

class SogakScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff252527),
      appBar: AppBar(
        title: const Text(
          "Ready to Sogak? 🔥",
          style: TextStyle(fontSize: 25.0),
        ),
        backgroundColor: Color(0xff252527),
        centerTitle: false,
        leadingWidth: 40.0,
        elevation: 0.0,
        shadowColor: Colors.transparent,
      ),
      body: Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.34,
            decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.fitWidth,
                  alignment: FractionalOffset.topCenter,
                  image: AssetImage('assets/images/flame.gif'),
                )),
          )
        ],
      ),
    );
  }
}
