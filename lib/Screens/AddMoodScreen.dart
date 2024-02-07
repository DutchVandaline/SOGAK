import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sogak/Widgets/SliderWidget.dart';
import 'package:intl/intl.dart';
import 'package:group_button/group_button.dart';
import 'dart:core';

List<int> MoodList = [];
int tiredRate = 5;
int stressRate = 5;
int baseMoodRate = 0;
bool errorState = false;
String inputWhatHappened = "";

class AddMoodScreen extends StatefulWidget {
  @override
  State<AddMoodScreen> createState() => _AddMoodScreenState();
}

void postMood(int _base_mood, String _date, String _detail_mood,
    String _what_happened, int _tired_rate, int _stress_rate) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? _userToken = prefs.getString('UserToken');

  var url =
      Uri.https('sogak-api-nraiv.run.goorm.site', '/api/feeling/feelings/');
  var response = await http.post(url, headers: {
    'Authorization': 'Token $_userToken'
  }, body: {
    'base_mood': '$_base_mood',
    'date': '$_date',
    'detail_mood': _detail_mood,
    'what_happened': '$_what_happened',
    'tired_rate': '$_tired_rate',
    'stress_rate': '$_stress_rate',
  });
  if (response.statusCode == 200) {
    print(response.body);
  } else {
    print('Error: ${response.statusCode}');
    print('Error body: ${response.body}');
  }
}

