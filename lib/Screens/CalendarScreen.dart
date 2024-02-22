import 'package:flutter/material.dart';
import 'package:sogak/Screens/DetailScreen.dart';
import 'package:sogak/Screens/SogakDetailScreen.dart';
import 'package:sogak/Services/Api_services.dart';
import 'package:intl/intl.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({Key? key}) : super(key: key);

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
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
      List<dynamic>? responseData = await ApiService.getData();
      if (responseData != null) {
        for (var data in responseData) {
          String yearMonth = data['date'].toString().substring(0, 7);
          if (!monthlyDataCache.containsKey(yearMonth)) {
            List<dynamic>? monthlyData =
                await ApiService.getMonthlyData(yearMonth);
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
      appBar: AppBar(
        title: const Text(
          "감정 달력 🙏",
          style: TextStyle(fontSize: 25.0),
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        automaticallyImplyLeading: false,
        centerTitle: false,
        leadingWidth: 40.0,
        elevation: 0.0,
        shadowColor: Colors.transparent,
      ),
      body: _isLoading
          ? const Center(
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
          : monthlyDataCache.isEmpty
              ? const Center(
                  child: Text("아직 추가된 감정이 없습니다.\n새로운 감정을 추가해보세요."),
                )
              : RefreshIndicator(
                  triggerMode: RefreshIndicatorTriggerMode.onEdge,
                  color: Colors.white,
                  backgroundColor: const Color(0xFF222222),
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
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                                child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return const Center(
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
                              padding: const EdgeInsets.all(10.0),
                              child: Container(
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF292929),
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 20.0, top: 10.0),
                                        child: Text(
                                          formattedMonth,
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20.0, vertical: 10.0),
                                        child: GridView.builder(
                                          itemCount: feelingData.length,
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          shrinkWrap: true,
                                          gridDelegate:
                                              const SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 7,
                                            childAspectRatio: 1 / 1,
                                            mainAxisSpacing: 10,
                                            crossAxisSpacing: 10,
                                          ),
                                          itemBuilder:
                                              (BuildContext context, index) {
                                            return GestureDetector(
                                              onTap: () {
                                                bool sogakState =
                                                    feelingData[index]
                                                        ['sogak_bool'];
                                                sogakState
                                                    ? showSogakDialog(
                                                        context,
                                                        feelingData[index]
                                                            ['id'])
                                                    : Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                DetailScreen(
                                                                  inputId:
                                                                      feelingData[
                                                                              index]
                                                                          [
                                                                          'id'],
                                                                ))).then(
                                                        (value) {
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
                                      const SizedBox(
                                        height: 10.0,
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

  void showSogakDialog(BuildContext context, int inputId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('소각된 감정'),
          content: const Text(
            '이미 소각된 감정입니다. 열람하시겠습니까?\n소각된 감정은 수정 및 삭제가 불가능합니다.',
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
                Navigator.pop(context);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            SogakDetailScreen(inputId: inputId)));
              },
              child: const Text(
                '확인',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }
}

Color getColorBase(List<dynamic> inputData, int index) {
  if (inputData[index]['sogak_bool'] == true) {
    return Colors.white12;
  } else {
    if (inputData[index]['base_mood'] == 1) {
      return const Color.fromRGBO(73, 76, 162, 1);
    } else if (inputData[index]['base_mood'] == 2) {
      return const Color.fromRGBO(0, 168, 181, 1);
    } else if (inputData[index]['base_mood'] == 3) {
      return const Color.fromRGBO(116, 180, 155, 1);
    } else if (inputData[index]['base_mood'] == 4) {
      return const Color.fromRGBO(255, 205, 96, 1);
    } else {
      return const Color.fromRGBO(246, 114, 128, 1);
    }
  }
}
