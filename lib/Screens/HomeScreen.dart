import 'package:flutter/material.dart';
import 'package:sogak/Screens/AddMoodScreen.dart';
import 'package:sogak/Screens/SubHomeScreen.dart';
import 'package:sogak/Screens/SubHomeScreenDummy.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

String inputText = "";

class HomeScreen extends StatefulWidget {

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

Future<Map<String, dynamic>?> getRecentData() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? _userToken = prefs.getString('UserToken');
  var url = Uri.https('sogak-api-nraiv.run.goorm.site', '/api/feeling/feelings/');
  var response = await http.get(url, headers: {'Authorization': 'Token $_userToken'});

  if (response.statusCode == 200) {
    List<dynamic> responseData = json.decode(response.body);
    if (responseData.isNotEmpty) {
      return responseData.first as Map<String, dynamic>;
    } else {
      return null;
    }
  } else {
    throw Exception('Error: ${response.statusCode}, ${response.body}');
  }
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    getRecentData();
    int currentHour = DateTime.now().hour;
    if (currentHour >= 12 && currentHour < 18) {
      setState(() {
        inputText = "좋은 오후입니다 👋";
      });
    } else if (currentHour >= 18 && currentHour <= 23) {
      setState(() {
        inputText = "고요한 저녁입니다 👋";
      });
    } else if (currentHour >= 0 && currentHour < 6) {
      setState(() {
        inputText = "평화로운 밤입니다 👋";
      });
    } else if (currentHour >= 6 && currentHour < 12) {
      setState(() {
        inputText = "좋은 아침입니다 👋";
      });
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(
          inputText,
          style: TextStyle(fontSize: 25.0),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 8.0),
            child: IconButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => AddMoodScreen())).then((value){setState(() {});});
                },
                icon: Icon(
                  Icons.add,
                  size: 30.0,
                )),
          )
        ],
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        automaticallyImplyLeading: false,
        centerTitle: false,
        leadingWidth: 40.0,
        elevation: 0.0,
        shadowColor: Colors.transparent,
      ),
      body: FutureBuilder(
        future: getRecentData(),
        builder: (context, snapshot) {
          if(snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator()
            );
          } else if(snapshot.hasError) {
            return Center(
              child: Text("잠시 후 다시 시도해 주세요.",textAlign: TextAlign.center,),
            );
          } else {
            if (snapshot.data == null) {
              return SubHomeScreenDummy();
            }
            Map<String, dynamic>? lastData = snapshot.data as Map<String, dynamic>;
            if (lastData != null) {
              return SubHomeScreen(responseData: lastData,);
            } else {
              return Text('No data available');
            }
          }
        },
      ),
    );
  }
}
