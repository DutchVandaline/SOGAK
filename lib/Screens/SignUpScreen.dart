import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

bool displayError = false;
bool passwordError = false;
bool emailError = false;

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

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
    passwordError = false;
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
    if (mounted) {
      if (response.statusCode == 200) {
        print('Sign-up successful');
      } else {
        print('Error: ${response.statusCode}');
        print('Error body: ${response.body}');
        setState(() {
          displayError = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 20.0, bottom: 8.0),
              child: Text(
                "Hello\nthere!",
                style: TextStyle(fontSize: 40.0),
              ),
            ),
            emailError
                ? const ErrorWidget(
                    inputString: "이메일 값이 잘못되었습니다.",
                  )
                : passwordError
                    ? const ErrorWidget(
                        inputString: "비밀번호는 다섯자리 이상이어야합니다.",
                      )
                    : displayError
                        ? const ErrorWidget(
                            inputString: "가입된 계정이거나 비밀번호가 일치하지 않습니다.",
                          )
                        : const SizedBox(
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
                    EmailController.text = text;
                  },
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.transparent),
                          borderRadius: BorderRadius.circular(15.0)),
                      focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.transparent),
                          borderRadius: BorderRadius.circular(15.0)),
                      enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.transparent),
                          borderRadius: BorderRadius.circular(15.0)),
                      hintText: "가입할 Email을 입력하세요.",
                      hintStyle: const TextStyle(
                          fontSize: 18.0, fontWeight: FontWeight.normal),
                      prefixIcon: const Icon(
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
                    PasswordController.text = text;
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.transparent),
                        borderRadius: BorderRadius.circular(15.0)),
                    focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.transparent),
                        borderRadius: BorderRadius.circular(15.0)),
                    enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.transparent),
                        borderRadius: BorderRadius.circular(15.0)),
                    hintText: "비밀번호를 입력하세요",
                    hintStyle: const TextStyle(
                        fontSize: 18.0, fontWeight: FontWeight.normal),
                    prefixIcon: const Icon(
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
                    CheckPasswordController.text = text;
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.transparent),
                        borderRadius: BorderRadius.circular(15.0)),
                    focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.transparent),
                        borderRadius: BorderRadius.circular(15.0)),
                    enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.transparent),
                        borderRadius: BorderRadius.circular(15.0)),
                    hintText: "비밀번호를 다시 한 번 입력하세요",
                    hintStyle: const TextStyle(
                        fontSize: 18.0, fontWeight: FontWeight.normal),
                    prefixIcon: const Icon(
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
                if (PasswordController.text.length < 5 &&
                    CheckPasswordController.text.length < 5) {
                  setState(() {
                    emailError = false;
                    passwordError = true;
                    displayError = false;
                  });
                } else if (PasswordController.text !=
                    CheckPasswordController.text) {
                  setState(() {
                    emailError = false;
                    passwordError = false;
                    displayError = true;
                  });
                } else if (!EmailController.text.contains("@") &&
                    !EmailController.text.contains(".")) {
                  setState(() {
                    emailError = true;
                    passwordError = false;
                    displayError = false;
                  });
                } else if (PasswordController.text ==
                        CheckPasswordController.text &&
                    PasswordController.text.length >= 5 &&
                    CheckPasswordController.text.length >= 5 &&
                    EmailController.text.contains("@") &&
                    EmailController.text.contains(".")) {
                  createUser(EmailController.text, PasswordController.text,
                      "User${DateTime.now()}");
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text("회원 가입이 완료되었습니다. 로그인해주세요."),
                    duration: Duration(seconds: 2),
                  ));
                  Navigator.pop(context);
                }
              },
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 60.0,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15.0)),
                  child: Center(
                    child: Text(
                      "회원 가입",
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
                child: const Center(
                    child: Text(
                  "이미 계정이 있으신가요?",
                  style: TextStyle(fontSize: 15.0),
                ))),
            const SizedBox(
              height: 40.0,
            ),
          ],
        ),
      ),
    );
  }
}

class ErrorWidget extends StatelessWidget {
  const ErrorWidget({Key? key, required this.inputString}) : super(key: key);
  final String inputString;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: Container(
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5.0),
            color: Colors.red.shade100,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              inputString,
              style: const TextStyle(color: Colors.red),
            ),
          ),
        ),
      ),
    );
  }
}
