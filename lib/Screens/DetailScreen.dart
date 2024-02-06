import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class DetailScreen extends StatefulWidget {
  DetailScreen({required this.inputId});

  final int inputId;

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

Future<dynamic>? getDatabyId(int inputId) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? _userToken = prefs.getString('UserToken');
  var url = Uri.https(
      'sogak-api-nraiv.run.goorm.site', '/api/feeling/feelings/$inputId/');
  var response =
      await http.get(url, headers: {'Authorization': 'Token $_userToken'});

  if (response.statusCode == 200) {
    dynamic responseData = json.decode(response.body);
    if (responseData.isNotEmpty) {
      return responseData;
    } else {
      return null;
    }
  } else {
    throw Exception('Error: ${response.statusCode}, ${response.body}');
  }
}

Future<void> patchMovetoSogak(int _inputId) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? _userToken = prefs.getString('UserToken');
  var url = Uri.https(
      'sogak-api-nraiv.run.goorm.site', '/api/feeling/feelings/$_inputId/');
  var response = await http.patch(url, headers: {
    'Authorization': 'Token $_userToken'
  }, body: {
    "movetosogak_bool": 'true',
  });
  if (response.statusCode == 200) {
    print(response.body);
  } else {
    print('Error: ${response.statusCode}');
    print('Error body: ${response.body}');
  }
}

class _DetailScreenState extends State<DetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        centerTitle: false,
        leadingWidth: 40.0,
        elevation: 0.0,
        shadowColor: Colors.transparent,
        automaticallyImplyLeading: false,
        title: Text("Detail 🔍"),
        actions: [
          IconButton(
              onPressed: () {
                patchMovetoSogak(widget.inputId);
                Navigator.pop(context);
              },
              icon: Icon(Icons.local_fire_department_outlined)),
          IconButton(onPressed: () {}, icon: Icon(Icons.edit)),
          IconButton(onPressed: () {}, icon: Icon(Icons.delete_forever)),

        ],
      ),
      body: FutureBuilder(
        future: getDatabyId(widget.inputId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Text("불러오는데 에러가 발생했습니다.");
          } else {
            var SogakData = snapshot.data;
            print(SogakData);
            if (SogakData != null) {
              return Text("yeah");
            } else {
              return Text('No data available');
            }
          }
        },
      ),
    );
  }
}
