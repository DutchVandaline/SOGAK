import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sogak/Widgets/SliderWidget.dart';
import 'dart:convert';

List<String> MoodList = [];

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
    int _stress_rate,
    bool _sogak_bool) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? _userToken = prefs.getString('UserToken');
  var url =
      Uri.https('sogak-api-nraiv.run.goorm.site', '/api/feeling/feelings/');
  var response = await http.post(url, headers: {
    'Authorization': 'Token $_userToken'
  }, body: {
    'base_mood': _base_mood,
    'date': _date,
    'detail_mood': _detail_mood,
    'what_happened': _what_happened,
    'tired_rate': _tired_rate,
    'stress_rate': _stress_rate,
    'sogak_bool': _sogak_bool,
  });
  if (response.statusCode == 200) {
    print(response.body);
    Map<String, dynamic> jsonData = json.decode(response.body);
  } else {
    print('Error: ${response.statusCode}');
    print('Error body: ${response.body}');
  }
}

class _AddMoodScreenState extends State<AddMoodScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          "Add Mood 😌",
        ),
        centerTitle: false,
        backgroundColor: Colors.transparent,
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
                Container(
                  child: Row(
                    children: [
                      BaseMoodWidget(inputNumber: 1),
                      BaseMoodWidget(inputNumber: 2),
                      BaseMoodWidget(inputNumber: 3),
                      BaseMoodWidget(inputNumber: 4),
                      BaseMoodWidget(inputNumber: 5),
                      BaseMoodWidget(inputNumber: 6),
                      BaseMoodWidget(inputNumber: 7),
                    ],
                  ),
                ),
                Container(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          MoodSelectWidget(inputMood: "😁 행복한"),
                          MoodSelectWidget(inputMood: "🥰 사랑스러운"),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          MoodSelectWidget(inputMood: "🤩 흥분되는"),
                          MoodSelectWidget(inputMood: "😭 슬픈"),
                          MoodSelectWidget(inputMood: "🤮 혐오스러운"),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          MoodSelectWidget(inputMood: "😱 공포스러운"),
                          MoodSelectWidget(inputMood: "🤬 분노하는"),
                        ],
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: SliderWidget(),
                ),
                Padding(
                  padding: EdgeInsets.all(10.0),
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MoodSelectWidget extends StatefulWidget {
  MoodSelectWidget({this.inputMood});

  final inputMood;

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
                  ? MoodList.add(widget.inputMood)
                  : MoodList.remove(widget.inputMood);
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
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            border: Border.all(color: Colors.white)
        ),
        child: Padding(padding: EdgeInsets.all(18.0),
          child: Text("${widget.inputNumber}"),)
    );
  }
}
