import 'package:flutter/material.dart';
import 'package:sogak/Screens/AddMoodScreen.dart';
import 'package:sogak/Screens/SubHomeScreen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

String inputText = "";

class HomeScreen extends StatefulWidget {
  const HomeScreen({required this.userToken});

  final String userToken;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

Future<Map<String, dynamic>?> getLastData(String _userToken) async {
  var url =
      Uri.https('sogak-api-nraiv.run.goorm.site', '/api/feeling/feelings/');
  var response =
      await http.get(url, headers: {'Authorization': 'Token $_userToken'});

  if (response.statusCode == 200) {
    List<dynamic> responseData = json.decode(response.body);
    if (responseData.isNotEmpty) {
      return responseData.last as Map<String, dynamic>;
    } else {
      return null; // Return null if the list is empty
    }
  } else {
    throw Exception('Error: ${response.statusCode}, ${response.body}');
    return null;
  }
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    getLastData(widget.userToken);
    int currentHour = DateTime.now().hour;
    if (currentHour >= 12 && currentHour < 18) {
      setState(() {
        inputText = "Good Afternoon 👋";
      });
    } else if (currentHour >= 18 && currentHour <= 23) {
      setState(() {
        inputText = "Good Evening 👋";
      });
    } else if (currentHour >= 0 && currentHour < 6) {
      setState(() {
        inputText = "Peaceful Night 👋";
      });
    } else if (currentHour >= 6 && currentHour < 12) {
      setState(() {
        inputText = "Good Morning 👋";
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
                      MaterialPageRoute(builder: (context) => AddMoodScreen()));
                },
                icon: Icon(
                  Icons.add,
                  size: 30.0,
                )),
          )
        ],
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        centerTitle: false,
        leadingWidth: 40.0,
        elevation: 0.0,
        shadowColor: Colors.transparent,
      ),
      body: FutureBuilder(
        future: getLastData(widget.userToken),
        builder: (context, snapshot) {
          String statusText = "";
          if(snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator()
            );
          } else if(snapshot.hasError) {
            return Text("Error : ${snapshot.error}");
          }  else {
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
