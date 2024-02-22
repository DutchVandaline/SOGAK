import 'package:flutter/material.dart';
import 'package:sogak/Screens/SplashScreen.dart';
import 'package:intl/intl.dart';
import 'package:sogak/Services/Api_services.dart';
import 'package:sogak/Widgets/DetailScreenWidget.dart';
import 'dart:convert';

import 'package:sogak/Widgets/MoodTagWidget.dart';

class DetailScreen extends StatefulWidget {
  const DetailScreen({Key? key, required this.inputId}) : super(key: key);
  final int inputId;

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {

  TextEditingController WhatHappenedController = TextEditingController();
  late Map<String, dynamic>? sogakData;

  @override
  void initState() {
    WhatHappenedController = TextEditingController();
    ApiService.getDatabyId(widget.inputId)?.then((data) {
      String decodedWhatHappened =
      utf8.decode(data['what_happened'].codeUnits);
      setState(() {
        WhatHappenedController.text = decodedWhatHappened;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    WhatHappenedController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        centerTitle: false,
        leadingWidth: 40.0,
        elevation: 0.0,
        shadowColor: Colors.transparent,
        automaticallyImplyLeading: false,
        title: const Text("세부 감정 🔍"),
        actions: [
          IconButton(
              onPressed: () {
                ApiService.patchWhatHappened(sogakData?['id'], WhatHappenedController.text);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text("정상적으로 수정되었습니다."),
                  duration: Duration(seconds: 2),
                ));
              },
              icon: const Icon(Icons.save_alt)),
          IconButton(
              onPressed: () {
                deleteDialog(context);
              },
              icon: const Icon(Icons.delete_forever)),
        ],
      ),
      body: SafeArea(
        child: FutureBuilder(
          future: ApiService.getDatabyId(widget.inputId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return const Center(
                child: Text("이미 삭제되었거나\n불러오는데 오류가 발생했습니다."),
              );
            } else {
              sogakData = snapshot.data as Map<String, dynamic>;
              if (sogakData!.isNotEmpty) {
                String inputDate = sogakData?['date'];
                int baseMoodState = sogakData?['base_mood'];
                int stressRate = sogakData?['stress_rate'];
                int tiredRate = sogakData?['tired_rate'];
                List<dynamic> detailMoodList = sogakData?['detail_mood'];
                List splitDigitsList =
                detailMoodList.expand((character) => character.split('')).toList();
                List<MoodTagWidget> moodTagWidgets = createMoodTagWidgets(splitDigitsList);

                DateTime originalDate = DateTime.parse(inputDate);
                String formattedDateMonth =
                DateFormat('MMM').format(originalDate).toUpperCase();
                String formattedDateDate = DateFormat('d').format(originalDate);

                return Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Row(
                          children: [
                            Flexible(
                                flex: 1,
                                child: DetailScreenWidget(
                                  inputWidget: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                          child: Text(
                                            formattedDateMonth,
                                            style: Theme.of(context).textTheme.titleLarge,
                                          )),
                                      Text(formattedDateDate,
                                          style: const TextStyle(fontSize: 50.0))
                                    ],
                                  ),
                                  inputWidth: MediaQuery.of(context).size.width * 0.5,
                                  inputHeight: 150.0,
                                )),
                            Flexible(
                                flex: 2,
                                child: DetailScreenWidget(
                                  inputWidget: ListView(children: [
                                    const SizedBox(height: 20.0),
                                    Center(
                                        child: Wrap(
                                          children: moodTagWidgets,
                                          alignment: WrapAlignment.center,
                                        )),
                                  ]),
                                  inputWidth: MediaQuery.of(context).size.width * 0.8,
                                  inputHeight: 150.0,
                                )),
                          ],
                        ),
                        Row(
                          children: [
                            Flexible(
                              flex: 1,
                              child: NumberWidget(
                                  inputText: "${stressRate}0%", inputTitle: "🤯스트레스"),
                            ),
                            Flexible(
                              flex: 1,
                              child: NumberWidget(
                                  inputText: "${tiredRate}0%", inputTitle: "🥱피로도"),
                            ),
                            Flexible(
                              flex: 1,
                              child: NumberWidget(
                                  inputText: BasedOnBaseMood(baseMoodState),
                                  inputTitle: "😃만족도"),
                            ),
                          ],
                        ),
                        DetailScreenWidget(
                          inputWidget: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Padding(
                                  padding: EdgeInsets.only(top: 10.0),
                                  child: Text("무슨 일이 있었나요?"),
                                ),
                                SizedBox(
                                  height: MediaQuery.of(context).size.height * 0.26,
                                  child: TextField(
                                    controller: WhatHappenedController,
                                    onChanged: (text) {
                                        WhatHappenedController.text = text;
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
                                      hintText: "입력된 값이 없습니다.",
                                      hintStyle: const TextStyle(
                                          fontSize: 18.0, fontWeight: FontWeight.normal),
                                    ),
                                    cursorColor: Colors.grey,
                                    maxLines: 10,
                                    autofocus: false,
                                  ),
                                )
                              ],
                            ),
                          ),
                          inputWidth: MediaQuery.of(context).size.width,
                          inputHeight: MediaQuery.of(context).size.height * 0.33,
                        ),
                        GestureDetector(
                          onTap: () {
                            ApiService.patchMovetoSogak(widget.inputId);
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                              content: Text(
                                "소각로로 이동했습니다. 소각로에서 확인해주세요.",
                                maxLines: 1,
                                style: TextStyle(fontSize: 15.0),
                              ),
                              duration: Duration(seconds: 2),
                            ));
                            Navigator.pop(context);
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Container(
                              height: 50.0,
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10.0)),
                              child: const Center(
                                child: Text(
                                  "🔥 소각로 이동",
                                  style: TextStyle(color: Colors.black, fontSize: 24.0),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              } else {
                return const Text('No data available');
              }
            }
          },
        ),
      ),
    );
  }
  void deleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('삭제 확인'),
          content: const Text(
            '이미 소각된 감정입니다.\n해당 감정을 삭제하시겠습니까?',
            style: TextStyle(fontSize: 13.0),
          ),
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
                ApiService.deleteMood(widget.inputId);
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SplashScreen()),
                        (route) => false);
              },
              child: const Text(
                '삭제',
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
        sogakBool: true,
      ),
    );
  }

  return moodTagWidgets;
}

class NumberWidget extends StatelessWidget {
  const NumberWidget({Key? key, required this.inputTitle, required this.inputText}) : super(key: key);

  final String inputTitle;
  final String inputText;

  @override
  Widget build(BuildContext context) {
    return DetailScreenWidget(
      inputWidget: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            inputTitle,
            textAlign: TextAlign.center,
          ),
          Text(
            inputText,
            style: const TextStyle(
              fontSize: 25.0,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
      inputWidth: MediaQuery.of(context).size.width * 0.3,
      inputHeight: 150.0,
    );
  }
}

String BasedOnBaseMood(int inputBaseMood) {
  String outputTag = "";
  if (inputBaseMood == 1) {
    return outputTag = "매우\n불만족";
  } else if (inputBaseMood == 2) {
    return outputTag = "불만족";
  } else if (inputBaseMood == 3) {
    return outputTag = "보통";
  } else if (inputBaseMood == 4) {
    return outputTag = "만족";
  } else if (inputBaseMood == 5) {
    return outputTag = "매우 만족";
  }
  return outputTag = "";
}