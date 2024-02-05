import 'package:flutter/material.dart';

//TODO: add something in sogak screen

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
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.34,
            decoration: BoxDecoration(
                image: DecorationImage(
              fit: BoxFit.fitWidth,
              alignment: FractionalOffset.bottomCenter,
              image: AssetImage('assets/images/flame.gif'),
            )),
          ),
          SizedBox(
            height: 20.0,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.12,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Text("data",style: Theme.of(context).textTheme.bodySmall,),
            ),
          )
        ],
      ),
    );
  }
}
