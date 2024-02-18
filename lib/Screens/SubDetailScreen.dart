import 'package:flutter/material.dart';
import 'package:sogak/Widgets/DetailScreenWidget.dart';
import 'package:sogak/Widgets/MoodTagWidget.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class DetailSubScreen extends StatefulWidget {
  DetailSubScreen({Key? key, required this.inputData}) : super(key: key);

  var inputData;

  @override
  State<DetailSubScreen> createState() => _DetailSubScreenState();
}

Future<void> patchWhatHappened(int _inputId, String updatedWhatHappened) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? _userToken = prefs.getString('UserToken');
  var url = Uri.https(
      'sogak-api-nraiv.run.goorm.site', '/api/feeling/feelings/$_inputId/');
  var response = await http.patch(url,
      headers: {'Authorization': 'Token $_userToken'},
      body: {"what_happened": updatedWhatHappened});
  if (response.statusCode == 200) {
    print(response.body);
  } else {
    print('Error: ${response.statusCode}');
    print('Error body: ${response.body}');
  }
}

class _DetailSubScreenState extends State<DetailSubScreen> {
  final WhatHappenedController = TextEditingController();

  @override
  void initState() {
    String decodedWhatHappened =
        utf8.decode(widget.inputData['what_happened'].codeUnits);
    WhatHappenedController.text = decodedWhatHappened;
    super.initState();
  }

  @override
  void dispose() {
    WhatHappenedController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    int inputId = widget.inputData['id'];
    String inputDate = widget.inputData['date'];
    int baseMoodState = widget.inputData['base_mood'];
    int stressRate = widget.inputData['stress_rate'];
    int tiredRate = widget.inputData['tired_rate'];
    List<dynamic> detailMoodList = widget.inputData['detail_mood'];
    List splitDigitsList =
        detailMoodList.expand((character) => character.split('')).toList();
    List<MoodTagWidget> moodTagWidgets = createMoodTagWidgets(splitDigitsList);

    DateTime originalDate = DateTime.parse(inputDate);
    String formattedDateMonth =
        DateFormat('MMM').format(originalDate).toUpperCase();
    String formattedDateDate = DateFormat('d').format(originalDate);

    return SingleChildScrollView(
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
                        setState(() {
                          WhatHappenedController.text = text;
                        });
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
              print(WhatHappenedController.text);
              patchWhatHappened(inputId, WhatHappenedController.text);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text("정상적으로 수정되었습니다."),
                duration: Duration(seconds: 2),
              ));
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
                    "🖋️ 수정하기",
                    style: TextStyle(color: Colors.black, fontSize: 24.0),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
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
