import 'package:flutter/material.dart';
import 'package:sogak/Widgets/MoodTagWidget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:ui';

bool sogakState = false;
int selectedId = -1;

class SogakScreen extends StatefulWidget {
  @override
  State<SogakScreen> createState() => _SogakScreenState();
}

Future<List<dynamic>?>? getMovetoSogakData() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? _userToken = prefs.getString('UserToken');
  var url =
      Uri.https('sogak-api-nraiv.run.goorm.site', '/api/feeling/feelings/');
  var response =
      await http.get(url, headers: {'Authorization': 'Token $_userToken'});

  if (response.statusCode == 200) {
    List<dynamic> responseData = json.decode(response.body);
    if (responseData.isNotEmpty) {
      return responseData;
    } else {
      return null;
    }
  } else {
    throw Exception('Error: ${response.statusCode}, ${response.body}');
  }
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


//TODO: Patch에 add와 같은 문제 발생. 아마 json.encode 문제일듯
Future<void> patchMoodtoSogak(int _inputId, String _afterMemo ) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? _userToken = prefs.getString('UserToken');
  var url = Uri.https('sogak-api-nraiv.run.goorm.site', '/api/feeling/feelings/$_inputId');
  var response = await http.patch(url, headers: {
    'Authorization': 'Token $_userToken'
  }, body: {
    "movetosogak_bool":jsonEncode(false),
    "sogak_bool":jsonEncode(true),
    "after_memo":"$_afterMemo"
  });
  if (response.statusCode == 200) {
    print(response.body);
  } else {
    print('Error: ${response.statusCode}');
    print('Error body: ${response.body}');
  }
}

