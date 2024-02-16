import 'package:flutter/material.dart';
import 'package:sogak/Screens/SignUpScreen.dart';
import 'package:http/http.dart' as http;
import 'package:sogak/Screens/MainScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

bool displayError = false;

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final EmailController = TextEditingController();
  final PasswordController = TextEditingController();

  @override
  void dispose() {
    EmailController.dispose();
    PasswordController.dispose();
    super.dispose();
  }

  void createToken(String _enterEmail, String _enterPassword) async {
    var url = Uri.https('sogak-api-nraiv.run.goorm.site', '/api/user/token/');
    var response = await http.post(url, body: {
      'email': _enterEmail,
      'password': _enterPassword
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (response.statusCode == 200) {
      print(response.body);
      Map<String, dynamic> jsonData = json.decode(response.body);
      String token = jsonData['token'];
      userAuthorize(token);
      prefs.setString("UserToken", token);
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
          builder: (context) => MainScreen()), (
          route) => false);
    } else {
      print('Error: ${response.statusCode}');
      print('Error body: ${response.body}');
      setState(() {
        displayError = true;
      });
    }
  }

  void userAuthorize(String _userToken) async {
    var url = Uri.https('sogak-api-nraiv.run.goorm.site', '/api/feeling/feelings/');
    var response = await http.get(url, headers: {'Authorization': 'Token $_userToken'});

    if (response.statusCode == 200) {
      List<dynamic> responseData = json.decode(response.body);
      print('Response Data: $responseData');
    } else {
      print('Error: ${response.statusCode}, ${response.body}');
    }
  }

  @override
  void initState(){
    setState(() {
      displayError = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 20.0, bottom: 8.0),
              child: Container(
                child: Text(
                  "Welcome\nback!",
                  style: TextStyle(fontSize: 40.0),
                ),
              ),
            ),
            displayError
                ? Center(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5.0),
                  color: Colors.red.shade100,
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    "없는 계정이거나 비밀번호가 일치하지 않습니다.",
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ),
            )
                : SizedBox(
              height: 20.0,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                  vertical: 5.0, horizontal: 15.0),
              child: Container(
                decoration: BoxDecoration(
                    color: Theme
                        .of(context)
                        .primaryColor,
                    borderRadius: BorderRadius.circular(10.0)),
                child: TextField(
                  controller: EmailController,
                  onChanged: (text) {
                    //inputEmail = text;
                    EmailController.text = text;
                  },
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.transparent),
                          borderRadius: BorderRadius.circular(15.0)),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.transparent),
                          borderRadius: BorderRadius.circular(15.0)),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.transparent),
                          borderRadius: BorderRadius.circular(15.0)),
                      hintText: "Email을 입력하세요.",
                      hintStyle: TextStyle(
                          fontSize: 18.0, fontWeight: FontWeight.normal),
                      prefixIcon: Icon(
                        Icons.email_outlined,
                        color: Colors.white,
                      )),
                  cursorColor: Colors.grey,
                  autofocus: false,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                  vertical: 5.0, horizontal: 15.0),
              child: Container(
                decoration: BoxDecoration(
                    color: Theme
                        .of(context)
                        .primaryColor,
                    borderRadius: BorderRadius.circular(10.0)),
                child: TextField(
                  controller: PasswordController,
                  onChanged: (text) {
                    //inputPassword = text;
                    PasswordController.text = text;
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.transparent),
                        borderRadius: BorderRadius.circular(15.0)),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.transparent),
                        borderRadius: BorderRadius.circular(15.0)),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.transparent),
                        borderRadius: BorderRadius.circular(15.0)),
                    hintText: "비밀번호를 입력하세요",
                    hintStyle: TextStyle(
                        fontSize: 18.0, fontWeight: FontWeight.normal),
                    prefixIcon: Icon(
                      Icons.password_outlined,
                      color: Colors.white,
                    ),
                  ),
                  cursorColor: Colors.grey,
                  obscureText: true,
                  autofocus: false,
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                createToken(EmailController.text, PasswordController.text);
                setState(() {
                  EmailController.text = "";
                  PasswordController.text = "";
                });
              },
              child: Padding(
                padding:
                EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
                child: Container(
                  width: MediaQuery
                      .of(context)
                      .size
                      .width,
                  height: 60.0,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15.0)),
                  child: Center(
                    child: Text(
                      "로그인",
                      style: Theme
                          .of(context)
                          .textTheme
                          .bodySmall,
                    ),
                  ),
                ),
              ),
            ),
            GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(
                      builder: (context) => SignUpScreen()));
                  setState(() {
                    displayError = false;
                  });
                },
                child: Center(
                  child: Text.rich(
                    TextSpan(
                      text: 'Sogak에 ',
                      style: TextStyle(fontSize: 15.0),
                      children: <TextSpan>[
                        TextSpan(
                            text: '처음이신가요',
                            style: TextStyle(
                              decoration: TextDecoration.underline,
                            )),
                      ],
                    ),
                  ),
                )
            ),
            SizedBox(height: 40.0,),
          ],
        ),
      ),
    );
  }
}
