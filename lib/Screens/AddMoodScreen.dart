import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sogak/Widgets/SliderWidget.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'dart:core';

List<int> MoodList = [];
int tiredRate = 5;
int stressRate = 5;
int baseMoodRate = 4;

class AddMoodScreen extends StatefulWidget {
  @override
  State<AddMoodScreen> createState() => _AddMoodScreenState();
}

void postMood(
    int _base_mood,
    String _date,
    List<int> _detail_mood,
    String _what_happened,
    int _tired_rate,
    int _stress_rate) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? _userToken = prefs.getString('UserToken');


  //TODO: list input error
  var url = Uri.https('sogak-api-nraiv.run.goorm.site', '/api/feeling/feelings/');
  var response = await http.post(url, headers: {
    'Authorization': 'Token $_userToken'
  }, body: {
    'base_mood': '$_base_mood',
    'date': '$_date',
    'detail_mood': json.encode(_detail_mood),
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
    String inputWhatHappened = "";
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          "Add Mood 😌",
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
                Center(child: Text(addDate),),
                AddMoodWidget(widgetTitle: "Base Mood", detailText: "here goes the detail text", inputWidget: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.1,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      BaseMoodWidget(inputNumber: 0),
                      BaseMoodWidget(inputNumber: 1),
                      BaseMoodWidget(inputNumber: 2),
                      BaseMoodWidget(inputNumber: 3),
                      BaseMoodWidget(inputNumber: 4),
                    ],
                  ),
                )),
                AddMoodWidget(widgetTitle: "Tired Rate", detailText: "here goes the detail text",inputWidget:Padding(
                  padding: EdgeInsets.all(8.0),
                  child: SliderWidget(inputText1: "완전 피로", inputText2: "무난", inputText3: "완전 개운", inputSlider: Slider(
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
                  ),),
                )),
                AddMoodWidget(widgetTitle: "Detail Mood", detailText: "here goes the detail text",inputWidget: Container(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          MoodSelectWidget(inputMood: "😁 행복한", inputNumb: 1),
                          MoodSelectWidget(inputMood: "🥰 사랑스러운", inputNumb: 3),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          MoodSelectWidget(inputMood: "🤩 흥분되는", inputNumb: 2),
                          MoodSelectWidget(inputMood: "😭 슬픈", inputNumb: 4),
                          MoodSelectWidget(inputMood: "🤮 혐오스러운", inputNumb: 7),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          MoodSelectWidget(inputMood: "😱 공포스러운",inputNumb: 6),
                          MoodSelectWidget(inputMood: "🤬 분노하는", inputNumb: 5),
                        ],
                      ),
                    ],
                  ),
                )),
                AddMoodWidget(widgetTitle: "Stress Rate", detailText: "here goes the detail text",inputWidget: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: SliderWidget(inputText1: "낮음", inputText2: "보통", inputText3: "높음", inputSlider: Slider(
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
                  ),),
                )),
                AddMoodWidget(widgetTitle: "What Happened", detailText: "here goes the detail text",inputWidget: Container(
                  height: MediaQuery.of(context).size.height * 0.3,
                  decoration: BoxDecoration(
                      color: Theme
                          .of(context)
                          .primaryColor,
                      borderRadius: BorderRadius.circular(10.0)),
                  child: TextField(
                    controller: WhatHappenedController,
                    onChanged: (text) {
                      inputWhatHappened = text;
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
                      hintStyle: TextStyle(fontSize: 18.0, fontWeight: FontWeight.normal),
                    ),
                    cursorColor: Colors.grey,
                    autofocus: false,
                  ),
                )),
                Padding(
                  padding: EdgeInsets.all(10.0),
                  child: GestureDetector(
                    onTap: (){
                      print("tired Rate : $tiredRate");
                      print("stress Rate : $stressRate");
                      print("whathappended : $inputWhatHappened");
                      print("moodList : $MoodList");

                      postMood(baseMoodRate, addDate, MoodList, inputWhatHappened, tiredRate, stressRate);
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
                  )
                )
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
                style: _onpressed && MoodList.length <= 3
                    ? TextStyle(fontSize: 20.0, color: Colors.black)
                    : TextStyle(fontSize: 20.0, color: Colors.white),
              ),
            ),
            decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                color: _onpressed && MoodList.length <= 3
                    ? Colors.white
                    : Colors.transparent),
          ),
        ));
  }
}

class BaseMoodWidget extends StatefulWidget {
  BaseMoodWidget({required this.inputNumber});

  final int inputNumber;

  @override
  State<BaseMoodWidget> createState() => _BaseMoodWidgetState();
}

class _BaseMoodWidgetState extends State<BaseMoodWidget> {
  bool _selected = false;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        setState(() {
          _selected = !_selected;
          baseMoodRate = widget.inputNumber;
          print("baseMoodRate: $baseMoodRate");
        });
      },
      child: Container(
          decoration: BoxDecoration(border: Border.all(color: Colors.white),
              color: _selected ? Colors.white : Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(5.0)),
          child: Padding(
            padding: EdgeInsets.all(15.0),
            child: Text("${widget.inputNumber}"),
          )),
    );
  }
}

class AddMoodWidget extends StatelessWidget {
  AddMoodWidget({required this.widgetTitle, required this.detailText, required this.inputWidget});
  final String widgetTitle;
  final String detailText;
  final Widget inputWidget;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(widgetTitle, style: TextStyle(color: Colors.white, fontSize: 25.0, fontWeight: FontWeight.bold),),
        Text(detailText, style: Theme.of(context).textTheme.bodyMedium),
        SizedBox(height: 5.0,),
        inputWidget,
        SizedBox(height: 30.0,),

      ],
    );
  }
}
