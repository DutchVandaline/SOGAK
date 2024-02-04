import 'package:flutter/material.dart';
import 'package:sogak/Screens/MainScreen.dart';
import 'package:sogak/Screens/LoginScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sogak/Theme/MainTheme.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    checkLoginStatus();
  }

  void checkLoginStatus() async {
    await Future.delayed(Duration(seconds: 1));
    String? userToken = await getUserToken();

    if (userToken != null && userToken.isNotEmpty) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MainScreen()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    }
  }

  Future<String?> getUserToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('UserToken');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            //Icon(Icons.local_fire_department_outlined, color: Colors.white, size: 45.0,),
            Text("🔥", style: TextStyle(fontSize: 50.0)),
            SizedBox(height: 5.0,),
            Text(" 소각로 확인 중 ", style: Theme.of(context).textTheme.bodyMedium,)
          ],
        ),
      )
    );
  }
}
