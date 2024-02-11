import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sogak/Widgets/MoodTagWidget.dart';
import 'package:sogak/Widgets/WarmingSentences.dart';
import 'package:sogak/Screens/SplashScreen.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'dart:math';
import 'dart:core';

String sogakState = "";
bool fadeAway = true;
bool sogakComplete = false;
double sogakStatus = 0.0;

class SogakStatusScreen extends StatefulWidget {
  SogakStatusScreen({required this.inputId});

  final int inputId;

  @override
  State<SogakStatusScreen> createState() => _SogakStatusScreenState();
}

Future<dynamic>? selectedSogakData(int inputId) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? _userToken = prefs.getString('UserToken');
  var url = Uri.https(
      'sogak-api-nraiv.run.goorm.site', '/api/feeling/feelings/$inputId');
  var response =
      await http.get(url, headers: {'Authorization': 'Token $_userToken'});

  if (response.statusCode == 200) {
    dynamic responseData = json.decode(response.body);
    if (responseData.isNotEmpty) {
      print(responseData);
      return responseData;
    } else {
      return null;
    }
  } else {
    throw Exception('Error: ${response.statusCode}, ${response.body}');
  }
}

Future<void> patchMoodtoSogak(int _inputId, String _afterMemo) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? _userToken = prefs.getString('UserToken');
  var url = Uri.https(
      'sogak-api-nraiv.run.goorm.site', '/api/feeling/feelings/$_inputId/');
  var response = await http.patch(url, headers: {
    'Authorization': 'Token $_userToken'
  }, body: {
    "movetosogak_bool": 'false',
    "sogak_bool": 'true',
    "after_memo": "$_afterMemo"
  });
  if (response.statusCode == 200) {
    print(response.body);
  } else {
    print('Error: ${response.statusCode}');
    print('Error body: ${response.body}');
  }
}

class _SogakStatusScreenState extends State<SogakStatusScreen>{

  @override
  void initState(){
    checkSogak();
    super.initState();
  }


  void checkSogak() async {
    setState(() {
      sogakState = "소각로 확인 중...";
      sogakStatus = 0.2;
    });
    await Future.delayed(Duration(seconds: 3));
    setState(() {
      fadeAway = false;
      sogakState = "감정 소각 중...";
      sogakStatus = 0.8;
    });
    await Future.delayed(Duration(seconds: 4));
    setState(() {
      patchMoodtoSogak(widget.inputId, "");
      sogakStatus = 1.0;
      sogakState = "감정 소각 완료";
      sogakComplete = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    int randomNumb = Random().nextInt(WarmingSentences.length);
    return Scaffold(
        backgroundColor: Color(0xff252527),
        body: SafeArea(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Flexible(
              flex: 2,
              child: Padding(
                  padding: EdgeInsets.all(5.0),
                  child: Container(
                    alignment: Alignment.bottomCenter,
                    height: MediaQuery.of(context).size.height * 0.2,
                    child: FutureBuilder(
                      future: selectedSogakData(widget.inputId),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: Text(""));
                        } else if (snapshot.hasError) {
                          print(widget.inputId);
                          print(snapshot.data);
                          return Center(
                            child: Text("불러오는데 에러가 발생했습니다."),
                          );
                        } else {
                          var SogakData =
                              snapshot.data as Map<String, dynamic>?;
                          print(SogakData!['detail_mood']);
                          List<dynamic> detailMoodList =
                              SogakData!['detail_mood'];
                          List<int> splitDigitsList = detailMoodList
                              .expand((number) =>
                                  number.toString().split('').map(int.parse))
                              .toList();
                          if (SogakData != null) {
                            return Wrap(
                                spacing: 1.0,
                                children:
                                    createMoodTagWidgets(splitDigitsList));
                          } else {
                            return Text('No data available');
                          }
                        }
                      },
                    ),
                  )),
            ),
            Flexible(
              flex: 5,
              child: Container(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.only(bottom: 5.0),
                    child: Text(
                      sogakState,
                      style: TextStyle(fontSize: 20.0),
                    ),
                  ),
                  Padding(
                      padding: EdgeInsets.only(
                        bottom: 10.0,
                      ),
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.6,
                        child: LinearProgressIndicator(
                          value: sogakStatus,
                          backgroundColor: Colors.grey,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                          minHeight: 10.0,
                        ),
                      )),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height * 0.34,
                        decoration: BoxDecoration(
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
              )),
            ),
            Flexible(
                flex: 2,
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.2,
                  width: MediaQuery.of(context).size.width * 0.9,
                  alignment: Alignment.topCenter,
                  child: Text(
                    WarmingSentences[randomNumb],
                    textAlign: TextAlign.center,
                  ),
                )),
            Flexible(
                flex: 1,
                child: GestureDetector(
                  onTap: () {
                    if(sogakComplete){
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SplashScreen()),
                              (route) => false);
                    } else{
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
                        style: Theme.of(context).textTheme.titleSmall!.copyWith(
                            fontWeight: FontWeight.normal,
                            color: sogakComplete ? Colors.black : Colors.grey),
                      ),
                    ),
                  ),
                )),
          ],
        )));
  }
}

List<MoodTagWidget> createMoodTagWidgets(List<int> splitDigitsList) {
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
