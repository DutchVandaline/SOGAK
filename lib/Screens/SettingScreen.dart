import 'package:flutter/material.dart';
import 'package:sogak/Widgets/SettingScreenWidget.dart';
import 'package:sogak/Screens/ProfileScreen.dart';
import 'package:sogak/Screens/DeveloperScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sogak/Screens/SplashScreen.dart';
import 'package:http/http.dart' as http;

class SettingScreen extends StatefulWidget {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  State<SettingScreen> createState() => _ProfileScreenState();
}

Future<void> logout() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? _userToken = prefs.getString('UserToken');
  if (_userToken != null) {
    var url = Uri.https('sogak-api-nraiv.run.goorm.site', '/api/user/logout/');
    var response = await http.post(
      url,
      headers: {'Authorization': 'Token $_userToken'},
    );
    if (response.statusCode == 200) {
      prefs.remove('UserToken');
    } else {
      throw Exception('Error: ${response.statusCode}, ${response.body}');
    }
  }
}

class _ProfileScreenState extends State<SettingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
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
              image: const DecorationImage(
                image: AssetImage('assets/images/sogak.png'),
              ),
            ),
          ),
          const SizedBox(
            height: 30.0,
          ),
          const SettingScreenWidget(
              inputIcon: Icon(Icons.account_circle),
              inputText: "프로필",
              inputScreen: ProfileScreen()),
          GestureDetector(
            onTap: () {
              showLogoutDialog(context);
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
              child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 50.0,
                  decoration: BoxDecoration(
                      color: const Color(0xFF292929),
                      borderRadius: BorderRadius.circular(15.0)),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 20.0),
                            child: Icon(Icons.logout),
                          ),
                          SizedBox(width: 20.0),
                          Text("로그아웃"),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(right: 20.0),
                        child: Icon(Icons.arrow_forward_ios),
                      ),
                    ],
                  )),
            ),
          ),
          const SettingScreenWidget(
              inputIcon: Icon(Icons.gamepad_outlined),
              inputText: "개발자 소개",
              inputScreen: DeveloperScreen()),
        ],
      ),
    );
  }
  void showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('로그아웃'),
          content: const Text('정말로 로그아웃 하시겠습니까?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('취소',  style: TextStyle(color: Colors.white),),
            ),
            TextButton(
              onPressed: () async {
                await logout();
                Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const SplashScreen()), (route) => false);
              },
              child: const Text('로그아웃', style: TextStyle(color: Colors.white),),
            ),
          ],
        );
      },
    );
  }

}
