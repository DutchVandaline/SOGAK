import 'package:flutter/material.dart';
import 'dart:ui';

//TODO: add something in sogak screen

bool sogakState = false;

class SogakScreen extends StatefulWidget {
  @override
  State<SogakScreen> createState() => _SogakScreenState();
}

class _SogakScreenState extends State<SogakScreen> {
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
        body: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onLongPress: () {
                    setState(() {
                      sogakState = true;
                    });
                  },
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.34,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                      fit: BoxFit.fitWidth,
                      alignment: FractionalOffset.bottomCenter,
                      image: AssetImage('assets/images/flame.gif'),
                    )),
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
                  child: Container(
                      height: MediaQuery.of(context).size.height * 0.12,
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "소각 消却",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 30.0,
                            ),
                          ),
                          SizedBox(
                            height: 5.0,
                          ),
                          Text(
                            "당신의 마음 속, 불편했던 감정을 소각하세요.\n소각하려면 화염을 길게 누르세요.",
                            style: Theme.of(context).textTheme.bodyMedium,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      )),
                )
              ],
            ),
            sogakState
                ? ClipRect(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 8.0, sigmaY: 8.0),
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                                onPressed: () {
                                  setState(() {
                                    sogakState = false;
                                  });
                                },
                                icon: Icon(Icons.close, size: 40.0)),
                            SizedBox(height: 30.0,),
                          ],
                        ),
                      ),
                    ),
                  )
                : SizedBox.shrink(),
          ],
        ));
  }
}
