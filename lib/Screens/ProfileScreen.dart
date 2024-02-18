import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sogak/Screens/SplashScreen.dart';
import 'dart:convert';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  Future<Map<String, dynamic>?> getMyAccount() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? _userToken = prefs.getString('UserToken');
    var url = Uri.https('sogak-api-nraiv.run.goorm.site', '/api/user/me/');
    var response =
        await http.get(url, headers: {'Authorization': 'Token $_userToken'});

    if (response.statusCode == 200) {
      Map<String, dynamic>? responseData = json.decode(response.body);
      return responseData;
    } else {
      throw Exception('Error: ${response.statusCode}, ${response.body}');
    }
  }

  Future<void> userErase() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? _userToken = prefs.getString('UserToken');
    if (_userToken != null) {
      var url = Uri.https('sogak-api-nraiv.run.goorm.site', '/api/user/delete/');
      var response = await http.delete(
        url,
        headers: {'Authorization': 'Token $_userToken'},
      );
      if (response.statusCode == 204) {
        prefs.remove('UserToken');
      } else {
        throw Exception('Error: ${response.statusCode}, ${response.body}');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "프로필",
          style: TextStyle(fontSize: 25.0),
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        leadingWidth: 40.0,
        elevation: 0.0,
        shadowColor: Colors.transparent,
      ),
      body: FutureBuilder(
        future: getMyAccount(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(
              child: Text(
                "잠시 후 다시 시도해 주세요.",
                textAlign: TextAlign.center,
              ),
            );
          } else {
            if (snapshot.data == null) {
              return const SizedBox.shrink();
            }
            Map<String, dynamic>? UserData =
                snapshot.data as Map<String, dynamic>;
            return Column(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 20.0,
                    ),
                    const Padding(
                      padding: EdgeInsets.only(left: 30.0),
                      child: Text("사용자 정보"),
                    ),
                    ProfileWidget(
                      inputData: UserData,
                      requireQuery: 'name',
                      inputText: "이름",
                    ),
                    ProfileWidget(
                      inputData: UserData,
                      requireQuery: 'email',
                      inputText: "이메일",
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 20.0,
                    ),
                    const Padding(
                      padding: EdgeInsets.only(left: 30.0),
                      child: Text(
                        "Danger Zone",
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        showLogoutDialog(context);
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 5.0),
                        child: Container(
                            width: MediaQuery.of(context).size.width,
                            height: 50.0,
                            decoration: BoxDecoration(
                                color: const Color(0xFF292929),
                                borderRadius: BorderRadius.circular(15.0)),
                            child: const Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(left: 20.0),
                                      child: Icon(Icons.phonelink_erase),
                                    ),
                                    SizedBox(width: 20.0),
                                    Text("회원 탈퇴"),
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
                  ],
                )
              ],
            );
                    }
        },
      ),
    );
  }

  void showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('회원 탈퇴'),
          content: const Text('정말 소각을 탈퇴하시겠습니까?\n모든 기록이 영구적으로 삭제됩니다.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                '취소',
                style: TextStyle(color: Colors.white),
              ),
            ),
            TextButton(
              onPressed: () async {
                await userErase().then((value) => Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const SplashScreen()),
                    (route) => false));
              },
              child: const Text(
                '탈퇴',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }
}

class ProfileWidget extends StatefulWidget {
  const ProfileWidget(
      {Key? key, required this.inputData,
      required this.requireQuery,
      required this.inputText}) : super(key: key);

  final dynamic inputData;
  final String inputText;
  final String requireQuery;

  @override
  State<ProfileWidget> createState() => _ProfileWidgetState();
}

class _ProfileWidgetState extends State<ProfileWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: 60.0,
          decoration: BoxDecoration(
            color: const Color(0xFF292929),
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Text(
                  widget.inputText,
                  style: const TextStyle(overflow: TextOverflow.fade),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 2.0),
                child: Text(widget.inputData[widget.requireQuery]),
              )
            ],
          ),
        ));
  }
}