class _AddMoodScreenState extends State<AddMoodScreen> {
  final WhatHappenedController = TextEditingController();
  String addDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          "감정을 추가하세요 😌",
        ),
        centerTitle: false,
        backgroundColor: Theme.of(context).cardColor,
        leadingWidth: 40.0,
        elevation: 0.0,
        shadowColor: Colors.transparent,
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: ListView(
              children: [
                Center(
                  child: Text(addDate),
                ),
                AddMoodWidget(
                    widgetTitle: "전반적인 오늘",
                    detailText: "오늘 하루를 하나로 표현한다면?",
                    inputWidget: Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 0.1,
                      child: GroupButton(
                        onSelected: (button, index, isSelected){
                          baseMoodRate = index + 1;
                          print(baseMoodRate);
                        },
                        buttons: [
                          "매우\n불만족", "불만족", "보통", "만족", "매우\n만족",
                        ],
                        options: GroupButtonOptions(
                          selectedColor: Colors.white,
                          unselectedBorderColor: Colors.white,
                          unselectedColor: Theme.of(context).cardColor,
                          selectedTextStyle: TextStyle(color: Colors.black),
                          unselectedTextStyle: TextStyle(color: Colors.white),
                          textAlign: TextAlign.center,
                          buttonHeight: 65.0,
                          buttonWidth: 65.0,
                          spacing: 10.0,

                        ),

                      ),
                    )),
                SizedBox(height: 30.0),
                AddMoodWidget(
                    widgetTitle: "피로도",
                    detailText: "신체적 피로도를 선택하세요.",
                    inputWidget: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: SliderWidget(
                        inputText1: "완전 피로",
                        inputText2: "무난",
                        inputText3: "완전 개운",
                        inputSlider: Slider(
                          value: tiredRate.toDouble(),
                          onChanged: (double newValue) {
                            setState(() {
                              tiredRate = newValue.toInt();
                              print("tiredRate : $tiredRate");
                            });
                          },
                          min: 0.0,
                          max: 10.0,
                          divisions: 10,
                        ),
                      ),
                    )),
                SizedBox(height: 30.0),
                AddMoodWidget(
                    widgetTitle: "세부 감정",
                    detailText:
                        "세부 감정을 하나 이상 선택하세요.",
                    inputWidget: Container(
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              MoodSelectWidget(
                                  inputMood: "😁 행복한", inputNumb: 1),
                              MoodSelectWidget(
                                  inputMood: "🥰 사랑스러운", inputNumb: 3),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              MoodSelectWidget(
                                  inputMood: "🤩 흥분되는", inputNumb: 2),
                              MoodSelectWidget(
                                  inputMood: "😭 슬픈", inputNumb: 4),
                              MoodSelectWidget(
                                  inputMood: "🤮 혐오스러운", inputNumb: 7),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              MoodSelectWidget(
                                  inputMood: "😱 공포스러운", inputNumb: 6),
                              MoodSelectWidget(
                                  inputMood: "🤬 분노하는", inputNumb: 5),
                            ],
                          ),
                        ],
                      ),
                    )),
                SizedBox(height: 30.0),
                AddMoodWidget(
                    widgetTitle: "스트레스 지수",
                    detailText: "정신적 피로도를 선택하세요.",
                    inputWidget: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: SliderWidget(
                        inputText1: "낮음",
                        inputText2: "보통",
                        inputText3: "높음",
                        inputSlider: Slider(
                          value: stressRate.toDouble(),
                          onChanged: (double newValue) {
                            setState(() {
                              stressRate = newValue.toInt();
                              print("stressRate : $stressRate");
                            });
                          },
                          min: 0.0,
                          max: 10.0,
                          divisions: 10,
                        ),
                      ),
                    )),
                SizedBox(height: 30.0),
                AddMoodWidget(
                    widgetTitle: "무슨 일이었나요?",
                    detailText: "솔직히 작성할수록 소각의 효과가 큽니다.",
                    inputWidget: Container(
                      height: MediaQuery.of(context).size.height * 0.3,
                      decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(10.0)),
                      child: TextField(
                        controller: WhatHappenedController,
                        onChanged: (text) {
                          setState(() {
                            inputWhatHappened = text;
                          });
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
                          hintText: "무슨 일이 있었나요?",
                          hintStyle: TextStyle(
                              fontSize: 18.0, fontWeight: FontWeight.normal),
                        ),
                        cursorColor: Colors.grey,
                        maxLines: 11,
                        autofocus: false,
                      ),
                    )),
                errorState
                    ? Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Container(
                            width: MediaQuery.of(context).size.width * 0.9,
                            height: 30.0,
                            decoration: BoxDecoration(
                                color: Colors.red.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(5.0),
                                border: Border.all(color: Colors.red)),
                            child: Center(
                              child: Text(
                                "입력된 값이 잘못되었습니다.",
                                style: TextStyle(color: Colors.red),
                              ),
                            )),
                      )
                    : SizedBox(height: 30.0),
                Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.0),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          String inputMoodList = MoodList.join();
                          if (MoodList.length >= 1 && baseMoodRate != 0) {
                            postMood(baseMoodRate, addDate, inputMoodList,
                                inputWhatHappened, tiredRate, stressRate);
                            MoodList = [];
                            tiredRate = 5;
                            stressRate = 5;
                            baseMoodRate = 0;
                            inputWhatHappened = "";
                            errorState = false;
                            Navigator.pop(context);
                          } else {
                            errorState = true;
                          }
                        });
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: 60.0,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15.0)),
                        child: Center(
                          child: Text(
                            "Add Mood",
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ),
                      ),
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MoodSelectWidget extends StatefulWidget {
  MoodSelectWidget({this.inputMood, this.inputNumb});

  final inputMood;
  final inputNumb;

  @override
  State<MoodSelectWidget> createState() => _MoodSelectWidgetState();
}

class _MoodSelectWidgetState extends State<MoodSelectWidget> {
  bool _onpressed = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
        child: GestureDetector(
          onTap: () {
            setState(() {
              _onpressed = !_onpressed;
              _onpressed
                  ? MoodList.add(widget.inputNumb)
                  : MoodList.remove(widget.inputNumb);
              print(MoodList);
            });
          },
          child: Container(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 3.0),
              child: Text(
                widget.inputMood,
                style: _onpressed
                    ? TextStyle(fontSize: 20.0, color: Colors.black)
                    : TextStyle(fontSize: 20.0, color: Colors.white),
              ),
            ),
            decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                color: _onpressed ? Colors.white : Colors.transparent),
          ),
        ));
  }
}


class AddMoodWidget extends StatelessWidget {
  AddMoodWidget(
      {required this.widgetTitle,
      required this.detailText,
      required this.inputWidget});

  final String widgetTitle;
  final String detailText;
  final Widget inputWidget;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          widgetTitle,
          style: TextStyle(
            color: Colors.white,
            fontSize: 25.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.0),
          child: Text(
            detailText,
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(
          height: 5.0,
        ),
        inputWidget,
      ],
    );
  }
}
