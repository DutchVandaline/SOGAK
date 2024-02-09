import 'package:flutter/material.dart';
import 'package:sogak/Widgets/ListViewWidget.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sogak/Screens/AddMoodScreen.dart';

class ListScreen extends StatefulWidget {
  @override
  State<ListScreen> createState() => _ListScreenState();
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

class _ListScreenState extends State<ListScreen> {
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
        shadowColor: Colors.transparent,
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 8.0),
            child: IconButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => AddMoodScreen()));
                },
                icon: Icon(
                  Icons.add,
                  size: 30.0,
                )),
          )
        ],
      ),
      body: FutureBuilder(
        future: getData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text("안정성을 위해 서버를 확인 중 입니다.\n잠시 후 다시 시도해 주세요.",textAlign: TextAlign.center,)
            );
          } else {
            if (snapshot.data == null) {
              return Center(
                child: Text('아직 추가된 감정이 없습니다.'),
              );
            }
            List<dynamic> FeelingDatum = snapshot.data as List<dynamic>;
            if (FeelingDatum != null) {
              return RefreshIndicator(
                  triggerMode: RefreshIndicatorTriggerMode.onEdge,
                  color: Colors.white,
                  displacement: 9,
                  child: ListView.builder(
                      itemCount: FeelingDatum.length,
                      itemBuilder: (context, index) {
                        print(FeelingDatum[index]['sogak_bool']);
                        return ListViewWidget(inputData: FeelingDatum[index]);
                      }),
                  onRefresh: () async {
                    setState(() {});
                  });
            } else {
              return Text('No data available');
            }
          }
        },
      ),
    );
  }
}
