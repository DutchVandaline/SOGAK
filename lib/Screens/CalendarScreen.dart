import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sogak/Screens/DetailScreen.dart';
import 'dart:convert';
import 'package:intl/intl.dart';

class CalendarScreen extends StatefulWidget {
  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

Future<List<dynamic>?>? getData() async {
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

Future<List<dynamic>?>? getMonthlyData(String inputDate) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? _userToken = prefs.getString('UserToken');
  var url = Uri.https('sogak-api-nraiv.run.goorm.site',
      '/api/feeling/feelings/get_monthly_feelings/$inputDate');
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

class _CalendarScreenState extends State<CalendarScreen> {
  Map<String, List<dynamic>> monthlyDataCache = {};
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchDataAndCacheMonthlyData();
  }

  Future<void> fetchDataAndCacheMonthlyData() async {
    if (!mounted) return;
    setState(() {
      _isLoading = true;
    });
    try {
      monthlyDataCache.clear();
      List<dynamic>? responseData = await getData();
      if (responseData != null) {
        for (var data in responseData) {
          String yearMonth = data['date'].toString().substring(0, 7);
          if (!monthlyDataCache.containsKey(yearMonth)) {
            List<dynamic>? monthlyData = await getMonthlyData(yearMonth);
            if (monthlyData != null) {
              monthlyData.sort((a, b) => a['date'].compareTo(b['date']));
              monthlyDataCache[yearMonth] = monthlyData;
            }
          }
        }
      } else {
        print('Error: Response data is null');
      }
    } catch (e) {
      print('Error fetching and caching monthly data: $e');
    }

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? Center(
              child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(
                  color: Colors.white,
                ),
                SizedBox(
                  height: 20.0,
                ),
                Text("데이터를 가져오는 중입니다..."),
              ],
            ))
          : RefreshIndicator(
              triggerMode: RefreshIndicatorTriggerMode.onEdge,
              color: Colors.white,
              backgroundColor: Color(0xFF222222),
              displacement: 10,
              edgeOffset: 20.0,
              onRefresh: () async {
                await fetchDataAndCacheMonthlyData();
              },
              child: ListView.builder(
                itemCount: monthlyDataCache.length,
                itemBuilder: (context, index) {
                  String month = monthlyDataCache.keys.toList()[index];
                  return FutureBuilder(
                    future: Future.value(monthlyDataCache[month]),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(
                          child: Text(
                            "Error occurred while fetching data",
                            textAlign: TextAlign.center,
                          ),
                        );
                      } else {
                        List<dynamic> feelingData =
                            snapshot.data as List<dynamic>;
                        DateTime monthDate = DateTime.parse(month + '-01');
                        String formattedMonth =
                            DateFormat('yyyy년 MM월').format(monthDate);
                        return Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Container(
                              decoration: BoxDecoration(
                                color: Color(0xFF292929),
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              height: MediaQuery.of(context).size.height * 0.2,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding:
                                        EdgeInsets.only(left: 20.0, top: 10.0),
                                    child: Text(
                                      formattedMonth,
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 20.0, vertical: 10.0),
                                    child: GridView.builder(
                                      itemCount: feelingData.length,
                                      physics: NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      gridDelegate:
                                          SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 7,
                                        childAspectRatio: 1 / 1,
                                        mainAxisSpacing: 10,
                                        crossAxisSpacing: 10,
                                      ),
                                      itemBuilder:
                                          (BuildContext context, index) {
                                        return GestureDetector(
                                          onTap: () {
                                            bool sogakState = feelingData[index]
                                                ['sogak_bool'];
                                            sogakState
                                                ? {}
                                                : Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            DetailScreen(
                                                              inputId:
                                                                  feelingData[
                                                                          index]
                                                                      ['id'],
                                                            ))).then((value) {
                                                    setState(() {
                                                      fetchDataAndCacheMonthlyData();
                                                    });
                                                  });
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: getColorBase(
                                                  feelingData, index),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              )),
                        );
                      }
                    },
                  );
                },
              ),
            ),
    );
  }
}

Color getColorBase(List<dynamic> inputData, int index) {
  if (inputData[index]['sogak_bool'] == true) {
    return Colors.white12;
  } else {
    if (inputData[index]['base_mood'] == 1) {
      return Color.fromRGBO(73, 76, 162, 1);
    } else if (inputData[index]['base_mood'] == 2) {
      return Color.fromRGBO(0, 168, 181, 1);
    } else if (inputData[index]['base_mood'] == 3) {
      return Color.fromRGBO(116, 180, 155, 1);
    } else if (inputData[index]['base_mood'] == 4) {
      return Color.fromRGBO(255, 205, 96, 1);
    } else {
      return Color.fromRGBO(246, 114, 128, 1);
    }
  }
}