class _SogakScreenState extends State<SogakScreen> {
  bool sogakState = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xff252527),
        appBar: AppBar(
          title: const Text(
            "소각로 🔥",
            style: TextStyle(fontSize: 25.0),
          ),
          backgroundColor: Color(0xff252527),
          centerTitle: false,
          leadingWidth: 40.0,
          elevation: 0.0,
          shadowColor: Colors.transparent,
        ),
        body: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onLongPress: () {
                    setState(() {
                      sogakState = true;
                    });
                  },
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.34,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                      fit: BoxFit.fitWidth,
                      alignment: FractionalOffset.bottomCenter,
                      image: AssetImage('assets/images/flame.gif'),
                    )),
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
                  child: Container(
                      height: MediaQuery.of(context).size.height * 0.12,
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "소각 消却",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 30.0,
                            ),
                          ),
                          SizedBox(
                            height: 5.0,
                          ),
                          Text(
                            "당신의 마음 속, 불편했던 감정을 소각하세요.\n소각하려면 화염을 길게 누르세요.",
                            style: Theme.of(context).textTheme.bodyMedium,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      )),
                )
              ],
            ),
            sogakState
                ? ClipRect(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 8.0, sigmaY: 8.0),
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(vertical: 5.0),
                                  child: Text(
                                    "소각할 감정 목록",
                                    style: TextStyle(fontSize: 20.0),
                                  ),
                                ),
                                ClipRect(
                                  child: BackdropFilter(
                                    filter: ImageFilter.blur(
                                        sigmaX: 8.0, sigmaY: 8.0),
                                    child: Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.9,
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.3,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                          border: Border.all(
                                              color: Color(0xFF666666)),
                                        ),
                                        child: FutureBuilder(
                                          future: getMovetoSogakData(),
                                          builder: (context, snapshot) {
                                            if (snapshot.connectionState ==
                                                ConnectionState.waiting) {
                                              return Center(
                                                  child:
                                                      CircularProgressIndicator());
                                            } else if (snapshot.hasError) {
                                              return Text("불러오는데 에러가 발생했습니다.");
                                            } else {
                                              List<dynamic> FeelingDatum =
                                                  snapshot.data
                                                      as List<dynamic>;
                                              if (FeelingDatum != null) {
                                                return ListView.builder(
                                                    itemCount:
                                                        FeelingDatum.length,
                                                    itemBuilder: (context, index) {
                                                      String inputDate = FeelingDatum[index]['date'];
                                                      int baseMoodState = FeelingDatum[index]['base_mood'];
                                                      DateTime originalDate = DateTime.parse(inputDate);
                                                      String formattedDateMonth =
                                                      DateFormat('MMM').format(originalDate).toUpperCase();
                                                      String formattedDateDate = DateFormat('d').format(originalDate);
                                                      if (FeelingDatum[index]['movetosogak_bool'] == true) {
                                                        return GestureDetector(
                                                          onTap: () {
                                                            setState(() {
                                                              selectedId = FeelingDatum[index]['id'];
                                                              print(selectedId);
                                                            });
                                                          },
                                                          child: Container(
                                                            child: Padding(
                                                                padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
                                                                child: Container(
                                                                  decoration: BoxDecoration(
                                                                      border: Border(bottom: BorderSide(color: Colors.grey))),
                                                                  child: Row(
                                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                    children: [
                                                                      Padding(
                                                                        padding: EdgeInsets.symmetric(vertical: 8.0),
                                                                        child: Container(
                                                                          width: 5.0,
                                                                          height: 50.0,
                                                                          color: baseMoodState <= 3 ? Colors.red : Colors.grey,
                                                                        ),
                                                                      ),
                                                                      Padding(
                                                                        padding: EdgeInsets.symmetric(horizontal: 5.0),
                                                                        child: Container(
                                                                            child: Column(
                                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                                              children: [
                                                                                Text(
                                                                                  formattedDateMonth,
                                                                                  style: TextStyle(fontSize: 15.0),
                                                                                  textAlign: TextAlign.center,
                                                                                ),
                                                                                Text(
                                                                                  formattedDateDate,
                                                                                  style: TextStyle(fontSize: 25.0),
                                                                                  textAlign: TextAlign.center,
                                                                                ),
                                                                              ],
                                                                            )),
                                                                      ),
                                                                      Padding(
                                                                          padding: EdgeInsets.symmetric(horizontal: 8.0),
                                                                          child: Container(
                                                                            width: MediaQuery.of(context).size.width * 0.65,
                                                                              child: Column(
                                                                                mainAxisAlignment: MainAxisAlignment.start,
                                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                                children: [
                                                                                  Text(
                                                                                    "무슨 일이 있었나요?",
                                                                                    style: TextStyle(fontWeight: FontWeight.bold),
                                                                                  ),
                                                                                  FeelingDatum[index]['what_happened'] == null ||
                                                                                      FeelingDatum[index]['what_happened'] == ""
                                                                                      ? Text(
                                                                                    "기록된 일이 없습니다.",
                                                                                    maxLines: 3,
                                                                                    overflow: TextOverflow.ellipsis,
                                                                                  )
                                                                                      : Text(
                                                                                    FeelingDatum[index]['what_happened'],
                                                                                    overflow: TextOverflow.ellipsis,
                                                                                    maxLines: 2,
                                                                                  ),
                                                                                ],
                                                                              ))),
                                                                    ],
                                                                  ),
                                                                )),
                                                          ),
                                                        );


                                                      }
                                                    });
                                              } else {
                                                return Text(
                                                    'No data available');
                                              }
                                            }
                                          },
                                        )),
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(vertical: 5.0),
                                  child: Text(
                                    "선택된 감정",
                                    style: TextStyle(fontSize: 20.0),
                                  ),
                                ),
                                ClipRect(
                                  child: BackdropFilter(
                                    filter: ImageFilter.blur(
                                        sigmaX: 8.0, sigmaY: 8.0),
                                    child: Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.9,
                                      height: 100.0,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        border: Border.all(
                                            color: Color(0xFF666666)),
                                      ),
                                      child: FutureBuilder(
                                        future: selectedSogakData(selectedId),
                                        builder: (context, snapshot) {
                                          if (selectedId == -1) {
                                            return Center(child: Text("선택된 감정이 없습니다."),);
                                          } else {
                                            if (snapshot.connectionState ==
                                                ConnectionState.waiting) {
                                              return Center(
                                                  child:
                                                      CircularProgressIndicator());
                                            } else if (snapshot.hasError) {
                                              return Text("불러오는데 에러가 발생했습니다.");
                                            } else {
                                              var SogakData = snapshot.data;
                                              print(SogakData);
                                              if (SogakData != null) {
                                                return SogakListWidget(
                                                    inputFeeling: SogakData);
                                              } else {
                                                return Text(
                                                    'No data available');
                                              }
                                            }
                                          }
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        patchMoodtoSogak(selectedId, "sogaked");
                                        selectedId = -1;
                                      });

                                    },
                                    child: Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Container(
                                        height: 50.0,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.9,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        ),
                                        child: Center(
                                          child: Text(
                                            "소각하기",
                                            style: TextStyle(
                                                fontSize: 20.0,
                                                color: Colors.black),
                                          ),
                                        ),
                                      ),
                                    )),
                                Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: IconButton(
                                      onPressed: () {
                                        setState(() {
                                          sogakState = false;
                                        });
                                      },
                                      icon: Icon(Icons.close, size: 40.0)),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  )
                : SizedBox.shrink(),
          ],
        ));
  }
}

class SogakListWidget extends StatefulWidget {
  SogakListWidget({required this.inputFeeling});

  var inputFeeling;

  @override
  State<SogakListWidget> createState() => _SogakListWidgetState();
}

class _SogakListWidgetState extends State<SogakListWidget> {
  @override
  Widget build(BuildContext context) {
    String inputDate = widget.inputFeeling['date'];
    int baseMoodState = widget.inputFeeling['base_mood'];
    DateTime originalDate = DateTime.parse(inputDate);
    String formattedDateMonth =
        DateFormat('MMM').format(originalDate).toUpperCase();
    String formattedDateDate = DateFormat('d').format(originalDate);

    return Container(
      child: Padding(
          padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
          child: Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: Container(
                    width: 5.0,
                    height: 50.0,
                    color: baseMoodState <= 3 ? Colors.red : Colors.grey,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5.0),
                  child: Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            formattedDateMonth,
                            style: TextStyle(fontSize: 15.0),
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            formattedDateDate,
                            style: TextStyle(fontSize: 25.0),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      )),
                ),
                Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.65,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "무슨 일이 있었나요?",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            widget.inputFeeling['what_happened'] == null ||
                                widget.inputFeeling['what_happened'] == ""
                                ? Text(
                              "기록된 일이 없습니다.",
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            )
                                : Text(
                              widget.inputFeeling['what_happened'],
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            ),
                          ],
                        ))),
              ],
            ),
          )),
    );
  }
}
