import 'package:flutter/material.dart';
import 'package:sogak/Widgets/ListViewWidget.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sogak/Screens/AddMoodScreen.dart';
import 'package:intl/intl.dart';

class ListScreen extends StatefulWidget {
  @override
  State<ListScreen> createState() => _ListScreenState();
}

Future<List<dynamic>?>? getData(String inputMonth) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? _userToken = prefs.getString('UserToken');
  var url = Uri.https('sogak-api-nraiv.run.goorm.site',
      '/api/feeling/feelings/get_monthly_feelings/$inputMonth');
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

class _ListScreenState extends State<ListScreen> {
  @override
  Widget build(BuildContext context) {
    var now = DateTime.now();
    String formatDate = DateFormat('yyyy-MM').format(now);
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
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AddMoodScreen())).then((value) {
                    setState(() {});
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
        future: getData(formatDate),
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
            return SizedBox(
              height: MediaQuery.of(context).size.height,
              child: RefreshIndicator(
                  triggerMode: RefreshIndicatorTriggerMode.onEdge,
                  color: Colors.white,
                  backgroundColor: Colors.transparent,
                  displacement: 9,
                  child: ListView.builder(
                      itemCount: FeelingDatum.length,
                      itemBuilder: (context, index) {
                        return ListViewWidget(inputData: FeelingDatum.reversed.toList()[index]);
                      }),
                  onRefresh: () async {
                    setState(() {});
                  }),
            );
          }
        },
      ),
    );
  }
}
