import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sogak/Widgets/SliderWidget.dart';
import 'package:intl/intl.dart';
import 'package:group_button/group_button.dart';
import 'dart:core';

List<String> MoodList = [];
int tiredRate = 5;
int stressRate = 5;
int baseMoodRate = 0;
bool errorState = false;
DateTime initialDateInput = DateTime.now();

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
  String formattedDate = DateFormat('MMM dd, yyyy').format(DateTime.now());
  String addDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

  @override
  void initState() {
    MoodList = [];
    tiredRate = 5;
    stressRate = 5;
    baseMoodRate = 0;
    errorState = false;
    super.initState();
  }

  @override
  void dispose() {
    WhatHappenedController.dispose();
    MoodList = [];
    tiredRate = 5;
    stressRate = 5;
    baseMoodRate = 0;
    errorState = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).cardColor,
        leadingWidth: 40.0,
        elevation: 0.0,
        shadowColor: Colors.transparent,
        leading: IconButton(
            onPressed: () {
              errorState = false;
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back_ios)),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: ListView(
              children: [
                AddMoodWidget(
                    widgetTitle: "오늘 하루",
                    inputAction: GestureDetector(
                      onTap: () async {
                        final DateTime? selected = await showDatePicker(
                            context: context,
                            initialEntryMode: DatePickerEntryMode.calendarOnly,
                            initialDate: initialDateInput,
                            firstDate: DateTime(1900),
                            lastDate: DateTime.now(),
                            builder: (context, child) {
                              return Theme(
                                  data: Theme.of(context).copyWith(
                                      colorScheme: ColorScheme.dark(
                                          primary: Color(0xFF444444),
                                          onPrimary: Colors.white,
                                          onSurface: Colors.white),
                                      textButtonTheme: TextButtonThemeData(
                                          style: TextButton.styleFrom(
                                              foregroundColor: Colors.white))),
                                  child: child!);
                            });
                        if (selected != null) {
                          setState(() {
                            initialDateInput = selected;
                            addDate = DateFormat('yyyy-MM-dd').format(selected);
                            formattedDate =
                                (DateFormat.yMMMd()).format(selected);
                            print(addDate);
                          });
                        }
                      },
                      child: Text(formattedDate),
                    ),
                    inputWidget: Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 0.1,
                      child: GroupButton(

                        onSelected: (button, index, isSelected) {
                          baseMoodRate = index + 1;
                          print(baseMoodRate);
                        },
                        buttons: const [
                          "매우\n불만족",
                          "불만족",
                          "보통",
                          "만족",
                          "매우\n만족",
                        ],
                        options: GroupButtonOptions(
                          selectedColor: Colors.white,
                          unselectedBorderColor: Colors.white,
                          unselectedColor: Theme.of(context).cardColor,
                          selectedTextStyle:
                              const TextStyle(color: Colors.black, fontSize: 13.0),
                          unselectedTextStyle:
                              const TextStyle(color: Colors.white, fontSize: 13.0),
                          textAlign: TextAlign.center,
                          buttonHeight: 62.0,
                          buttonWidth: 62.0,
                          borderRadius: BorderRadius.circular(10.0),
                          spacing: 10.0,
                        ),
                      ),
                    )),
                AddMoodWidget(
                    widgetTitle: "신체적 피로도",
                    inputAction: Text(tiredRate == 0 ? "0%" : "${tiredRate}0%"),
                    inputWidget: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: SliderWidget(
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
                AddMoodWidget(
                    widgetTitle: "세부 감정",
                    inputAction: const SizedBox.shrink(),
                    inputWidget: Column(
                      children: [
                        SizedBox(
                          height: 55.0,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: const [
                              MoodSelectWidget(inputMood: "😁행복한", inputNumb: 'a'),
                              MoodSelectWidget(inputMood: "🤩흥분되는", inputNumb: 'b'),
                              MoodSelectWidget(inputMood: "😍사랑스러운", inputNumb: 'c'),
                              MoodSelectWidget(inputMood: "😢슬픈", inputNumb: 'd'),
                              MoodSelectWidget(inputMood: "🥳감격스러운", inputNumb: 'j'),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 55.0,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: const [
                              MoodSelectWidget(inputMood: "🤬분노하는", inputNumb: 'e'),
                              MoodSelectWidget(inputMood: "😦공허한", inputNumb: 'h'),
                              MoodSelectWidget(inputMood: "😱공포스러운", inputNumb: 'f'),
                              MoodSelectWidget(inputMood: "🫠우울한", inputNumb: 'i'),
                              MoodSelectWidget(inputMood: "🤮혐오스러운", inputNumb: 'g'),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 55.0,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: const [
                              MoodSelectWidget(inputMood: "🤢아픈", inputNumb: 'k'),
                              MoodSelectWidget(inputMood: "😓답답한", inputNumb: 'l'),
                              MoodSelectWidget(inputMood: "🤔귀찮은", inputNumb: 'm'),
                            ],
                          ),
                        ),
                      ],
                    )),
                AddMoodWidget(
                    widgetTitle: "정신적 스트레스",
                    inputAction:
                        Text(stressRate == 0 ? "0%" : "${stressRate}0%"),
                    inputWidget: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SliderWidget(
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
                AddMoodWidget(
                    widgetTitle: "무슨 일이었나요?",
                    inputAction: const SizedBox.shrink(),
                    inputWidget: Container(
                      height: MediaQuery.of(context).size.height * 0.3,
                      decoration: BoxDecoration(
                          color: const Color(0xFF303030),
                          borderRadius: BorderRadius.circular(10.0)),
                      child: TextField(
                        controller: WhatHappenedController,
                        onChanged: (text) {
                          setState(() {
                            WhatHappenedController.text = text;
                          });
                        },
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderSide:
                                  const BorderSide(color: Colors.transparent),
                              borderRadius: BorderRadius.circular(15.0)),
                          focusedBorder: OutlineInputBorder(
                              borderSide:
                                  const BorderSide(color: Colors.transparent),
                              borderRadius: BorderRadius.circular(15.0)),
                          enabledBorder: OutlineInputBorder(
                              borderSide:
                                  const BorderSide(color: Colors.transparent),
                              borderRadius: BorderRadius.circular(15.0)),
                          hintText: "무슨 일이 있었나요?",
                          hintStyle: const TextStyle(
                              fontSize: 18.0, fontWeight: FontWeight.normal),
                        ),
                        cursorColor: Colors.grey,
                        maxLines: 11,
                        autofocus: false,
                      ),
                    )),
                errorState
                    ? Padding(
                        padding:
                            EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8.0),
                        child: Container(
                            width: MediaQuery.of(context).size.width * 0.9,
                            height: 30.0,
                            decoration: BoxDecoration(
                                color: Colors.red.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(5.0),
                                border: Border.all(color: Colors.red)),
                            child: const Center(
                              child: Text(
                                "입력된 값이 잘못되었습니다.",
                                style: TextStyle(color: Colors.red),
                              ),
                            )),
                      )
                    : SizedBox.shrink(),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      String inputMoodList = MoodList.join();
                      if (MoodList.length >= 1 && baseMoodRate != 0) {
                        postMood(baseMoodRate, addDate, inputMoodList,
                            WhatHappenedController.text, tiredRate, stressRate);
                        MoodList = [];
                        tiredRate = 5;
                        stressRate = 5;
                        baseMoodRate = 0;
                        errorState = false;
                        Navigator.pop(context);
                      } else {
                        errorState = true;
                      }
                    });
                  },
                  child: Padding(
                    padding: EdgeInsets.all(5.0),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: 60.0,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15.0)),
                      child: Center(
                        child: Text(
                          "감정 추가하기",
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ),
                    ),
                  ),
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
  const MoodSelectWidget({Key? key, this.inputMood, this.inputNumb})
      : super(key: key);

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
        padding: const EdgeInsets.symmetric(vertical: 7.0, horizontal: 6.0),
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
              padding:
                  const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
              child: Center(
                child: Text(
                  widget.inputMood,
                  style: _onpressed
                      ? const TextStyle(
                          fontSize: 15.0,
                          color: Colors.black,
                        )
                      : const TextStyle(fontSize: 15.0, color: Colors.white),
                ),
              ),
            ),
            decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.white,
                ),
                borderRadius: BorderRadius.circular(13.0),
                color: _onpressed ? Colors.white : Color(0xFF303030)),
          ),
        ));
  }
}

class AddMoodWidget extends StatelessWidget {
  AddMoodWidget(
      {required this.widgetTitle,
      required this.inputWidget,
      required this.inputAction});

  final String widgetTitle;
  final Widget inputWidget;
  final Widget inputAction;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2.0, vertical: 20.0),
      child: Container(
          decoration: BoxDecoration(
            color: Color(0xFF303030),
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 10.0),
                        child: Text(
                          widgetTitle,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 10.0),
                        child: inputAction,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: inputWidget,
                ),
              ],
            ),
          )),
    );
  }
}
