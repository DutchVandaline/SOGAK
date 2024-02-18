import 'package:flutter/material.dart';
import 'package:sogak/Widgets/MoodTagWidget.dart';
import 'package:sogak/Widgets/WarmingSentences.dart';
import 'package:sogak/Services/Api_services.dart';
import 'dart:math';
import 'dart:core';

import 'SplashScreen.dart';

String sogakState = "";
bool fadeAway = true;
bool sogakComplete = false;
double sogakStatus = 0.0;

class SogakStatusScreen extends StatefulWidget {
  const SogakStatusScreen({Key? key, required this.inputId}) : super(key: key);

  final int inputId;

  @override
  State<SogakStatusScreen> createState() => _SogakStatusScreenState();
}

class _SogakStatusScreenState extends State<SogakStatusScreen> {
  final afterMemoController = TextEditingController();
  int randomNumb = Random().nextInt(warmingSentences.length);

  @override
  void initState() {
    checkSogak();
    sogakComplete = false;
    super.initState();
  }

  void checkSogak() async {
    setState(() {
      sogakState = "소각로 확인 중...";
      sogakStatus = 0.2;
    });
    await Future.delayed(const Duration(seconds: 3));
    setState(() {
      fadeAway = false;
      sogakState = "감정 소각 중...";
      sogakStatus = 0.8;
    });
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      sogakStatus = 1.0;
      sogakState = "감정 소각 완료";
      sogakComplete = true;
    });
  }

  @override
  void dispose() {
    afterMemoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color(0xff252527),
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Flexible(
                  flex: 2,
                  child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Container(
                        alignment: Alignment.bottomCenter,
                        child: FutureBuilder(
                          future: ApiService.selectedSogakData(widget.inputId),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(child: Text(""));
                            } else if (snapshot.hasError) {
                              return const Center(
                                child: Text("불러오는데 에러가 발생했습니다."),
                              );
                            } else {
                              var SogakData =
                                  snapshot.data as Map<String, dynamic>?;
                              print(SogakData!['detail_mood']);
                              List<dynamic> detailMoodList =
                                  SogakData['detail_mood'];
                              List splitDigitsList = detailMoodList
                                  .expand((character) => character.split(''))
                                  .toList();
                              return Wrap(
                                  spacing: 1.0,
                                  alignment: WrapAlignment.center,
                                  children:
                                      createMoodTagWidgets(splitDigitsList));
                            }
                          },
                        ),
                      )),
                ),
                Flexible(
                  flex: 5,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 5.0),
                        child: Text(
                          sogakState,
                          style: const TextStyle(fontSize: 20.0),
                        ),
                      ),
                      Padding(
                          padding: const EdgeInsets.only(
                            bottom: 10.0,
                          ),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width * 0.6,
                            child: LinearProgressIndicator(
                              value: sogakStatus,
                              backgroundColor: Colors.grey,
                              valueColor: const AlwaysStoppedAnimation<Color>(
                                  Colors.red),
                              minHeight: 10.0,
                            ),
                          )),
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            height: MediaQuery.of(context).size.height * 0.34,
                            decoration: const BoxDecoration(
                                image: DecorationImage(
                              fit: BoxFit.fitWidth,
                              alignment: FractionalOffset.bottomCenter,
                              image: AssetImage('assets/images/flame.gif'),
                            )),
                          ),
                          Container(
                            height: MediaQuery.of(context).size.height * 0.34,
                            width: MediaQuery.of(context).size.width * 0.6,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              border: Border.all(color: Colors.grey),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Flexible(
                    flex: 2,
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.2,
                      width: MediaQuery.of(context).size.width * 0.9,
                      alignment: Alignment.topCenter,
                      child: Text(
                        warmingSentences[randomNumb],
                        textAlign: TextAlign.center,
                      ),
                    )),
                Flexible(
                    flex: 1,
                    child: GestureDetector(
                      onTap: () {
                        if (sogakComplete) {
                          showAddMemoDialog(context);
                        } else {
                          print("stay");
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10.0)),
                        width: MediaQuery.of(context).size.width * 0.9,
                        height: 60.0,
                        alignment: Alignment.topCenter,
                        child: Center(
                          child: Text(
                            "소각 완료",
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall!
                                .copyWith(
                                    fontWeight: FontWeight.normal,
                                    color: sogakComplete
                                        ? Colors.black
                                        : Colors.grey),
                          ),
                        ),
                      ),
                    )),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void showAddMemoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            '메모 추가',
            style: TextStyle(fontSize: 20.0),
          ),
          titlePadding: const EdgeInsets.only(top: 30.0, left: 30.0),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                '소각된 감정은 다시 열람이 불가능합니다.\n소각 완료하기 전에 메모를 추가하시겠습니까?',
                style: TextStyle(fontSize: 15.0),
              ),
              TextField(
                controller: afterMemoController,
                style: const TextStyle(fontSize: 15.0),
                onChanged: (text) {
                  afterMemoController.text = text;
                },
                maxLength: 50,
                maxLines: 2,
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
                  hintText: "추가하지 않으시려면 빈칸으로 두세요.",
                  hintStyle: const TextStyle(
                      fontSize: 15.0, fontWeight: FontWeight.normal),
                ),
              )
            ],
          ),
          actions: [
            TextButton(
              onPressed: () async {
                await ApiService.patchMoodtoSogak(
                        widget.inputId, afterMemoController.text)
                    .then((value) => Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => const SplashScreen()),
                        (route) => false));
              },
              child: const Text(
                '소각 완료',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }
}

List<MoodTagWidget> createMoodTagWidgets(List splitDigitsList) {
  List<MoodTagWidget> moodTagWidgets = [];
  for (int i = 0; i < splitDigitsList.length; i++) {
    moodTagWidgets.add(
      MoodTagWidget(
        inputmood: splitDigitsList[i],
        sogakBool: fadeAway,
      ),
    );
  }

  return moodTagWidgets;
}
