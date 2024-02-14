import 'package:flutter/material.dart';
import 'package:sogak/Widgets/SettingScreenWidget.dart';
import 'package:sogak/Screens/ProfileScreen.dart';
import 'package:sogak/Screens/DeveloperScreen.dart';

class SettingScreen extends StatefulWidget {
  @override
  State<SettingScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<SettingScreen> {
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
          Container(
            width: 80.0,
            height: 80.0,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white),
              image: DecorationImage(
                image: AssetImage('assets/images/sogak.png'),
              ),
            ),
          ),
          SizedBox(
            height: 30.0,
          ),
          SettingScreenWidget(
              inputIcon: Icon(Icons.account_circle),
              inputText: "프로필",
              inputScreen: ProfileScreen()),
          SettingScreenWidget(
              inputIcon: Icon(Icons.gamepad_outlined),
              inputText: "개발자 소개",
              inputScreen: DeveloperScreen()),
        ],
      ),
    );
  }
}
