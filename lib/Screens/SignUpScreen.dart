import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

bool displayError = false;

class SignUpScreen extends StatefulWidget {
  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final EmailController = TextEditingController();
  final PasswordController = TextEditingController();
  final CheckPasswordController = TextEditingController();


  @override
  void dispose() {
    EmailController.dispose();
    PasswordController.dispose();
    CheckPasswordController.dispose();
    displayError = false;
    super.dispose();
  }

  void createUser(
      String _enterEmail, String _enterPassword, String _enterName) async {
    var url = Uri.https('sogak-api-nraiv.run.goorm.site', '/api/user/create/');
    var response = await http.post(url, body: {
      'email': _enterEmail,
      'password': _enterPassword,
      'name': _enterName
    });
    if (response.statusCode == 200) {
      print('Sign-up successful');
      Navigator.pop(context);
    } else {
      print('Error: ${response.statusCode}');
      print('Error body: ${response.body}');
      setState(() {
        displayError = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    String inputEmail = "";
    String inputPassword = "";
    String checkPassword = "";

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
                  "Hello\nthere!",
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
                          "가입된 계정이거나 비밀번호가 일치하지 않습니다.",
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ),
                  )
                : SizedBox(
                    height: 20.0,
                  ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 5.0, horizontal: 15.0),
              child: Container(
                decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(10.0)),
                child: TextField(
                  controller: EmailController,
                  onChanged: (text) {
                    inputEmail = text;
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
                      hintText: "가입할 Email을 입력하세요.",
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
              padding:
                  const EdgeInsets.symmetric(vertical: 5.0, horizontal: 15.0),
              child: Container(
                decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(10.0)),
                child: TextField(
                  controller: PasswordController,
                  onChanged: (text) {
                    inputPassword = text;
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
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 5.0, horizontal: 15.0),
              child: Container(
                decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(10.0)),
                child: TextField(
                  controller: CheckPasswordController,
                  onChanged: (text) {
                    checkPassword = text;
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
                    hintText: "비밀번호를 다시 한 번 입력하세요",
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
                if (inputPassword == checkPassword) {
                  print("Password Matches!");
                  createUser(
                      inputEmail, inputPassword, "User${DateTime.now()}");
                } else {
                  print("Check the Password!");
                }
              },
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 60.0,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15.0)),
                  child: Center(
                    child: Text(
                      "Sign-Up",
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                ),
              ),
            ),
            GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Center(
                    child: Text(
                  "이미 계정이 있으신가요?",
                  style: TextStyle(fontSize: 15.0),
                ))),
            SizedBox(
              height: 40.0,
            ),
          ],
        ),
      ),
    );
  }
}
