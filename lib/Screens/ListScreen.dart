import 'package:flutter/material.dart';
import 'package:sogak/Services/Api_services.dart';
import 'package:sogak/Widgets/ListViewWidget.dart';
import 'package:intl/intl.dart';
import 'package:sogak/Screens/AddMoodScreen.dart';

List<String> dropDownList = [];
var now = DateTime.now();
String formatDate = DateFormat('yyyy-MM').format(now);

class ListScreen extends StatefulWidget {
  const ListScreen({Key? key}) : super(key: key);

  @override
  State<ListScreen> createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  Map<String, List<dynamic>> monthlyDataCache = {};
  bool _isLoading = false;

  Future<void> fetchDataAndCacheMonthlyData() async {
    List<String> uniqueList = [];
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
          if (!uniqueList.contains(yearMonth)) {
            uniqueList.add(yearMonth);
          }
        }
        setState(() {
          dropDownList = uniqueList.toList();
          formatDate = dropDownList.isNotEmpty ? dropDownList.first : formatDate;
        });
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
  void initState() {
    fetchDataAndCacheMonthlyData();
    super.initState();
  }

  @override
  void dispose() {
    dropDownList = [];
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "감정 기록 👏",
          style: TextStyle(fontSize: 25.0),
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        centerTitle: false,
        leadingWidth: 40.0,
        elevation: 0.0,
        shadowColor: const Color(0xFF222222),
        actions: [
          DropdownButton(
              value: formatDate,
              items: dropDownList.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(
                    value,
                    style: const TextStyle(
                      fontSize: 15.0,
                    ),
                  ),
                );
              }).toList(),
              onChanged: (String? value) {
                value == null
                    ? setState(() {
                        formatDate = DateFormat('yyyy-MM').format(now);
                      })
                    : setState(() {
                        formatDate = value;
                      });
              }),
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AddMoodScreen())).then((value) {
                    setState(() {
                      fetchDataAndCacheMonthlyData();
                    });
                  });
                },
                icon: const Icon(
                  Icons.add,
                  size: 30.0,
                )),
          )
        ],
      ),
      body: FutureBuilder(
        future: ApiService.getMonthlyData(formatDate),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child: CircularProgressIndicator(
              color: Colors.white,
            ));
          } else if (snapshot.hasError) {
            return const Center(
                child: Text(
              "잠시 후 다시 시도해 주세요.",
              textAlign: TextAlign.center,
            ));
          } else {
            if (snapshot.data == null) {
              return const Center(
                child: Text('아직 추가된 감정이 없습니다.'),
              );
            }
            List<dynamic> FeelingDatum = snapshot.data as List<dynamic>;
            return FeelingDatum.isEmpty
                ? const Center(
                    child: Text("아직 추가된 감정이 없습니다."),
                  )
                : SizedBox(
                    height: MediaQuery.of(context).size.height,
                    child: RefreshIndicator(
                        triggerMode: RefreshIndicatorTriggerMode.onEdge,
                        color: Colors.white,
                        backgroundColor: Colors.transparent,
                        displacement: 9,
                        child: ListView.builder(
                            itemCount: FeelingDatum.length,
                            itemBuilder: (context, index) {
                              return ListViewWidget(
                                  inputData:
                                      FeelingDatum.reversed.toList()[index]);
                            }),
                        onRefresh: () async {
                          setState(() {
                            fetchDataAndCacheMonthlyData();
                          });
                        }),
                  );
          }
        },
      ),
    );
  }
}
