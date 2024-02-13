import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "마이페이지",
          style: TextStyle(fontSize: 25.0),
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        automaticallyImplyLeading: false,
        centerTitle: false,
        leadingWidth: 40.0,
        elevation: 0.0,
        shadowColor: Colors.transparent,
      ),
      body: Column(
        children: [
          GestureDetector(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 80.0,
                decoration: BoxDecoration(
                    color: Color(0xFF292929),
                    borderRadius: BorderRadius.circular(15.0)),
                child: Center(
                  child: Text("프로필"),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
