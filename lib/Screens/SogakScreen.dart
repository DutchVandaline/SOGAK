import 'package:flutter/material.dart';
import 'package:sogak/Screens/SogakStatusScreen.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'dart:ui';

import 'package:sogak/Services/Api_services.dart';

bool sogakState = false;
int selectedId = -1;

class SogakScreen extends StatefulWidget {
  const SogakScreen({Key? key}) : super(key: key);

  @override
  State<SogakScreen> createState() => _SogakScreenState();
}


class _SogakScreenState extends State<SogakScreen> {
  bool sogakState = false;

  @override
  void initState(){
    setState(() {selectedId = -1;});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xff252527),
        appBar: AppBar(
          backgroundColor: const Color(0xff252527),
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
                    decoration: const BoxDecoration(
                        image: DecorationImage(
                      fit: BoxFit.fitWidth,
                      alignment: FractionalOffset.bottomCenter,
                      image: AssetImage('assets/images/flame.gif'),
                    )),
                  ),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
                  child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "소각",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 30.0,
                            ),
                          ),
                          const SizedBox(
                            height: 5.0,
                          ),
                          Text(
                            "당신의 마음 속 감정을 소각하세요.\n소각하려면 화염을 길게 누르세요.",
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
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Padding(
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
                                              color: const Color(0xFF666666)),
                                        ),
                                        child: FutureBuilder(
                                          future: ApiService.getMovetoSogakData(),
                                          builder: (context, snapshot) {
                                            if (snapshot.connectionState ==
                                                ConnectionState.waiting) {
                                              return const Center(
                                                  child:
                                                      CircularProgressIndicator());
                                            } else if (snapshot.hasError) {
                                              return const Center(
                                                  child: Text("잠시 후 다시 시도해 주세요.",textAlign: TextAlign.center,)
                                              );
                                            } else {
                                              if (snapshot.data == null) {
                                                return const Center(
                                                  child:
                                                      Text('아직 추가된 감정이 없습니다.'),
                                                );
                                              }
                                              List<dynamic> FeelingDatum = snapshot.data as List<dynamic>;
                                              return ListView.builder(
                                                  itemCount: FeelingDatum.length,
                                                  itemBuilder: (context, index) {
                                                    String inputDate = FeelingDatum[index]['date'];
                                                    int baseMoodState = FeelingDatum[index]['base_mood'];
                                                    DateTime originalDate = DateTime.parse(inputDate);
                                                    String formattedDateMonth = DateFormat('MMM').format(originalDate).toUpperCase();
                                                    String formattedDateDate = DateFormat('d').format(originalDate);
                                                    if (FeelingDatum[index]['movetosogak_bool'] == true) {
                                                      return GestureDetector(
                                                          onTap: () {
                                                            setState(() {
                                                              selectedId =
                                                                  FeelingDatum[
                                                                          index]
                                                                      ['id'];
                                                              print(
                                                                  selectedId);
                                                            });
                                                          },
                                                          onLongPress: () {
                                                            setState(() {
                                                              selectedId =
                                                                  FeelingDatum[
                                                                          index]
                                                                      ['id'];
                                                              ApiService.backToList(
                                                                  selectedId);
                                                              selectedId = -1;
                                                            });
                                                          },
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(3.0),
                                                            child: Container(
                                                              decoration: BoxDecoration(
                                                                  color: Colors
                                                                      .transparent
                                                                      .withOpacity(
                                                                          0.1),
                                                                  borderRadius:
                                                                      BorderRadius.circular(
                                                                          10.0)),
                                                              child: Padding(
                                                                padding: const EdgeInsets.symmetric(
                                                                    vertical:
                                                                        8.0,
                                                                    horizontal:
                                                                        10.0),
                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    Padding(
                                                                      padding:
                                                                          const EdgeInsets.symmetric(vertical: 8.0),
                                                                      child:
                                                                          Container(
                                                                        width:
                                                                            5.0,
                                                                        height:
                                                                            50.0,
                                                                        color: baseMoodState <= 3
                                                                            ? Colors.grey
                                                                            : Colors.red,
                                                                      ),
                                                                    ),
                                                                    Padding(
                                                                      padding:
                                                                          const EdgeInsets.symmetric(horizontal: 5.0),
                                                                      child: Container(
                                                                          child: Column(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.center,
                                                                        children: [
                                                                          Text(
                                                                            formattedDateMonth,
                                                                            style: const TextStyle(fontSize: 15.0),
                                                                            textAlign: TextAlign.center,
                                                                          ),
                                                                          Text(
                                                                            formattedDateDate,
                                                                            style: const TextStyle(fontSize: 25.0),
                                                                            textAlign: TextAlign.center,
                                                                          ),
                                                                        ],
                                                                      )),
                                                                    ),
                                                                    Padding(
                                                                        padding:
                                                                            const EdgeInsets.symmetric(horizontal: 8.0),
                                                                        child: SizedBox(
                                                                            width: MediaQuery.of(context).size.width * 0.65,
                                                                            child: Column(
                                                                              mainAxisAlignment: MainAxisAlignment.start,
                                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                                              children: [
                                                                                const Text(
                                                                                  "무슨 일이 있었나요?",
                                                                                  style: TextStyle(fontWeight: FontWeight.bold),
                                                                                ),
                                                                                FeelingDatum[index]['what_happened'] == null || FeelingDatum[index]['what_happened'] == ""
                                                                                    ? const Text(
                                                                                        "기록된 일이 없습니다.",
                                                                                        maxLines: 3,
                                                                                        overflow: TextOverflow.ellipsis,
                                                                                      )
                                                                                    : Text(
                                                                                        utf8.decode(FeelingDatum[index]['what_happened'].codeUnits),
                                                                                        overflow: TextOverflow.ellipsis,
                                                                                        maxLines: 2,
                                                                                      ),
                                                                              ],
                                                                            ))),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          ));
                                                    } else {
                                                      return const SizedBox.shrink();
                                                    }
                                                  });
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
                                const Padding(
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
                                            color: const Color(0xFF666666)),
                                      ),
                                      child: FutureBuilder(
                                        future: ApiService.selectedSogakData(selectedId),
                                        builder: (context, snapshot) {
                                          if (selectedId == -1) {
                                            return const Center(
                                              child: Text("선택된 감정이 없습니다."),
                                            );
                                          } else {
                                            if (snapshot.connectionState ==
                                                ConnectionState.waiting) {
                                              return const Center(
                                                  child:
                                                      CircularProgressIndicator());
                                            } else if (snapshot.hasError) {
                                              return const Text("불러오는데 에러가 발생했습니다.");
                                            } else {
                                              var SogakData = snapshot.data;
                                              print(SogakData);
                                              if (SogakData != null) {
                                                return SogakListWidget(
                                                    inputFeeling: SogakData);
                                              } else {
                                                return const Text(
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
                                      if (selectedId == -1) {
                                        print("not possible");
                                      } else {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                SogakStatusScreen(
                                              inputId: selectedId,
                                            ),
                                          ),
                                        );
                                      }
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
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
                                        child: const Center(
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
                                  padding: const EdgeInsets.all(8.0),
                                  child: IconButton(
                                      onPressed: () {
                                        setState(() {
                                          sogakState = false;
                                        });
                                      },
                                      icon: const Icon(Icons.close, size: 40.0)),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  )
                : const SizedBox.shrink(),
          ],
        ));
  }
}

class SogakListWidget extends StatefulWidget {
  SogakListWidget({Key? key, required this.inputFeeling}) : super(key: key);

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
    String decodedWhatHappened =
        utf8.decode(widget.inputFeeling['what_happened'].codeUnits);

    return Container(
      child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
          child: Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Container(
                    width: 5.0,
                    height: 50.0,
                    color: baseMoodState <= 3 ? Colors.grey : Colors.red,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5.0),
                  child: Container(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        formattedDateMonth,
                        style: const TextStyle(fontSize: 15.0),
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        formattedDateDate,
                        style: const TextStyle(fontSize: 25.0),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  )),
                ),
                Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.65,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "무슨 일이 있었나요?",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            widget.inputFeeling['what_happened'] == null ||
                                    widget.inputFeeling['what_happened'] == ""
                                ? const Text(
                                    "기록된 일이 없습니다.",
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                  )
                                : Text(
                                    decodedWhatHappened,
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
